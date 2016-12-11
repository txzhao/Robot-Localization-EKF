% function [mu_bar,sigma_bar] = predict(mu,sigma,u,R)
% This function should perform the prediction step.
% Inputs:
%           mu(t-1)           3X1   
%           sigma(t-1)        3X3
%           u(t)              3X1
%           R                 3X3
% Outputs:   
%           mu_bar(t)         3X1
%           sigma_bar(t)      3X3
function [mu_bar,sigma_bar] = predict(mu,sigma,u,R)
% mu_bar = g(u(t), mu(t-1)) = mu(t-1) + u(t)
mu_bar = mu + u;

% G(1,3) = -u(2) = -v*delta_t*sin(theta)
% G(2,3) = u(1) = v*delta_t*cos(theta)
G = [1 0 -u(2); 0 1 u(1); 0 0 1];
sigma_bar = G * sigma * G' + R;

end
