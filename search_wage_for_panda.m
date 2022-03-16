clc
clear
% �]�w����
A_discription = '';
% ������ (�Ω�s�Ϫ��ɦW)
run_date = '20210604';
%�T�w�ܼ�------------------------
V=9.91e9;
F=V*0.18;c=0.078;
r=0.06;
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
percent=0.5;
Beta=0.125;
step_unit=4;
step=T*step_unit;
t=1/step_unit;
Total_cost=V*0.0012021*T;%<�ϥάf�������쪺�ƾ�(�פ夤�T�w�������Ʀr)>

% X=8e6;
% O=1000;

%����i���i�Ƥ��o��Y�K
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
