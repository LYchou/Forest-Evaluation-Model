clc
clear
%©T©w≈‹º∆------------------------
V=9000000;

F=5000000;c=0.06;r=0.02;
mu=0.02;
X=10000;N=10;O=100; 
T=[5,10];
T=5;
% Div=[0 0.25 0.5 0.75 ] ;
Div=0 ;
T_exercise=3;
wage=50000;
% wage=[0 0.2,0.4,0.6,0.8 1];
% wage=2;

% gamma=[0.25,0.5,0.75,1];
w=0.4;tax_firm=0.21;
% w=0;tax_firm=0;
%step_unit=[1,2,4,12,24,36,52];
type_default=1;type_tax_employee=1;
result=[];
step_unit=[12];%wage=0;
T_exercise=T-2;
method=1;
tax_employee=0.05; 
percent=[0.5];
Beta=0.125;

result=[];
result1=[];
step=T*step_unit;
t=1/step_unit;
total_step=step;

Total_cost=[500000 1000000 2000000  2500000];
Total_cost=2500000;
sigma=[1 ];
gamma=[0.2 0.5 0.8 1];
gamma=0.2;
% range=5000;
wage=8100000; 
N=0;
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
p_correct=sum( length(find(1<0))+length(find(Q<0)) );
Asset=Equity+Debt+ESO+Dividend+Salary-TB+BC;       
CE_wage_ESO=CE(wage,r,Beta,t,Utility,0,gamma,total_step,tax_employee,0);
Salary+ESO-Total_cost
if abs(Salary+ESO-Total_cost)<500
    
    CE_wage_ESO=CE(wage,r,Beta,t,Utility,0,gamma,total_step,tax_employee,0);
    result=[result;wage,N,Salary,ESO,Salary+ESO-Total_cost,Total_cost,CE_wage_ESO,Asset,sigma,gamma,Equity,Debt,Dividend,Salary,ESO,TB,BC,Asset,Utility,CE_wage_ESO];
%     result=[result;wage,N,Salary,ESO,Salary+ESO-Total_cost,Total_cost,CE_wage_ESO,Asset,sigma];
end
result1=[result1;wage,N,Salary,ESO,Salary+ESO-Total_cost,Total_cost,Asset,CE_wage_ESO,sigma,gamma,Equity,Debt,Dividend,Salary,ESO,TB,BC,Asset,Utility,CE_wage_ESO];

x=result1';