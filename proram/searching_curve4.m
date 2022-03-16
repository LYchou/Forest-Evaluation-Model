clc
clear
% 設定說明
A_discription = '';
% 執行日期 (用於存圖的檔名)
run_date = '20210617';
%固定變數------------------------
V=9.91e9;
F=V*0.18;c=0.078;
r=0.06;
T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;%破產成本
tax_firm=0.21; 
%type_default=1;
type_default=2; % 當期薪水不backward，只加在當期的方式建構DB
%T_exercise=T-3; %三年後才可以履約
T_exercise=3; 
method=1;
tax_employee=0.05; 
Beta=0.125;
step_unit=1;
step=T*step_unit;
t=1/step_unit;
Total_cost=V*0.0012021*T;%<使用柏宏之後找到的數據(論文中固定成本的數字)>
%Total_cost=V*0.0094*T;%<使用panda說的上界(論文中固定成本的數字)>

X=8e6;
O=1000;

% %為把履約張數切得更稠密
% X=8e6/10;
% O=1000*10;

% gamma=[0.05 0.1 0.3 0.7];
% sigma = [0.05,0.082,0.2,0.3];

% 調整 mu 和 sigma
mu=0.125;
mu = transfer_mu(mu,V,F,c);
Beta = mu; % 跟著 mu 一起調整

percent=0.1;
gamma = 0.1;
sigma = 0.1;



%%
type_tax_employee = 1;

percent = 0.5;

previousWage_right = Total_cost;
threshold = 3000;
ESO_type=1;
fixed_cost=Total_cost;
searchTimes=25;
wage = 0;
N = 0;
[wage_minError,ESO_minError,Salary_minError,minError_parameter] = binary_search_fixed_cost4(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div);
wage_ub = wage_minError;
wage_range = wage_minError/200;

ESO_list = [];
Salary_list = [];
wage_list = [];
N=50;
wage = 0;
count = 0;
Q_list = [];
P_list = [];
while 1
    count = count+1;
    disp(['N=',num2str(count)]);
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node_100,Nodes_100,firm_tree_value_100,default_boundary_value]=Employee_Stock_Option4(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    q_correct=sum( length(find(1<0))+length(find(Q<0)) );
    p_correct=sum( length(find(1<0))+length(find(P<0)) );
    Q_list = [Q_list;q_correct];
    P_list = [P_list;p_correct];
    wage_list = [wage_list,wage];
    ESO_list = [ESO_list,ESO];
    Salary_list = [Salary_list,Salary];
    wage = wage+wage_range;
    if(wage>Total_cost/T),break,end
end
%%
figure(1)
plot(wage_list,ESO_list);
xlabel('wage');
ylabel('ESO')
title('percent=0.25,N=50')
figure(2)
plot(wage_list,Salary_list)
xlabel('wage');
ylabel('Salary')
title('percent=0.25,N=50')
figure(3)
plot(wage_list,Salary_list+ESO_list)
xlabel('wage');
ylabel('ESO+Salary')
title('percent=0.25,N=50')



