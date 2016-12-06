function valid = test_case_update()
load test_case_update.mat;
errs_mu = ones(1,NUM_TEST);
errs_sigma = ones(1,NUM_TEST);

for i = 1 : NUM_TEST
    mu_bar = MU_BAR(:,i);
    sigma_bar = reshape(SIGMA_BAR(:,i),3,3);
    h_bar = reshape(H_BAR(:,i),2,3);
    s_bar = reshape(S_BAR(:,i),2,2);
    nu_bar = NU_BAR(:,i);
    try
        [mu_bar_n,sigma_bar_n] = update(mu_bar,sigma_bar,h_bar,s_bar,nu_bar);
    catch exception
        break;
    end
    errs_mu(i) = norm(MU_BAR_N(:,i) - mu_bar_n);
    errs_sigma(i) = norm(SIGMA_BAR_N(:,i) - sigma_bar_n(:));
end
mse_errs_mu = mean(errs_mu .^2);
mse_errs_sigma = mean(errs_sigma .^2);

THRESH_VALID = 1e-20;

valid_mu = mse_errs_mu < THRESH_VALID;
valid_sigma = mse_errs_sigma < THRESH_VALID;

valid = valid_mu && valid_sigma;

if ~valid_mu
    display(sprintf('mu computed in update.m seems to be wrong, mse=%f',mse_errs_mu));
end

if ~valid_sigma
    display(sprintf('sigma computed in update.m seems to be wrong, mse=%f',mse_errs_sigma));
end

end