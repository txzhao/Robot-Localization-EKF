function valid =test_case_jacobian_function()
load test_case_jac.mat;
errs = ones(1,NUM_TEST);
for i = 1 : NUM_TEST
    try
        TH = jacobian_observation_model(X(:,i),M,J(i),Z(:,i),1);
    catch exception
        break;
    end
    errs(i) = norm(TH - H(i*2-1:i*2,:));
end
mse_err = mean(errs .^2);
THRESH_VALID = 1e-20;
valid = mse_err < THRESH_VALID;
   
end