% function [c,outlier, nu_bar, H_bar] = batch_associate(mu_bar,sigma_bar,z,M,Lambda_m,Q)
% This function should perform the maximum likelihood association and outlier detection.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           Q                   2X2
%           z(t)                2Xn
%           M                   2XN
%           Lambda_m            1X1
% Outputs: 
%           c(t)                1Xn
%           outlier             1Xn
%           nu_bar(t)           2nX1
%           H_bar(t)            2nX3
function [c, outlier, nu_bar, H_bar] = batch_associate(mu_bar, sigma_bar, z, M, Lambda_m, Q)
c = [];
outlier = [];
nu_bar = [];
H_bar = [];
for i = 1 : size(z, 2)
    [c_i, outlier_i, nu_i, S_i, H_i] = associate(mu_bar, sigma_bar, z(:, i), M, Lambda_m, Q);
    c(i) = c_i;
    outlier(i) = outlier_i;
    nu_bar = [nu_bar; nu_i(:, c_i)];
    H_bar = [H_bar; H_i(:, :, c_i)];
end
end
