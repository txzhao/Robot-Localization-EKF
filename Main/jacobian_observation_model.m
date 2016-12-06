% function H = jacobian_observation_model(mu_bar,M,j,z,i)
% This function is the implementation of the H function
% Inputs:
%           mu_bar(t)   3X1
%           M           2XN
%           j           1X1 which M column
%           z_hat       2Xn
%           i           1X1  which z column
% Outputs:  
%           H           2X3
function H = jacobian_observation_model(mu_bar,M,j,z_hat,i)
h11 = (mu_bar(1) - M(1,j)) / z_hat(1,i);
h12 = (mu_bar(2) - M(2,j)) / z_hat(1,i);
h21 = -(mu_bar(2) - M(2,j)) / (z_hat(1,i))^2;
h22 = (mu_bar(1) - M(1,j)) / (z_hat(1,i))^2;
H = [h11 h12 0; h21 h22 -1];
end
