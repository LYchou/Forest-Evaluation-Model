function sigma_asset = transfer_sigma(sigma_stock,Asset,Debt)
Equity = Asset-Debt;
sigma_asset = (sigma_stock*Equity) / Asset ;
end