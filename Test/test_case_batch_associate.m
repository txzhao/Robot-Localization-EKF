function valid = test_case_batch_associate()
load test_case_batch_associate.mat;
errs_c = ones(1,NUM_TEST);
errs_outliers = ones(1,NUM_TEST);
errs_nu = ones(1,NUM_TEST);
errs_h = ones(1,NUM_TEST);
for i = 1 : NUM_TEST
    q = diag(Q(:,i));
    Lambda_m = LAMBDA(i);
    z = reshape(Z(:,i),2,NUM_OBS);
    mu_bar = MU_BAR(:,i);
    sigma_bar = reshape(SIGMA_BAR(:,i),3,3);
    try
        [c,outlier, nu_bar, H_bar] =  batch_associate(mu_bar,sigma_bar,z,M,Lambda_m,q);
    catch exception
        break;
    end
    errs_c(i) = sum(c(:) ~= C(:,i));
    errs_outliers(i) = sum(outlier(:) ~= OUTLIER(:,i));
    errs_nu = norm(nu_bar(:) - NU_BAR(:,i));
    errs_h = norm(H_bar(:) - H_BAR(:,i));
end
mse_errs_c = mean(errs_c .^2);
mse_errs_outliers = mean(errs_outliers .^2);
mse_errs_nu = mean(errs_nu .^2);
mse_errs_h = mean(errs_h .^2);
THRESH_VALID = 1e-20;

valid_c = mse_errs_c < THRESH_VALID;
valid_nu = mse_errs_nu < THRESH_VALID;
valid_outliers = mse_errs_outliers < THRESH_VALID;
valid_h = mse_errs_h < THRESH_VALID;

valid = valid_c && valid_nu && valid_outliers && valid_h;

if ~valid_c
    display(sprintf('associations computed in associate.m seem to be wrong, mse=%f',mse_errs_c));
end

if ~valid_outliers
    display(sprintf('outliers computed in associate.m seems to be wrong, mse=%f',mse_errs_outliers));
end

if ~valid_nu
    display(sprintf('nu_bar computed in associate.m seems to be wrong, mse=%f',mse_errs_nu));
end


if ~valid_h
    display(sprintf('H_bar computed in associate.m seems to be wrong, mse=%f',mse_errs_h));
end
end