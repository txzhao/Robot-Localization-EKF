function valid =test_case_calculate_odometry()
load test_case_odo.mat;
errs = ones(1,NUM_TEST);
for i = 1 : NUM_TEST
    try
       tu = calculate_odometry(E_R(i),E_L(i),E_T,B,R_R,R_L,delta_t,MU(:,i));
    catch exception
        break;
    end
    errs(i) = norm(tu - U(:,i));
end
mse_err = mean(errs .^2);
THRESH_VALID = 1e-20;
valid = mse_err < THRESH_VALID;
   
end