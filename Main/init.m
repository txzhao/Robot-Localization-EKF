% function [mu, sigma, R, Q, Lambda_M] = init()
% This function initializes the parameters of the filter.
% Outputs:
%			mu(0):			3X1
%			sigma(0):		3X3
%			R:				3X3
%			Q:				2X2
function [mu, sigma, R, Q, Lambda_M] = init()
mu = [0; 0; 0]; % initial estimate of state
sigma = 1e - 10*diag([1 1 1]); % initial covariance matrix
delta_m = 0.9999;
Lambda_M = chi2inv(delta_m, 2);
R = [0.01^2 0 0; 0 0.01^2 0; 0 0 (pi/180)^2];
Q = [0.2^2 0; 0 (0.2)^2];
end
