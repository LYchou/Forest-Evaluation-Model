clc
clear
%固定變數------------------------
V=9.91e9;
F=V*0.18;
c=0.078;
r=0.06;

X=8e6;
O=1000;

T=10;
Div=0 ;
additional_wealth=0;
w=0.4296;%破產成本
tax_firm=0.21; 
type_default=1;
T_exercise=3; 
method=1;
tax_employee=0.05; 
percent=0.5;
Beta=0.125;
Total_cost=V*0.0012021*T;%<使用柏宏之後找到的數據(論文中固定成本的數字)>
Total_CE = 52421244.4442340;
%%%
sigma = [0.1000 0.12 0.14 0.16 0.1857 0.2714 0.3571 0.4429 0.5286 0.6143 0.7000];
mu= 0.03:0.03:0.3;
% 調整 mu 和 sigma (將股價的報酬率和波動度改成資產的)
for i = 1:length(mu)
    mu(i) = transfer_mu(mu(i),V,F,c);
end
for i = 1:length(sigma)
    sigma(i) = transfer_sigma(sigma(i),V,F);
end

mu = [mu,0.5,0.8,0.9];
sigma = [sigma,0.8,0.9];

threshold_ratio=0.05;

%%%
wage_small=670000;
table1=zeros(length(mu),length(sigma));
for i=1:length(mu)
    for j=1:length(sigma)
        disp(' ');
        table1(i,j) = calculate_Maxdt(r,mu(i),sigma(j),wage_small,F,c,tax_firm,T,type_default,threshold_ratio);
    end
end

wage_large=V*0.0012021*exp(r*T);
table2=zeros(length(mu),length(sigma));
for i=1:length(mu)
    for j=1:length(sigma)
        disp(' ');
        table2(i,j) = calculate_Maxdt(r,mu(i),sigma(j),wage_large,F,c,tax_firm,T,type_default,threshold_ratio);
    end
end
