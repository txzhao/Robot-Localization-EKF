% function runlocalization_track(simoutfile, mapfile,show_estimate,show_gth,show_odo,verbose)
% This function is the entrance point to the code. 
function runlocalization_track(simoutfile,mapfile,show_estimate,show_gth,show_odo,verbose)
if nargin <6
    verbose = 0; % Verbose = 0: no visual output, 1: estimates and/or odometry and/or groundtruth, 2: (1)+ extra info, 3: (2)+ observation lines
end
%%
% Parameter Initialization
[mu,sigma,R,Q,Lambda_M] = init();
E_T = 2048;
B= 0.35;
R_L = 0.1;
R_R = 0.1; 
%%
% Code initialization
% clc;
tic;
dataset_base = 'DataSets/';
margin = 5;
sensorpose = [0;0;0];

d = load([dataset_base mapfile]);

if verbose
    fige = figure(1); % Estimated Movement and Map
    clf(fige);
    
    xmin = min(d(:,2)) - margin;
    xmax = max(d(:,2)) + margin;
    ymin = min(d(:,3)) - margin;
    ymax = max(d(:,3)) + margin;
   
    figure(fige);
    drawLandmarkMap([dataset_base mapfile]);
    hold on;
    axis([xmin xmax ymin ymax])
    title('Estimated Map and Movement');
end
hcovs = [];
if verbose > 1
    figure(fige);
    hcovs = plot(0,0,'r','erasemode','xor');
end

M = d(:,2:3)';
Map_IDS = d(:,1)';
fid = fopen([dataset_base simoutfile],'r');
if fid <= 0
  disp(sprintf('Failed to open simoutput file "%s"\n',simoutfile));
  return
end
flines = {};
while 1
    line = fgetl(fid);
    if ~ischar(line)
        break
    end
    flines = {flines{:} line};
end
fclose(fid);

h = [];
ho = [];
he = [];
hg = [];
errpose = [];
odom = zeros(3,1);
count = 0;
gth = [];
sigma_save = sigma(:);
total_outliers = 0;
t = 0;
enc = [0;0];
%%
% Main loop
while 1
    count = count + 1;
    if count > length(flines)
        break;
    end
    line = flines{count};
    values = sscanf(line, '%f');
    pt = t;
    t = values(1);
    delta_t = t - pt;
    odom = values(2:4);
    penc = enc;
    enc = values(5:6);
    denc = enc - penc;
    truepose = values(7:9);
    gth = [gth truepose];
    n = values(10);
    if (n > 0) 
        bearings = values(12:3:end);
        ranges = values(13:3:end);
        ids = values(11:3:end);
    else
        bearings = [];
        ranges = [];
        ids = [];
    end
    u = calculate_odometry(denc(1),denc(2),E_T,B,R_R,R_L,delta_t,mu);
    z = [ranges';bearings'];
    known_associations = ids';
    [mu,sigma,outliers] = ekf_localize(mu,sigma,R,Q,z,known_associations,u,M,Lambda_M,Map_IDS,count);
        
    total_outliers = total_outliers + outliers;
    sigma_save = [sigma_save sigma(:)];
    rerr = truepose - mu;

    rerr(3) = mod(rerr(3)+pi,2*pi)-pi;
    errpose = [errpose rerr];
    for k = 1:length(h)
        delete(h(k))
    end
    h = [];
   
    if n > 0 && show_estimate && verbose > 0
        plot(mu(1), mu(2), 'rx')
        RE = [cos(mu(3)) -sin(mu(3)); 
              sin(mu(3)) cos(mu(3))];

        xsE = mu(1:3) + [RE * sensorpose(1:2); sensorpose(3)];

        he = [];  
        if verbose > 2
            for k = 1:n
                lmpe = xsE(1:2) +[ranges(k)*cos(xsE(3)+bearings(k));ranges(k)*sin(xsE(3)+bearings(k))];
                    h3 = plot(xsE(1)+[0 ranges(k)*cos(xsE(3)+bearings(k))], ...
                            xsE(2)+[0 ranges(k)*sin(xsE(3)+bearings(k))], 'r');
                    he = [he h3];
                plot(lmpe(1),lmpe(2),'r.');
            end
        end

        pcov= make_covariance_ellipses(mu,sigma);
        set(hcovs,'xdata',pcov(1,:),'ydata',pcov(2,:));
        title(sprintf('t= %d, total outliers=%d, current outliers=%d',count,total_outliers,outliers));
    end
        
    if n > 0 && show_gth&& verbose > 0
        plot(truepose(1), truepose(2), 'gx');
        RG = [cos(truepose(3)) -sin(truepose(3)); 
              sin(truepose(3)) cos(truepose(3))];
       
        xsG = truepose(1:3) + [RG * sensorpose(1:2); sensorpose(3)];

        hg = [];  
        if verbose > 2        
            for k = 1:n
                    h2 = plot(xsG(1)+[0 ranges(k)*cos(xsG(3)+bearings(k))], ...
                            xsG(2)+[0 ranges(k)*sin(xsG(3)+bearings(k))], 'g');

                    hg = [hg h2];
            end
        end 
    end
   
    if n > 0 && show_odo&& verbose > 0 
        plot(odom(1), odom(2), 'bx');
        RO = [cos(odom(3)) -sin(odom(3)); 
              sin(odom(3)) cos(odom(3))];
       
        xsO = odom(1:3) + [RO * sensorpose(1:2); sensorpose(3)];

        ho = [];  

        if verbose > 2
            for k = 1:n
                lmpo = xsO(1:2) +[ranges(k)*cos(xsO(3)+bearings(k));ranges(k)*sin(xsO(3)+bearings(k))];
                    h1 = plot(xsO(1)+[0 ranges(k)*cos(xsO(3)+bearings(k))], ...
                            xsO(2)+[0 ranges(k)*sin(xsO(3)+bearings(k))], 'g');
                    ho = [ho h1];
                plot(lmpo(1),lmpo(2),'b.');
            end
        end 
    end
  
    h = [ho he hg];
    
    drawnow limitrate nocallbacks
end
time = toc;
maex = mean(abs(errpose(1,:)));
mex = mean(errpose(1,:));
maey = mean(abs(errpose(2,:)));
mey = mean(errpose(2,:));
maet = mean(abs(errpose(3,:)));
met = mean(errpose(3,:));
display(sprintf('mean error(x, y, theta)=(%f, %f, %f)\nmean absolute error=(%f, %f, %f)\ntotal_time =%f',mex,mey,met, maex,maey,maet,time));
if verbose > 1    
    figure(2);
    clf;
    subplot(3,1,1);
    plot(errpose(1,:));
    title(sprintf('error on x, mean error=%f, mean absolute err=%f',mex,maex));
    subplot(3,1,2);
    plot(errpose(2,:));
    title(sprintf('error on y, mean error=%f, mean absolute err=%f',mey,maey));
    subplot(3,1,3);
    plot(errpose(3,:));
    title(sprintf('error on theta, mean error=%f, mean absolute err=%f',met,maet));
    
    figure(3);
    clf;
    subplot(3,1,1);
    plot(sigma_save(1,:));
    title('\Sigma(1,1)');
    subplot(3,1,2);
    plot(sigma_save(5,:));
    title('\Sigma(2,2)');
    subplot(3,1,3);
    plot(sigma_save(9,:));
    title('\Sigma(3,3)');
end
