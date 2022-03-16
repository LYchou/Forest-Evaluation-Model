V=9.91e9;
F=V*0.18;c=0.078; 
r=0.06;
T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;
tax_firm=0.21; 
type_default=1;
%T_exercise=T-3; 
T_exercise=3; 
method=1;
tax_employee=0.05; 
percent=0.5;
Beta=0.125;

Total_cost=V*0.0012021*T;

X=8e6;
O=1000;


% X=8e6/10;
% O=1000*10;


mu=0.125;
mu = transfer_mu(mu,V,F,c);
Beta = mu; 

%%
% NQSO
type_tax_employee=1;

% gamma = 0.1;
% sigma = 0.082;
% N_list = [49,50,51,60];

% gamma = 0.2;
% sigma = 0.164;
% N_list = [18,19,20];

% gamma = 0.8;
% sigma = 0.164;
% N_list = [3,4,29,30];

% gamma = 0.1;
% sigma = 0.574;
% N_list = [3,25];

% gamma = 0.9;
% sigma = 0.574;
% N_list = [3,18];

step_unit=1;
step=T*step_unit;
t=1/step_unit;
gamma = 0.9;
sigma = 0.574;
N_list = [3];
N = 3;
%%

%error_list = [];
error_mat = [];
equity_mat = [];
debt_mat = [];
asset_mat = [];
stock_mat = [];
ESO_mat = [];
utility_mat = [];

result = [];

wage_list = linspace(0,Total_cost/2,100);

for list_1=1:length(N_list)
    error_list = [];
    equity_list = [];
    debt_list = [];
    asset_list = [];
    stock_list = [];
    ESO_list = [];
    utility_list = [];
    for list_2=1:length(wage_list)
        N = N_list(list_1);
        wage = wage_list(list_2);
        disp(['N = ',num2str(N),' / wage = ',num2str(wage)]);
        [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
        error = (ESO+Salary)-Total_cost;
        result_temp = [N,wage,gamma,sigma,error,Equity,Debt,Equity+Debt,Stock,ESO,Utility];
        result = [result;result_temp];
        error_list = [error_list,error];
        equity_list = [equity_list,Equity];
        debt_list = [debt_list,Debt];
        asset_list = [asset_list,Equity+Debt];
        stock_list = [stock_list,Stock];
        ESO_list = [ESO_list,ESO];
        utility_list = [utility_list,Utility];
    end
    
    
    
    error_mat = [error_mat;error_list];
    equity_mat = [equity_mat;equity_list];
    debt_mat = [debt_mat;debt_list];
    asset_mat = [asset_mat;asset_list];
    stock_mat = [stock_mat;stock_list];
    ESO_mat = [ESO_mat;ESO_list];
    utility_mat = [utility_mat;utility_list];
    
end

%%
for list_1=1:length(N_list)
    figure
    plot(wage_list,error_mat(list_1,:))
    title(['(error) gamma=',num2str(gamma),' sigma=',num2str(sigma),' , N=',num2str(N_list(list_1))])
    xlabel('wage')
    ylabel('error = (ESO+Salary)-Total_cost')
    
    figure
    plot(wage_list,equity_mat(list_1,:))
    title(['(Equity) gamma=',num2str(gamma),' sigma=',num2str(sigma),' , N=',num2str(N_list(list_1))])
    xlabel('wage')
    ylabel('Equity')
    
    figure
    plot(wage_list,debt_mat(list_1,:))
    title(['(Debt) gamma=',num2str(gamma),' sigma=',num2str(sigma),' , N=',num2str(N_list(list_1))])
    xlabel('wage')
    ylabel('Debt')
    
    figure
    plot(wage_list,asset_mat(list_1,:))
    title(['(Asset) gamma=',num2str(gamma),' sigma=',num2str(sigma),' , N=',num2str(N_list(list_1))])
    xlabel('wage')
    ylabel('Asset')
    
    figure
    plot(wage_list,ESO_mat(list_1,:))
    title(['(ESO) gamma=',num2str(gamma),' sigma=',num2str(sigma),' , N=',num2str(N_list(list_1))])
    xlabel('wage')
    ylabel('ESO')
    
    figure
    plot(wage_list,utility_mat(list_1,:))
    title(['(Utility) gamma=',num2str(gamma),' sigma=',num2str(sigma),' , N=',num2str(N_list(list_1))])
    xlabel('wage')
    ylabel('Utility')
    a=1;
end
%%
N = 3;
wage = 9626513.93939394; % Debt ¸õÂI
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
Debt1=Debt
perc1 = 3;
perc2 = 1;
[~,~,n1,n2] = size(Debt_value(perc1,perc2,:,:));
df1 = zeros(n1,n2);
for i=1:n1
    for j=1:n2
        df1(i,j) = Debt_value(perc1,perc2,i,j);
        
    end
end
%%
wage = 9626513.93939394+10; % Debt ¸õÂI
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
perc1 = 3;
perc2 = 1;
[~,~,n1,n2] = size(Debt_value(perc1,perc2,:,:));
default_boundary_value1=default_boundary_value;
Debt2=Debt
df2 = zeros(n1,n2);
for i=1:n1
    for j=1:n2
        df2(i,j) = Debt_value(perc1,perc2,i,j);
    end
end
    


