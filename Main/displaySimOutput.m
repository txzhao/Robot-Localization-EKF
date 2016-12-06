%
% DISPLAYSIMOUTPUT(SIMOUTFILE, MAPFILE, SENSORPOSE)
%
% 
function displaySimOutput(simoutfile, mapfile, sensorpose)

if nargin < 1
  disp('Usage: displaySimOutput(simoutfile, opt:mapfile, opt:sensorpose)');
  return
end

if nargin < 2
  mapfile = [];
end

if nargin < 3
  sensorpose = zeros(3,1);
end

clf
if ~isempty(mapfile) 
  d = load(mapfile);
  margin = 5;
  xmin = min(d(:,2)) - margin;
  xmax = max(d(:,2)) + margin;
  ymin = min(d(:,3)) - margin;
  ymax = max(d(:,3)) + margin;

  drawLandmarkMap(mapfile);
else
  xmin = 5;
  xmax = 25;
  ymin = -5;
  ymax = 15;
end

hold on

axis([xmin xmax ymin ymax])

fid = fopen(simoutfile,'r');
if fid <= 0
  disp(sprintf('Failed to open simoutput file "%s"\n',simoutfile));
  return
end

h = [];

title('Circels: landmarks, red cross: true pos, blue dots: odom pos')

while 1
  line = fgetl(fid);
  if ~ischar(line)
    break
  end

  values = sscanf(line, '%f');

  t = values(1);
  odom = values(2:6);
  truepose = values(7:9);
  n = values(10);
 
  plot(odom(1), odom(2), 'b.', truepose(1), truepose(2), 'rx')

  if n > 0

    RO = [cos(odom(3)) -sin(odom(3)); 
          sin(odom(3)) cos(odom(3))];
    RW = [cos(truepose(3)) -sin(truepose(3)); 
          sin(truepose(3)) cos(truepose(3))];

    xsO = odom(1:3) + [RO * sensorpose(1:2); sensorpose(3)];
    xsW = truepose(1:3) + [RW * sensorpose(1:2); sensorpose(3)];
  
    bearings = values(12:3:end);
    ranges = values(13:3:end);

    for k = 1:length(h)
      delete(h(k))
    end
    h = [];  

    for k = 1:n
      h1 = plot(xsO(1)+[0 ranges(k)*cos(xsO(3)+bearings(k))], ...
                xsO(2)+[0 ranges(k)*sin(xsO(3)+bearings(k))], 'b');
      h2 = plot(xsW(1)+[0 ranges(k)*cos(xsW(3)+bearings(k))], ...
                xsW(2)+[0 ranges(k)*sin(xsW(3)+bearings(k))], 'r');
      h = [h h1 h2];
    end
  end

  axis([xmin xmax ymin ymax])      

  drawnow
end

fclose(fid);