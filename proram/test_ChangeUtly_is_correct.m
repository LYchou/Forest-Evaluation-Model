clc
clear
%固定變數------------------------
A_description='更改成jain的效用函數許多函數都要跟著調整';
A_test_func1 = 'Employee_Stock_Option3.m ，令k=0，與Employee_Stock_Option2.m比較';
A_test_func2 = 'Employee_Stock_Option_ISO3.m，令k=0，與Employee_Stock_OptionISO.m比較';
A_test_func3 = 'binary_search_fixed_cost_ChangeUtly.m，k=1，驗證使否有固定成本即可';
A_test_func4 = 'binary_search_fixed_CE_ChangeUtly.m，k=1，驗證使否有固定成本即可';

V=9.91e9;
F=V*0.18;c=0.078;
r=0.06;
sigma=0.3;
X=8e6;
O=1000;
T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;%破產成本
tax_firm=0.21; 
type_default=1;
T_exercise=3; 
method=1;
tax_employee=0.05; 
percent=0.5;
step_unit=4;
step=T*step_unit;
t=1/step_unit;
Total_cost=V*0.0012021*T;%<使用柏宏之後找到的數據(論文中固定成本的數字)>
Total_CE = 52421244.4442340;
Beta=0.125;

mu= 0.125;
N=10;

% NQSO
type_tax_employee=1;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);
% 1. test : Employee_Stock_Option3.m
% 2. test : binary_search_fixed_cost_ChangeUtly.m
% 3. test : binary_search_fixed_CE_ChangeUtly.m






%%
% NQSO
type_tax_employee=1;
k = 0; % Jain
wage = 670000;
gamma = 0.5;
Beta=r*gamma;
[~,~,~,~,Utility2]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
[~,~,~,~,Utility3]=Employee_Stock_Option3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
disp(['Utility2 = ',num2str(Utility2)]);
disp(['Utility3 = ',num2str(Utility3)]);
%%
% QSO
type_tax_employee=2;
k = 0; % Jain
wage = 670000;
gamma = 0.5;
Beta=r*gamma;
[~,~,~,~,Utility2]=Employee_Stock_Option_ISO(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
[~,~,~,~,Utility3]=Employee_Stock_Option_ISO3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
disp(['Utility2 = ',num2str(Utility2)]);
disp(['Utility3 = ',num2str(Utility3)]);

%%
% 經以上驗證(k=0) Employee_Stock_Option2、Employee_Stock_Option_ISO3 這兩個 func 沒有問題
% 驗證固定成本與固定CE (著重驗證 k =1 ；Jain)
k=1;
% 但必須驗證 gamma = 0.5 ； 1 ； 2 三個位置
% 1 fixed cost ； 2 fixed CE
% -1 NQSO ； -2 QSO
% - -1 gamma = 0.5 ； - -2 gamma = 1 ； - -3 gamma = 2 ； 
%%
% (1-1-1) : 1 fixed cost、-1 NQSO、- -1 gamma = 0.5
type_tax_employee=1;
ESO_type = 1;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);
previousWage_right=Total_cost;
gamma = 0.5;

[wage] = binary_search_fixed_cost_ChangeUtly(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
error = abs(Total_cost - ESO - Salary);
disp('(1-1-1) : 1 fixed cost、-1 NQSO、- -1 gamma = 0.5');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%
% (1-1-2) : 1 fixed cost、-1 NQSO、- -1 gamma = 1
type_tax_employee=1;
ESO_type = 1;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);
previousWage_right=Total_cost;
gamma = 1;

[wage] = binary_search_fixed_cost_ChangeUtly(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
error = abs(Total_cost - ESO - Salary);
disp('(1-1-2) : 1 fixed cost、-1 NQSO、- -1 gamma = 1');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%
% (1-1-3) : 1 fixed cost、-1 NQSO、- -1 gamma = 2
type_tax_employee=1;
ESO_type = 1;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);
previousWage_right=Total_cost;
gamma = 2;

[wage] = binary_search_fixed_cost_ChangeUtly(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
error = abs(Total_cost - ESO - Salary);
disp('(1-1-3) : 1 fixed cost、-1 NQSO、- -1 gamma = 2');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%

%%
% (1-2-1) : 1 fixed cost、-1 QSO、- -1 gamma = 0.5
type_tax_employee=2;
ESO_type = 2;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);
previousWage_right=Total_cost;
gamma = 0.5;

[wage] = binary_search_fixed_cost_ChangeUtly(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
error = abs(Total_cost - ESO - Salary);
disp('(1-2-1) : 1 fixed cost、-1 QSO、- -1 gamma = 0.5');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%
% (1-2-2) : 1 fixed cost、-1 QSO、- -1 gamma = 1
type_tax_employee=2;
ESO_type = 2;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);
previousWage_right=Total_cost;
gamma = 1;

[wage] = binary_search_fixed_cost_ChangeUtly(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
error = abs(Total_cost - ESO - Salary);
disp('(1-2-2) : 1 fixed cost、-1 QSO、- -1 gamma = 1');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%
% (1-2-3) : 1 fixed cost、-1 QSO、- -1 gamma = 2
type_tax_employee=2;
ESO_type = 2;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);
previousWage_right=Total_cost;
gamma = 2;

[wage] = binary_search_fixed_cost_ChangeUtly(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
error = abs(Total_cost - ESO - Salary);
disp('(1-2-3) : 1 fixed cost、-1 QSO、- -1 gamma = 2');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end
%%

%%
% (2-1-1) : 1 fixed CE、-1 NQSO、- -1 gamma = 0.5
type_tax_employee=1;
ESO_type = 1;
fixed_CE = Total_CE;
searchTimes = 20;  
threshold = fixed_CE*(2.5/1000);
previousWage_right=Total_cost;
gamma = 0.5;

[wage,CE_est] = binary_search_fixed_CE_ChangeUtly(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
CE_employee=CE(wage,r,Beta,t,Utility,0,gamma,step,tax_employee,k);
error = abs(fixed_CE - CE_est);
disp('(2-1-1) : 1 fixed CE、-1 NQSO、- -1 gamma = 0.5');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end
%%
% (2-1-2) : 1 fixed CE、-1 NQSO、- -1 gamma = 1
type_tax_employee=1;
ESO_type = 1;
fixed_CE = Total_CE;
searchTimes = 20;
threshold = fixed_CE*(2.5/1000);
previousWage_right=Total_cost;
gamma = 1;

[wage,CE_est] = binary_search_fixed_CE_ChangeUtly(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
CE_employee=CE(wage,r,Beta,t,Utility,0,gamma,step,tax_employee,k);
error = abs(fixed_CE - CE_est);
disp('(2-1-2) : 1 fixed CE、-1 NQSO、- -1 gamma = 1');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%
% (2-1-3) : 1 fixed CEt、-1 NQSO、- -1 gamma = 2
type_tax_employee=1;
ESO_type = 1;
fixed_CE = Total_CE;
searchTimes = 20;
threshold = fixed_CE*(2.5/1000);
previousWage_right=Total_cost;
gamma = 2;

[wage,CE_est] = binary_search_fixed_CE_ChangeUtly(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
CE_employee=CE(wage,r,Beta,t,Utility,0,gamma,step,tax_employee,k);
error = abs(fixed_CE - CE_est);
disp('(2-1-3) : 1 fixed CE、-1 NQSO、- -1 gamma = 2');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%

%%
% (2-2-1) : 1 fixed CE、-1 QSO、- -1 gamma = 0.5
type_tax_employee=2;
ESO_type = 2;
fixed_CE = Total_CE;
searchTimes = 20;
threshold = fixed_CE*(2.5/1000);
previousWage_right=Total_cost;
gamma = 0.5;

[wage,CE_est] = binary_search_fixed_CE_ChangeUtly(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
CE_employee=CE(wage,r,Beta,t,Utility,0,gamma,step,tax_employee,k);
error = abs(fixed_CE - CE_est);
disp('(2-2-1) : 1 fixed CE、-1 QSO、- -1 gamma = 0.5');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%
% (2-2-2) : 1 fixed CE、-1 QSO、- -1 gamma = 1
type_tax_employee=2;
ESO_type = 2;
fixed_CE = Total_CE;
searchTimes = 30;
threshold = fixed_CE*(2.5/1000);
previousWage_right=Total_cost;
gamma = 1;

[wage,CE_est,para] = binary_search_fixed_CE_ChangeUtly(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
CE_employee=CE(wage,r,Beta,t,Utility,0,gamma,step,tax_employee,k);
error = abs(fixed_CE - CE_est);
disp('(2-2-2) : 1 fixed CE、-1 QSO、- -1 gamma = 1');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end

%%
% (2-2-3) : 1 fixed CE、-1 QSO、- -1 gamma = 2
type_tax_employee=2;
ESO_type = 2;
fixed_CE = Total_CE;
searchTimes = 20;
threshold = fixed_CE*(2.5/1000);
previousWage_right=Total_cost;
gamma = 2;

[wage,CE_est,para] = binary_search_fixed_CE_ChangeUtly(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div,k);
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO3(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div,k);
CE_employee=CE(wage,r,Beta,t,Utility,0,gamma,step,tax_employee,k);
error = abs(fixed_CE - CE_est);
disp('(2-2-3) : 1 fixed CE、-1 QSO、- -1 gamma = 2');
disp(['error = ',num2str(error)]);
disp(['threshold = ',num2str(threshold)]);
if(error<threshold)
    disp('sucess');
else
    disp('fail');
end




