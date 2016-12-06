function valid = test_case_associate()
load test_case_associate.mat;
errs_c = ones(1,NUM_TEST);
errs_outliers = ones(1,NUM_TEST);
errs_nu = ones(1,NUM_TEST);
errs_s = ones(1,NUM_TEST);
errs_h = ones(1,NUM_TEST);
for i = 1 : NUM_TEST
    q = diag(Q(:,i));
    Lambda_m = LAMBDA(i);
    z_i = Z(:,i);
    mu_bar = MU_BAR(:,i);
    sigma_bar = reshape(SIGMA_BAR(:,i),3,3);
    try
        [c,outlier, nu, s, h] = associate(mu_bar,sigma_bar,z_i,M,Lambda_m,q);
    catch exception
        break;
    end
    errs_c(i) = c ~= C(i);
    errs_outliers(i) = outlier ~= OUTLIERS(i);
    errs_nu(i) = norm(nu(:) - NU(:,i));
    errs_s(i) = norm(s(:) - S(:,i));
    errs_h(i) = norm(h(:) - H(:,i));
end
mse_errs_c = mean(errs_c .^2);
mse_errs_outliers = mean(errs_outliers .^2);
mse_errs_nu = mean(errs_nu .^2);
mse_errs_s = mean(errs_s .^2);
mse_errs_h = mean(errs_h .^2);
THRESH_VALID = 1e-20;

valid_c = mse_errs_c < THRESH_VALID;
valid_nu = mse_errs_nu < THRESH_VALID;
valid_outliers = mse_errs_outliers < THRESH_VALID;
valid_s = mse_errs_s < THRESH_VALID;
valid_h = mse_errs_h < THRESH_VALID;

valid = valid_c && valid_nu && valid_outliers && valid_s && valid_h;

if ~valid_c
    display(sprintf('association computed in associate.m seems to be wrong, mse=%f',mse_errs_c));
end

if ~valid_outliers
    display(sprintf('outliers computed in associate.m seems to be wrong, mse=%f',mse_errs_outliers));
end

if ~valid_nu
    display(sprintf('nu computed in associate.m seems to be wrong, mse=%f',mse_errs_nu));
end

if ~valid_s
    display(sprintf('S computed in associate.m seems to be wrong, mse=%f',mse_errs_s));
end

if ~valid_h
    display(sprintf('H computed in associate.m seems to be wrong, mse=%f',mse_errs_h));
end
end
