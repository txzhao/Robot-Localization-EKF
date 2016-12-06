function valid = test_case_predict()
load test_case_prediction.mat;
errs_mu = ones(1,NUM_TEST);
errs_sigma = ones(1,NUM_TEST);
for i = 1 : NUM_TEST
    mu = MU(:,i);
    sigma = reshape(SIGMA(:,i),3,3);
    u = U(:,i);
    r = diag(R(:,i));
    try
        [mu_bar,sigma_bar] = predict(mu,sigma,u,r);
    catch exception
        break;
    end
    errs_mu(i) = norm(MU_BAR(:,i) - mu_bar(:));
    errs_sigma(i) = norm(SIGMA_BAR(:,i) - sigma_bar(:));
end
mse_errs_mu = mean(errs_mu .^2);
mse_errs_sigma = mean(errs_sigma .^2);
THRESH_VALID = 1e-20;
valid_mu = mse_errs_mu < THRESH_VALID;
valid_sigma = mse_errs_sigma < THRESH_VALID;;

if ~valid_mu
    display(sprintf('the mu calculated in predict seems to be incorrect, mse=%f',mse_errs_mu));
end

if ~valid_sigma
    display(sprintf('the sigma calculated in predict seems to be incorrect, mse=%f',mse_errs_sigma));
end
valid = valid_mu && valid_sigma;

end