clc
clear
%�T�w�ܼ�------------------------
V=[9.91e9 ];
F=V*0.18;c=0.078;
r=0.06;
mu=0.125;
%�V����1�A�V���I���ߡC
gamma=0.5;
sigma=[0.3];
X=8e6;
O=1000;
T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;%�}������
tax_firm=0.21; 
type_default=1;
%T_exercise=T-3; %�T�~��~�i�H�i��
T_exercise=3; 
method=1;
tax_employee=0.05; 
percent=[0.5];
Beta=0.125;
step_unit=[4];
step=T*step_unit;
t=1/step_unit;
N=10;
wage=670000;

%���]T_exercise�~�����u�~������¾�A�åu�ளT_exercise/T��Ҫ�ESO
%NQSO
type_tax_employee=1;


V_list=[];

%����(�ɶ�=T_exercise)�겣�W�ɪ��Ҧ��i��
T1=T;%T
T_exercise1=T_exercise;%T_exercise
N1=N; %N
V1=V; %V 
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V1,sigma,T1,T_exercise1,step,F,c,r,mu,X,N1,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
[n1,n2]=size(firm_tree_value);
for i=1:T_exercise*step_unit+1
    V_list=[V_list;firm_tree_value(n1-max_time_node(i)+1,i)];
end
Total_cost_retention=ESO+Salary;

%�p��U�겣�i�઺wage�W��
wage_UB=[];
error=[];
for i=1:length(V_list)
    %�վ�V=V_list(i)
    
    %�غc����������(�d�����ĥ�)
    T1=T-T_exercise;%T
    T_exercise1=0;%T_exercise
    N1=T-T_exercise; %N
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V_list(i),sigma,T1,T_exercise1,step,F,c,r,mu,X,N1,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    Utility1=Utility;%�D�o�d���ĥ� Utility
    
    %�G���k�D : �t�M�n�u�@��wage*�W�ɡA�b�o�ӤW�ɤ��ϱo�d���ĥΤ��M���j
    left=wage; right=(ESO+Salary)*5;
    middle=(left+right)/2;
    N1=0;
    while 1
        %wage=middle
        [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V_list(i),sigma,T1,T_exercise1,step,F,c,r,mu,X,N1,O,middle,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
        error_temp=abs(Utility-Utility1)
        if (abs(Utility-Utility1)<100)
            error=[error;abs(Utility-Utility1)];
            wage_UB=[wage_UB,middle];
            break;
        end
        if(Utility>Utility1)
            right=middle;
        else
            left=middle;
        end
        middle=(left+right)/2;
    end
end

%�H�W�w�g���T_exercise�ɦU�겣�Ȫ�wage�W��
%�H�U�i�J�ĤG����
% 1.�p�� P(V>V*)
% 2.�D�o�Uwage�W�ɤU�Ak���U��

%1.

%�w�� Vt~N( V0*exp(mu*t) , V0^2*exp(2*mu*t)*(exp(sigma^2*t)-1) )
mu_V=V*exp(mu*T_exercise);
var_V=V^2*exp(2*mu*T_exercise)*(exp(sigma^2*T_exercise)-1);
probability_for_resign=[];
for i=1:length(V_list)
    p = normcdf(V_list(i),mu_V,sqrt(var_V))
    probability_for_resign=[probability_for_resign;1-p];
end
 
%2.

%�ݥ��D�T�w�����U(N=10,wage=670000)�A���s�����o�h��wage
%Total_cost_retention
Total_cost_wage=0;

T1=T;%T
T_exercise1=0;%T_exercise
N1=0; %N

left=0;
right=(Total_cost_retention/T)*10;
middle=(left+right)/2;
while 1
    %wage=middle
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V_list(i),sigma,T1,T_exercise1,step,F,c,r,mu,X,N1,O,middle,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    error=(Salary-Total_cost_retention);
    if(abs(error)<40000)
        Total_cost_wage=middle;
        break;
    end
    if(error<0)
        left=middle;
    else
        right=middle;
    end
    middle=(left+right)/2;
end

%���F�T�w�����U�A���ӵo�h�֦~�~wage��
%�i�H�}�l�غc������2���k��

k_LB=[];
for i=1:length(V_list)
    
    
    R=(1-probability_for_resign(i))*Total_cost_retention+probability_for_resign(i)*();
end


T1=T;%T
T_exercise1=T_exercise;%T_exercise
N1=N; %N
V1=V; %V 
[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V1,sigma,T1,T_exercise1,step,F,c,r,mu,X,N1,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);

%[Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);






%����v�}�C
%���@�����W�������v�}�C
% probability_upper_V_temp=[];
% probability_upper_V_=[];
%             probability_upper_V=[P(length(P),8)]; 
%             %max_time_node�]�w�_�I�N�O1�A���L�]�w�覡���@��(��Lmax_time_node���Ӵʸ겣�ƸӴ��q�H����ک��W�Ʀ��X���I�A�]�t���)�A�ҥH�ݭn��@�S�ҥ��p��i��
%             for j=length(P):-1:1
%                 if(P(j,3)==1 && P(j,4)==1 && P(j,5)==max_time_node(1,P(j,2))-1 && P(j,2)<(step_unit*T_exercise+1))
%                     probability_upper_V_temp=[probability_upper_V_temp;P(j,8)]
%                 end
%             end

% %����(�ɶ�=T_exercise)�겣�W�ɪ��Ҧ��i��
% V_list=[V];
% u=exp(sigma*sqrt(t));
% for i=1:step_unit*T_exercise
%     V_list=[V_list,V*u^(i)];
% end

% 
% mu_V=[];
% var_V=[];
% 
% for i=1:length(V_list)
%     mu_V=[mu_V;V_list(i)*exp(mu*T_exercise)];
%     var_V=[var_V;V_list(i)^2*exp(2*mu*T_exercise)*(exp(sigma^2*T_exercise)-1)];
% end