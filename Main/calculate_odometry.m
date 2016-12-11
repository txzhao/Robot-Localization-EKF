% function u = calculate_odometry(e_R, e_L, E_T, B, R_R, R_L, delta_t, mu)
% This function should calculate the odometry information
% Inputs:
%           e_L(t):         1X1     --- encoder ticks for the left wheel in time step t
%           e_R(t):         1X1     --- encoder ticks for the right wheel in time step t
%           E_T:            1X1     --- number of encoder ticks per wheel revolution 
%           B:              1X1     --- distance between the contact points of the wheels
%           R_L:            1X1     --- radius of the left wheel
%           R_R:            1X1     --- radius of the right wheel
%           delta_t:        1X1     --- time interval
%           mu(t-1):        3X1     --- state of the robot in the last time step
% Outputs:
%           u(t):           3X1
function u = calculate_odometry(e_R, e_L, E_T, B, R_R, R_L, delta_t, mu)
if ~delta_t
    u = [0; 0; 0];
    return;
end

w_R = (2 * pi * e_R) / (E_T * delta_t);
w_L = (2 * pi * e_L) / (E_T * delta_t);
w = (w_R * R_R - w_L * R_L) / B;
v = (w_R * R_R + w_L * R_L) / 2;

% u(1) - dx, u(2) - dy, u(3) - d(theta)
u = [v * delta_t * cos(mu(3)); v * delta_t * sin(mu(3)); w * delta_t];

end
