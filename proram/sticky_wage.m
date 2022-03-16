clc
clear
%固定變數------------------------
V=[9.91e9 ];
c=0.078;
r=0.06;
mu=linspace(0,0.3,6);
%越接近1，越風險中立。
gamma=0.3;
sigma=[0.3];
X=8e6;
O=1000;
T=10;
Div=0 ;
additional_wealth=[0 ];
wage=670000;
w=0.4296;%破產成本
tax_firm=0.21; 
type_default=1;
%T_exercise=T-3; %三年後才可以履約
T_exercise=3; 
method=1;
tax_employee=0.05; 
percent=[0.5];
Beta=0.125;
step_unit=[4];
step=T*step_unit;
t=1/step_unit;
Total_cost=V*0.0012021*T;%<使用柏宏之後找到的數據(論文中固定成本的數字)>
F=V*0.18;
type_tax_employee=1; %NQSO

