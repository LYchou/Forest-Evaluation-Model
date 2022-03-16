V=9.91e9;
F=V*0.18;c=0.078;
r=0.06;
sigma=0.3;

T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;%破產成本
tax_firm=0.21; 
type_default=1;
T_exercise=3; 
method=1;
tax_employee=0.05; 

Beta=0.125;
step_unit=1;
step=T*step_unit;
t=1/step_unit;

%
% %為把履約張數切得更稠密
% X=8e6/10;
% O=1000*10;
% %還改了N，最多可以100


mu = 0.125;
gamma = 0.5;

% 調整 mu 和 sigma (將股價的報酬率和波動度改成資產的)
for i = 1:length(mu)
    mu(i) = transfer_mu(mu(i),V,F,c);
end
sigma = transfer_sigma(sigma,V,F);

percent=0.1;

% O = 1000*10;
% % 履約價設定為 不發ESO價平
% X=8e6/10;
% 
% N = 1000;

O = 1000;
% 履約價設定為 不發ESO價平
X=8e6;
N = 100;

wage = 0;

% NQSO
type_tax_employee=1;

[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node_100,Nodes_100,firm_tree_value_100,default_boundary_value]=Employee_Stock_Option4_SequentialExercise(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);

% QSO
type_tax_employee=2;
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node_100,Nodes_100,firm_tree_value_100,default_boundary_value]=Employee_Stock_Option_ISO4_SequentialExercise(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);