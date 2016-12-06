function valid = test_case_observation_model()
load test_case_obs.mat;
errs = ones(1,NUM_TEST);
for i = 1 : NUM_TEST
    try
        tz = observation_model(X(:,i),M,J(i));
    catch exception
        break;
    end
    errs(i) = norm(tz - Z(:,i));
end   
mse_err = mean(errs.^2);
THRESH_VALID = 1e-20;
valid = mse_err < THRESH_VALID;

end