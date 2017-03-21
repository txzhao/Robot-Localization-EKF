% function [c,outlier, nu, S, H] = associate(mu_bar,sigma_bar,z_i,M,Lambda_m,Q)
% This function should perform the maximum likelihood association and outlier detection.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           Q                   2X2
%           z_i(t)              2X1
%           M                   2XN
%           Lambda_m            1X1
% Outputs: 
%           c(t)                1X1
%           outlier             1X1
%           nu^i(t)             2XN
%           S^i(t)              2X2XN
%           H^i(t)              2X3XN
function [c, outlier, nu, S, H] = associate(mu_bar, sigma_bar, z_i, M, Lambda_m, Q)
z_hat = [];
nu = [];
S = [];
H = [];
P = [];

for j = 1 : size(M, 2)
  z_hat(:, j) = observation_model(mu_bar, M, j);
  H(:, :, j) = jacobian_observation_model(mu_bar, M, j, z_hat(:, j), 1);
  S(:, :, j) = H(:, :, j)*sigma_bar*H(:, :, j)' + Q;
  nu(:, j) = z_i - z_hat(:, j);
  nu(2, j) = mod(nu(2, j) + pi, 2*pi) - pi;
  P(j) = 1/sqrt(det(2*pi*S(:, :, j))) * exp((-1/2) * nu(:, j)' * inv(S(:, :, j)) * nu(:, j));
end

[P_max c] = max(P);

DM = nu(:, c)' * inv(S(:, :, c)) * nu(:, c);
if DM > Lambda_m
  outlier = 1;
else
  outlier = 0;
end

end
