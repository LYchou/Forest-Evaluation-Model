function mu_asset = transfer_mu(mu_stock,Asset,Debt,coupon)
Equity = Asset-Debt;
mu_asset = (mu_stock*Equity+coupon*Debt) / Asset ;
end