clc
clear
% 設定說明
A_discription = '';
% 執行日期 (用於存圖的檔名)
run_date = '20210604';
%固定變數------------------------
V=9.91e9;
F=V*0.18;c=0.078;
r=0.06;
T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;%破產成本
tax_firm=0.21; 
type_default=1;
%T_exercise=T-3; %三年後才可以履約
T_exercise=3; 
method=1;
tax_employee=0.05; 
percent=0.5;
Beta=0.125;
step_unit=4;
step=T*step_unit;
t=1/step_unit;
Total_cost=V*0.0012021*T;%<使用柏宏之後找到的數據(論文中固定成本的數字)>

% X=8e6;
% O=1000;

%為把履約張數切得更稠密
X=8e6/10;
O=1000*10;

mu=0.125; % or 0.06

N_list = [180,120,170,30]; 
gamma_list=[0.1,0.3,0.1,0.3];
sigma_list = [0.07,0.11,0.18,0.2];

% NQSO
ESO_type=1;
%type_tax_employee=1;
fixed_cost = Total_cost;
searchTimes = 70;
threshold = fixed_cost*(2.5/100000);
previousWage_right = Total_cost;
result = [];
%%
for i=1:length(N_list)
    disp(['i = ',num2str(i)])
    N = N_list(i);
    sigma = sigma_list(i);
    gamma =gamma_list(i);
    [wage_minError,ESO_minError,Salary_minError,minError_parameter] = binary_search_fixed_cost(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div);
    result_temp = [N,sigma,gamma,wage_minError,ESO_minError,Salary_minError,minError_parameter];
    result = [result;result_temp];
end
