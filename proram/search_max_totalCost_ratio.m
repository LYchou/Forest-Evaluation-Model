clc
clear
% 設定說明
A_discription = '使用debug的程式 3，把搜尋誤差條小，並且二分法搜尋wage上界不調整(previousWage_right = Total_cost)，再把固定成本調大為了放大稅盾效果，搜尋最大張數設定到300張，固定成本下，討論不同gamma不同sigma下三種最佳化的結果，maxN=100，將股票報酬率與波動度校正成資產，同時調整Beta。';
% 執行日期 (用於存圖的檔名)
run_date = '20210611';
%固定變數------------------------
V=9.91e9;
F=V*0.18;c=0.078;
r=0.06;
T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;%破產成本
tax_firm=0.21; 
type_default=1;
%T_exercise=T-3; %三年後才可以履約
T_exercise=3; 
method=1;
tax_employee=0.05; 
percent=0.5;
Beta=0.125;
step_unit=4;
step=T*step_unit;
t=1/step_unit;
%Total_cost=V*0.0012021*T;%<使用柏宏之後找到的數據(論文中固定成本的數字)>
Total_cost=V*0.094*T;%<使用panda說的上界(論文中固定成本的數字)>

X=8e6;
O=1000;

% %為把履約張數切得更稠密
% X=8e6/10;
% O=1000*10;



% 越接近1，越風險中立。(真實世界沒有風險中立 gamma~=1)
% 另外我加入一個風險特別不中立的case : gamma = 0.05
gamma=[0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
%gamma=flip(gamma);

% 原本為 sigma = 0.1~0.7 切七等分，另外，在0.1和0.1857之間多塞三個點
sigma = 0.1:0.1:0.7;

% 調整 mu 和 sigma
mu=0.125;
mu = transfer_mu(mu,V,F,c);
Beta = mu; % 跟著 mu 一起調整
for i = 1:length(sigma)
    sigma(i) = transfer_sigma(sigma(i),V,F);
end



% NQSO
type_tax_employee=1;


NQSO_maxWage = zeros(length(gamma),length(sigma));
NQSO_maxWage_Vratio = zeros(length(gamma),length(sigma));
NQSO_maxWage_dummy = zeros(length(gamma),length(sigma));

for list_1=1:length(gamma)
    for list_2=1:length(sigma)
        
        disp(['NQSO:',num2str(list_1),',',num2str(list_2)])
        % 測試最大wage可以發多少，Employee_Stock_Option3不會有問題
        maxWage = search_maxWage(V,100,step,T,F,tax_firm,c,r);
        wage = maxWage;
        N=0;
        [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option3(V,sigma(list_2),T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma(list_1),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
        NQSO_maxWage(list_1,list_2)=Salary;
        NQSO_maxWage_Vratio(list_1,list_2)=Salary/(V*T);
        if(Salary>Total_cost)
            NQSO_maxWage_dummy(list_1,list_2)=1;
        else
            NQSO_maxWage_dummy(list_1,list_2)=0;
        end
        
    end
    
end


type_tax_employee=2;

QSO_maxWage = zeros(length(gamma),length(sigma));
QSO_maxWage_Vratio = zeros(length(gamma),length(sigma));
QSO_maxWage_dummy = zeros(length(gamma),length(sigma));

for list_1=1:length(gamma)
    for list_2=1:length(sigma)
        
        disp(['QSO:',num2str(list_1),',',num2str(list_2)])
        
         % 測試最大wage可以發多少，Employee_Stock_Option3不會有問題
        maxWage = search_maxWage(V,100,step,T,F,tax_firm,c,r);
        wage = maxWage;
        N=0;
        [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO3(V,sigma(list_2),T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma(list_1),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
        QSO_maxWage(list_1,list_2)=Salary;
        QSO_maxWage_Vratio(list_1,list_2)=Salary/(V*T);
        if(Salary>Total_cost)
            QSO_maxWage_dummy(list_1,list_2)=1;
        else
            QSO_maxWage_dummy(list_1,list_2)=0;
        end
        
        
    end
end
