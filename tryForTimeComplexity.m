clc
clear
%固定變數------------------------
V=[9.91e9 ];
F=V*0.18;c=0.078;
r=0.06;
mu=0.6;
gamma=0.5;
sigma=[0.3];
X=8e6;
O=1000;
T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;%破產成本
tax_firm=0.21; 
type_default=1;type_tax_employee=1;
%T_exercise=T-3; %三年後才可以履約
T_exercise=3; 
method=1;
tax_employee=0.05; 
Beta=0.125;


wage=670000;
N=3;
T=10;



%比層數
t0 = clock; percent=0.5;step_unit=4; step=T*step_unit;t=1/step_unit;
% 三層 %step=T*step_unit=10*4=4
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,0,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
a1 = etime(clock, t0)
%
t0 = clock; percent=0.25;step_unit=4;  step=T*step_unit;t=1/step_unit;
% 五層%step=T*step_unit=10*4=40
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,0,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
a2 = etime(clock, t0)
a2/a1
%比期數
t0 = clock; percent=0.25;step_unit=4;  step=T*step_unit;t=1/step_unit;
% 五層%step=T*step_unit=10*4=40
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,0,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
b1 = etime(clock, t0)	
%
t0 = clock; percent=0.25;step_unit=6;  step=T*step_unit;t=1/step_unit;
% 五層 %step=T*step_unit=10*6=60
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,0,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
b2 = etime(clock, t0)	
b2/b1