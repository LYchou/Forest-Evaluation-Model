clc
clear
%�T�w�ܼ�------------------------
V=[9.91e9 ];
c=0.078;
r=0.06;
mu=linspace(0,0.3,6);
%�V����1�A�V���I���ߡC
gamma=0.3;
sigma=[0.3];
X=8e6;
O=1000;
T=10;
Div=0 ;
additional_wealth=[0 ];
wage=670000;
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
Total_cost=V*0.0012021*T;%<�ϥάf�������쪺�ƾ�(�פ夤�T�w�������Ʀr)>
F=V*0.18;
type_tax_employee=1; %NQSO

