% function p= make_covariance_ellipses(x,P)
% This function is used to draw uncertainty ellipses in figures.
function p= make_covariance_ellipses(x,P)
    % compute ellipses for plotting state covariances. (Tim Bailey)
    N= 10;
    inc= 2*pi/N;
    phi= 0:inc:2*pi;

    lenx= length(x);
    lenf= (lenx-3)/2;
    p= zeros (2,(lenf+1)*(N+2));

    ii=1:N+2;
    p(:,ii)= make_ellipse(x(1:2), P(1:2,1:2), 2, phi);

    ctr= N+3;
    for i=1:lenf
        ii= ctr:(ctr+N+1);
        jj= 2+2*i; jj= jj:jj+1;

        p(:,ii)= make_ellipse(x(jj), P(jj,jj), 2, phi);
        ctr= ctr+N+2;
    end
end

function p= make_ellipse(x,P,s, phi)
    % make a single 2-D ellipse of s-sigmas over phi angle intervals . (Tim
    % Bailey)
    r= sqrtm(P);
    a= s*r*[cos(phi); sin(phi)];
    p(2,:)= [a(2,:)+x(2) NaN];
    p(1,:)= [a(1,:)+x(1) NaN];
end
