clc
clear
% 設定說明
A_discription = '利用sigma校正gamma，maxN=100，將股票報酬率與波動度校正成資產，同時調整Beta。';
% 執行日期 (用於存圖的檔名)
run_date = '2021....';

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
percent=[0.5];
Beta=0.125;
%step_unit=[12];
step_unit=[4];
step=T*step_unit;
t=1/step_unit;
Total_cost=V*0.0012021*T;%<使用柏宏之後找到的數據(論文中固定成本的數字)>
Total_CE = 52421244.4442340;
threshold = Total_CE*(2.5/1000);


X=8e6;
O=1000;

mu=0.125;
% 越接近1，越風險中立。(真實世界沒有風險中立 gamma~=1)
% 另外我加入一個風險特別不中立的case : gamma = 0.05
gamma=[0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
%gamma=flip(gamma);
gamma_not_include_index = 1;
% 原本為 sigma = 0.1~0.7 切七等分，另外，在0.1和0.1857之間多塞三個點
sigma = [0.1000 0.12 0.14 0.16 0.1857 0.2714 0.3571 0.4429 0.5286 0.6143 0.7000];

% 調整 mu 和 sigma
mu = transfer_mu(mu,V,F,c);
Beta = mu; % 跟著 mu 一起調整
for i = 1:length(sigma)
    sigma(i) = transfer_sigma(sigma(i),V,F);
end


%怕外生給定的薪水上界不夠大
errorRecord=[];

%NQSO
type_tax_employee=1;

% 存最佳解時，所有參數
result_package_maxAsset=[];
result_package_maxEquity=[];
result_package_minCost=[];
MaxN_NQSO=zeros(length(sigma),length(gamma));
p_NQSO_info = [];
for list_1=1:length(sigma)
    for list_2=1:length(gamma)
        
       result_package_temp=[]; %區域變數，每次不同mu和gamma下都會初始化，用來儲存在mu*和gamma*下效用最大ESO張數對應的result
        
       %避免重複搜尋相同範圍， N=n-1下解出的wage，可當N=n下wage的上界(right)
       previouWage=Total_cost; %年薪乘十年的薪資成本 當作wage初始上界
       
       %使用while N=0往後跌帶，直到全發ESO的成本超過門檻 or 到達最大想找的張數
       N=0;
       while 1
           %wage=0，測試N=N*會不會超過固定CE
           [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma(list_1),T,T_exercise,step,F,c,r,mu,X,N,O,0,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
           CE_employee=CE(0,r,Beta,t,Utility,0,gamma(list_2),step,tax_employee,0);
           if CE_employee>Total_CE ,break,end
           if N>100 ,break,end
           
           %紀錄不同mu和gamma下最多可以發幾張
           MaxN_NQSO(list_1,list_2)=N;
           
           %二分法
           left=0;
           right=previouWage;
           middle=(left+right)/2;
           %設定salary和ESO初始值，才能進入while迴圈
           CE_employee=0;
           counter=0;
           error=0;min=1000*Total_CE;accurate_wage=0;
           errorList=[];
           position=[];
           minError_outcome=[];
           while(abs(Total_CE-CE_employee)>threshold && counter<20)
               %以middle當作輸入
               [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma(list_1),T,T_exercise,step,F,c,r,mu,X,N,O,middle,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
               CE_employee=CE(middle,r,Beta,t,Utility,0,gamma(list_2),step,tax_employee,0);
               p_correct = sum( length(find(P<0))+length(find(Q<0)) );
               counter=counter+1;
               error=abs(Total_CE-CE_employee);
               errorList=[errorList;error];
               if(error<min)
                   min=error;
                   accurate_wage=middle;
                   previouWage=middle; %提供ESO張數增加後wage搜尋的上界
                   Asset=Equity+Debt;
                   p_NQSO_info_temp = [list_1,list_2,N,p_correct];
                   minError_outcome=[list_1,list_2,Asset,Equity,ESO+Salary,N,ESO,Salary,Utility,min,Debt,sigma(list_1),gamma(list_2)];
               end
               %設定下次的左右界
               if(Total_CE>CE_employee)
                   left=middle;
                   middle=(left+right)/2;
               else
                   right=middle;
                   middle=(left+right)/2;
               end
               %紀錄左右界以便debug
               position=[position;left,middle,right,Total_CE-CE_employee,CE_employee];
           end
           
           % 怕外生給定的薪水上界不夠大，確認沒有搜尋錯誤
           if(counter>20)
               errorRecord=[errorRecord;type_tax_employee,list_1,list_2,N,error];
           end
           
           result_package_temp=[result_package_temp;minError_outcome];
           p_NQSO_info = [p_NQSO_info;p_NQSO_info_temp];

           [n1,~]=size(result_package_temp);
           type_tax_employee
           list_1
           list_2
           error
           N
           N=N+1;
       end
       
       %尋找最佳解 項目分別有 : maxAsset, maxEquty, minCost
       
       %第一，maxAsset
       max=0;
       max_result=[];
       [n1,n2]=size(result_package_temp);
       for i=1:n1
           if(result_package_temp(i,3)>max)
               max=result_package_temp(i,3);
               max_result=result_package_temp(i,:);
           end
       end
       result_package_maxAsset=[result_package_maxAsset;max_result];
       
       %第二，maxEquity
       max=0;
       max_result=[];
       [n1,n2]=size(result_package_temp);
       for i=1:n1
           if(result_package_temp(i,4)>max)
               max=result_package_temp(i,4);
               max_result=result_package_temp(i,:);
           end
       end
       result_package_maxEquity=[result_package_maxEquity;max_result];
       
       %第三，minCost
       min=Total_cost*10000;
       min_result=[];
       [n1,n2]=size(result_package_temp);
       for i=1:n1
           if(result_package_temp(i,5)<min)
               min=result_package_temp(i,5);
               min_result=result_package_temp(i,:);
           end
       end
       result_package_minCost=[result_package_minCost;min_result];   
    end
end

%陣列轉置一下，比較好閱讀
result_package_maxAsset = result_package_maxAsset';
result_package_maxEquity = result_package_maxEquity';
result_package_minCost = result_package_minCost';
% mu=mu*,gamma=gamma*下，最佳張數，成本比例
%張數
result_prefer_NQSO_maxAsset=zeros(length(sigma),length(gamma));
result_prefer_NQSO_maxEquity=zeros(length(sigma),length(gamma));
result_prefer_NQSO_minCost=zeros(length(sigma),length(gamma));
%數值
result_prefer_NQSO_maxAsset_A=zeros(length(sigma),length(gamma));
result_prefer_NQSO_maxEquity_E=zeros(length(sigma),length(gamma));
result_prefer_NQSO_minCost_C=zeros(length(sigma),length(gamma));
%比例
result_prefer_NQSO_ESOratio_maxAsset=zeros(length(sigma),length(gamma));
result_prefer_NQSO_ESOratio_maxEquity=zeros(length(sigma),length(gamma));
result_prefer_NQSO_ESOratio_minCost=zeros(length(sigma),length(gamma));
%寫入上述宣告矩陣
for i=1:length(sigma)*length(gamma)
    % index
    x=result_package_maxAsset(1,i);
    y=result_package_maxAsset(2,i);
    % 張數
    result_prefer_NQSO_maxAsset(x,y)=result_package_maxAsset(6,i);
    result_prefer_NQSO_maxEquity(x,y)=result_package_maxEquity(6,i);
    result_prefer_NQSO_minCost(x,y)=result_package_minCost(6,i);
    % 數值
    result_prefer_NQSO_maxAsset_A(x,y)=result_package_maxAsset(3,i);
    result_prefer_NQSO_maxEquity_E(x,y)=result_package_maxEquity(4,i);
    result_prefer_NQSO_minCost_C(x,y)=result_package_minCost(5,i);
    % ESO成本佔總成本的比例
    result_prefer_NQSO_ESOratio_maxAsset(x,y)=result_package_maxAsset(7,i)/Total_cost;
    result_prefer_NQSO_ESOratio_maxEquity(x,y)=result_package_maxEquity(7,i)/Total_cost;
    result_prefer_NQSO_ESOratio_minCost(x,y)=result_package_minCost(7,i)/Total_cost;
end



%QSO
%程式碼相同，只是主要的函數從Employee_Stock_Option2變成Employee_Stock_Option_ISO
%其中的陣列都被覆蓋，除了最後的結果 : result_prefer
type_tax_employee=2;

% 存最佳解時，所有參數
result_package_maxAsset=[];
result_package_maxEquity=[];
result_package_minCost=[];
MaxN_QSO=zeros(length(sigma),length(gamma));
p_QSO_info = [];

for list_1=1:length(sigma)
    for list_2=1:length(gamma)
        
       result_package_temp=[]; %區域變數，每次不同mu和gamma下都會初始化，用來儲存在mu*和gamma*下效用最大ESO張數對應的result
        
       %避免重複搜尋相同範圍， N=n-1下解出的wage，可當N=n下wage的上界(right)
       previouWage=Total_cost; %年薪乘十年的薪資成本 當作wage初始上界
       
       %使用while N=0往後跌帶，直到全發ESO的成本超過門檻 or 到達最大想找的張數
       N=0;
       while 1
           %wage=0，測試N=N*會不會超過固定CE
           [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma(list_1),T,T_exercise,step,F,c,r,mu,X,N,O,0,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
           CE_employee=CE(0,r,Beta,t,Utility,0,gamma(list_2),step,tax_employee,0);
           if CE_employee>Total_CE ,break,end
           if N>100 ,break,end
           
           %紀錄不同mu和gamma下最多可以發幾張
           MaxN_QSO(list_1,list_2)=N;
           
           %二分法
           left=0;
           right=previouWage;
           middle=(left+right)/2;
           %設定salary和ESO初始值，才能進入while迴圈
           CE_employee=0;
           counter=0;
           error=0;min=1000*Total_CE;accurate_wage=0;
           errorList=[];
           position=[];
           minError_outcome=[];
           while(abs(Total_CE-CE_employee)>threshold && counter<20)
               %以middle當作輸入
               [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma(list_1),T,T_exercise,step,F,c,r,mu,X,N,O,middle,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
               p_correct = sum( length(find(P<0))+length(find(Q<0)) );
               CE_employee=CE(middle,r,Beta,t,Utility,0,gamma(list_2),step,tax_employee,0);
               counter=counter+1;
               error=abs(Total_CE-CE_employee);
               errorList=[errorList;error];
               if(error<min)
                   min=error;
                   accurate_wage=middle;
                   previouWage=middle; %提供ESO張數增加後wage搜尋的上界
                   Asset=Equity+Debt;
                   p_QSO_info_temp = [list_1,list_2,N,p_correct];
                   minError_outcome=[list_1,list_2,Asset,Equity,ESO+Salary,N,ESO,Salary,Utility,min,Debt,sigma(list_1),gamma(list_2)];
               end
               %設定下次的左右界
               if(Total_CE>CE_employee)
                   left=middle;
                   middle=(left+right)/2;
               else
                   right=middle;
                   middle=(left+right)/2;
               end
               %紀錄左右界以便debug
               position=[position;left,middle,right,Total_CE-CE_employee,CE_employee];
           end
          
           % 怕外生給定的薪水上界不夠大，確認沒有搜尋錯誤
           if(counter>20)
               errorRecord=[errorRecord;type_tax_employee,list_1,list_2,N,error];
           end
           
           result_package_temp=[result_package_temp;minError_outcome];
           p_QSO_info = [p_QSO_info;p_QSO_info_temp];

           [n1,~]=size(result_package_temp);
           type_tax_employee
           list_1
           list_2
           error
           N
           N=N+1;
       end
       
       %尋找最佳解 項目分別有 : maxAsset, maxEquty, minCost
       
       %第一，maxAsset
       max=0;
       max_result=[];
       [n1,n2]=size(result_package_temp);
       for i=1:n1
           if(result_package_temp(i,3)>max)
               max=result_package_temp(i,3);
               max_result=result_package_temp(i,:);
           end
       end
       result_package_maxAsset=[result_package_maxAsset;max_result];
       
       %第二，maxEquity
       max=0;
       max_result=[];
       [n1,n2]=size(result_package_temp);
       for i=1:n1
           if(result_package_temp(i,4)>max)
               max=result_package_temp(i,4);
               max_result=result_package_temp(i,:);
           end
       end
       result_package_maxEquity=[result_package_maxEquity;max_result];
       
       %第三，minCost
       min=Total_cost*10000;
       min_result=[];
       [n1,n2]=size(result_package_temp);
       for i=1:n1
           if(result_package_temp(i,5)<min)
               min=result_package_temp(i,5);
               min_result=result_package_temp(i,:);
           end
       end
       result_package_minCost=[result_package_minCost;min_result];   
    end
end

%陣列轉置一下，比較好閱讀
result_package_maxAsset = result_package_maxAsset';
result_package_maxEquity = result_package_maxEquity';
result_package_minCost = result_package_minCost';
% mu=mu*,gamma=gamma*下，最佳張數，成本比例
%張數
result_prefer_QSO_maxAsset=zeros(length(sigma),length(gamma));
result_prefer_QSO_maxEquity=zeros(length(sigma),length(gamma));
result_prefer_QSO_minCost=zeros(length(sigma),length(gamma));
%數值
result_prefer_QSO_maxAsset_A=zeros(length(sigma),length(gamma));
result_prefer_QSO_maxEquity_E=zeros(length(sigma),length(gamma));
result_prefer_QSO_minCost_C=zeros(length(sigma),length(gamma));
%比例
result_prefer_QSO_ESOratio_maxAsset=zeros(length(sigma),length(gamma));
result_prefer_QSO_ESOratio_maxEquity=zeros(length(sigma),length(gamma));
result_prefer_QSO_ESOratio_minCost=zeros(length(sigma),length(gamma));
%寫入上述宣告矩陣
for i=1:length(sigma)*length(gamma)
    % index
    x=result_package_maxAsset(1,i);
    y=result_package_maxAsset(2,i);
    % 張數
    result_prefer_QSO_maxAsset(x,y)=result_package_maxAsset(6,i);
    result_prefer_QSO_maxEquity(x,y)=result_package_maxEquity(6,i);
    result_prefer_QSO_minCost(x,y)=result_package_minCost(6,i);
    % 數值
    result_prefer_QSO_maxAsset_A(x,y)=result_package_maxAsset(3,i);
    result_prefer_QSO_maxEquity_E(x,y)=result_package_maxEquity(4,i);
    result_prefer_QSO_minCost_C(x,y)=result_package_minCost(5,i);
    % ESO成本佔總成本的比例
    result_prefer_QSO_ESOratio_maxAsset(x,y)=result_package_maxAsset(7,i)/Total_cost;
    result_prefer_QSO_ESOratio_maxEquity(x,y)=result_package_maxEquity(7,i)/Total_cost;
    result_prefer_QSO_ESOratio_minCost(x,y)=result_package_minCost(7,i)/Total_cost;
end



% NQSO calibrate gamma
calibrateGamma_NQSO_maxA_N=zeros(1,length(sigma));
calibrateGamma_NQSO_maxA_gamma=zeros(1,length(sigma));
for i=1:length(sigma)
    max_A=result_prefer_NQSO_maxAsset_A(i,1);
    for j=1:length(gamma)-gamma_not_include_index 
        if(result_prefer_NQSO_maxAsset_A(i,j)>=max_A)
            max_A = result_prefer_NQSO_maxAsset_A(i,j);
            calibrateGamma_NQSO_maxA_N(i)=result_prefer_NQSO_maxAsset(i,j);
            calibrateGamma_NQSO_maxA_gamma(i)=gamma(j);
        end
    end
end

calibrateGamma_NQSO_maxE_N=zeros(1,length(sigma));
calibrateGamma_NQSO_maxE_gamma=zeros(1,length(sigma));
for i=1:length(sigma)
    max_E=result_prefer_NQSO_maxEquity_E(i,1);
    for j=1:length(gamma)-gamma_not_include_index 
        if(result_prefer_NQSO_maxEquity_E(i,j)>=max_E)
            max_E = result_prefer_NQSO_maxEquity_E(i,j);
            calibrateGamma_NQSO_maxE_N(i)=result_prefer_NQSO_maxEquity(i,j);
            calibrateGamma_NQSO_maxE_gamma(i)=gamma(j);
        end
    end
end

calibrateGamma_NQSO_minC_N=zeros(1,length(sigma));
calibrateGamma_NQSO_minC_gamma=zeros(1,length(sigma));
for i=1:length(sigma)
    min_C=result_prefer_NQSO_minCost_C(i,1);
    for j=1:length(gamma)-gamma_not_include_index 
        if(result_prefer_NQSO_minCost_C(i,j)<=min_C)
            min_C = result_prefer_NQSO_minCost_C(i,j);
            calibrateGamma_NQSO_minC_N(i)=result_prefer_NQSO_minCost(i,j);
            calibrateGamma_NQSO_minC_gamma(i)=gamma(j);
        end
    end
end

% QSO calibrate gamma
calibrateGamma_QSO_maxA_N=zeros(1,length(sigma));
calibrateGamma_QSO_maxA_gamma=zeros(1,length(sigma));
for i=1:length(sigma)
    max_A=result_prefer_QSO_maxAsset_A(i,1);
    for j=1:length(gamma)-gamma_not_include_index 
        if(result_prefer_QSO_maxAsset_A(i,j)>=max_A)
            max_A = result_prefer_QSO_maxAsset_A(i,j);
            calibrateGamma_QSO_maxA_N(i)=result_prefer_QSO_maxAsset(i,j);
            calibrateGamma_QSO_maxA_gamma(i)=gamma(j);
        end
    end
end

calibrateGamma_QSO_maxE_N=zeros(1,length(sigma));
calibrateGamma_QSO_maxE_gamma=zeros(1,length(sigma));
for i=1:length(sigma)
    max_E=result_prefer_QSO_maxEquity_E(i,1);
    for j=1:length(gamma)-gamma_not_include_index 
        if(result_prefer_QSO_maxEquity_E(i,j)>=max_E)
            max_E = result_prefer_QSO_maxEquity_E(i,j);
            calibrateGamma_QSO_maxE_N(i)=result_prefer_QSO_maxEquity(i,j);
            calibrateGamma_QSO_maxE_gamma(i)=gamma(j);
        end
    end
end

calibrateGamma_QSO_minC_N=zeros(1,length(sigma));
calibrateGamma_QSO_minC_gamma=zeros(1,length(sigma));
for i=1:length(sigma)
    max_C=result_prefer_QSO_minCost_C(i,1);
    for j=1:length(gamma)-gamma_not_include_index 
        if(result_prefer_QSO_minCost_C(i,j)<=max_C)
            min_C = result_prefer_QSO_minCost_C(i,j);
            calibrateGamma_QSO_minC_N(i)=result_prefer_QSO_minCost(i,j);
            calibrateGamma_QSO_minC_gamma(i)=gamma(j);
        end
    end
end
%%
check_NQSO = [];

[row,col] = size(result_prefer_NQSO_maxAsset);
for i=1:row
    for j=1:col
        check_NQSO = [check_NQSO;i j result_prefer_NQSO_maxAsset(i,j)];
    end
end

[row,col] = size(result_prefer_NQSO_maxEquity);
for i=1:row
    for j=1:col
        check_NQSO = [check_NQSO;i j result_prefer_NQSO_maxEquity(i,j)];
    end
end

[row,col] = size(result_prefer_NQSO_minCost);
for i=1:row
    for j=1:col
        check_NQSO = [check_NQSO;i j result_prefer_NQSO_minCost(i,j)];
    end
end

check_QSO = [];

[row,col] = size(result_prefer_QSO_maxAsset);
for i=1:row
    for j=1:col
        check_QSO = [check_QSO;i j result_prefer_QSO_maxAsset(i,j)];
    end
end

[row,col] = size(result_prefer_QSO_maxEquity);
for i=1:row
    for j=1:col
        check_QSO = [check_QSO;i j result_prefer_QSO_maxEquity(i,j)];
    end
end

[row,col] = size(result_prefer_QSO_minCost);
for i=1:row
    for j=1:col
        check_QSO = [check_QSO;i j result_prefer_QSO_minCost(i,j)];
    end
end

%%
% 重新執行要跑的 sigma gamma N* wage*
%NQSO
P_NQSO_all = [];
Q_NQSO_all = [];
type_tax_employee = 1;
for i=1:length(check_NQSO)
    list_1 = check_NQSO(i,1);
    list_2 = check_NQSO(i,2);
    N = check_NQSO(i,3);
       %二分法
       left=0;
       right=Total_cost;
       middle=(left+right)/2;
       %設定salary和ESO初始值，才能進入while迴圈
       CE_employee=0;
       counter=0;
       error=0;min=1000*Total_CE;accurate_wage=0;
       minError_outcome=[];
       while(abs(Total_CE-CE_employee)>threshold && counter<20)
           %以middle當作輸入
           [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma(list_1),T,T_exercise,step,F,c,r,mu,X,N,O,middle,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
           p_correct = sum( length(find(P<0))+length(find(Q<0)) );
           CE_employee=CE(middle,r,Beta,t,Utility,0,gamma(list_2),step,tax_employee,0);
           counter=counter+1;
           error=abs(Total_CE-CE_employee);
           if(error<min)
               min=error;
               accurate_wage=middle;
               previouWage=middle; %提供ESO張數增加後wage搜尋的上界
               Asset=Equity+Debt;
               minError_outcome=[list_1,list_2,Asset,Equity,ESO+Salary,N,ESO,Salary,Utility,min,Debt,sigma(list_1),gamma(list_2)];
           end
           %設定下次的左右界
           if(Total_CE>CE_employee)
               left=middle;
               middle=(left+right)/2;
           else
               right=middle;
               middle=(left+right)/2;
           end
       end
       % 怕外生給定的薪水上界不夠大，確認沒有搜尋錯誤
       if(counter>20)
           errorRecord=[errorRecord;type_tax_employee,list_1,list_2,N,error];
       end
       result_package_temp=[result_package_temp;minError_outcome];
       
       % 儲存所有機率接點
       % 風險中立機率
       P_temp = [];
       [row_p,col_p] = size(P);
       for row=1:row_p
           temp = [list_1 list_2,N,P(row,:)];
           P_temp = [P_temp;temp];
       end
       P_NQSO_all = [P_NQSO_all;P_temp];
       % 真實世界機率
       Q_temp = [];
       [row_q,col_q] = size(Q);
       for row=1:row_q
           temp = [list_1 list_2,N,Q(row,:)];
           Q_temp = [Q_temp;temp];
       end
       Q_NQSO_all = [Q_NQSO_all;Q_temp];
       
       type_tax_employee
       i
       error
       N
end

%QSO
P_QSO_all = [];
Q_QSO_all = [];
type_tax_employee = 2;
for i=1:length(check_QSO)
    list_1 = check_QSO(i,1);
    list_2 = check_QSO(i,2);
    N = check_QSO(i,3);
       %二分法
       left=0;
       right=Total_cost;
       middle=(left+right)/2;
       %設定salary和ESO初始值，才能進入while迴圈
       CE_employee=0;
       counter=0;
       error=0;min=1000*Total_CE;accurate_wage=0;
       minError_outcome=[];
       while(abs(Total_CE-CE_employee)>threshold && counter<20)
           %以middle當作輸入
           [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma(list_1),T,T_exercise,step,F,c,r,mu,X,N,O,middle,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
           p_correct = sum( length(find(P<0))+length(find(Q<0)) );
           CE_employee=CE(middle,r,Beta,t,Utility,0,gamma(list_2),step,tax_employee,0);
           counter=counter+1;
           error=abs(Total_CE-CE_employee);
           if(error<min)
               min=error;
               accurate_wage=middle;
               previouWage=middle; %提供ESO張數增加後wage搜尋的上界
               Asset=Equity+Debt;
               minError_outcome=[list_1,list_2,Asset,Equity,ESO+Salary,N,ESO,Salary,Utility,min,Debt,sigma(list_1),gamma(list_2)];
           end
           %設定下次的左右界
           if(Total_CE>CE_employee)
               left=middle;
               middle=(left+right)/2;
           else
               right=middle;
               middle=(left+right)/2;
           end
       end
       % 怕外生給定的薪水上界不夠大，確認沒有搜尋錯誤
       if(counter>20)
           errorRecord=[errorRecord;type_tax_employee,list_1,list_2,N,error];
       end
       result_package_temp=[result_package_temp;minError_outcome];
       
       % 儲存所有機率接點
       % 風險中立機率
       P_temp = [];
       [row_p,col_p] = size(P);
       for row=1:row_p
           temp = [list_1 list_2,N,P(row,:)];
           P_temp = [P_temp;temp];
       end
       P_QSO_all = [P_QSO_all;P_temp];
       % 真實世界機率
       Q_temp = [];
       [row_q,col_q] = size(Q);
       for row=1:row_q
           temp = [list_1 list_2,N,Q(row,:)];
           Q_temp = [Q_temp;temp];
       end
       Q_QSO_all = [Q_QSO_all;Q_temp];
       
       type_tax_employee
       i
       error
       N
end
%%
% 判斷 middle point 是否相同
flag_same_middlePoint = 1;
% [list_1 list_2,N,i_node,j,a_node,b,n]
% % union
NQSO_PQ_diffset = setdiff(P_NQSO_all(:,1:8),Q_NQSO_all(:,1:8),'rows');
NQSO_QP_diffset = setdiff(Q_NQSO_all(:,1:8),P_NQSO_all(:,1:8),'rows');
%
QSO_PQ_diffset = setdiff(P_QSO_all(:,1:8),Q_QSO_all(:,1:8),'rows');
QSO_QP_diffset = setdiff(Q_QSO_all(:,1:8),P_QSO_all(:,1:8),'rows');

if(~isempty(NQSO_QP_diffset) || ~isempty(QSO_QP_diffset))
    flag_same_middlePoint = 0;
end

%%
% 判斷 機率是否有小於0  (等價判斷機率有無界於 0~1)
flag_probability_normal = 1;
%NQSO
for i=1:length(P_NQSO_all)
    num = sum(length(find(find(P_NQSO_all(i,:)<0))));
    if(num>0)
        disp('發生機率為負的情況');
        flag_probability_normal = 0;
        break;
    end
end
for i=1:length(Q_NQSO_all)
    num = sum(length(find(find(Q_NQSO_all(i,:)<0))));
    if(num>0)
        disp('發生機率為負的情況');
        flag_probability_normal = 0;
        break;
    end
end

% QSO
for i=1:length(P_QSO_all)
    num = sum(length(find(find(P_QSO_all(i,:)<0))));
    if(num>0)
        disp('發生機率為負的情況');
        flag_probability_normal = 0;
        break;
    end
end
for i=1:length(Q_QSO_all)
    num = sum(length(find(find(Q_QSO_all(i,:)<0))));
    if(num>0)
        disp('發生機率為負的情況');
        flag_probability_normal = 0;
        break;
    end
end

%%
plot_list = [result_prefer_NQSO_maxAsset_A;result_prefer_NQSO_maxEquity_E;result_prefer_NQSO_minCost_C;result_prefer_QSO_maxAsset_A;result_prefer_QSO_maxEquity_E;result_prefer_QSO_minCost_C];
plot_name_list = ['(NQSO)MaxA';'(NQSO)MaxE';'(NQSO)MinC';'(-QSO)MaxA';'(-QSO)MaxE';'(-QSO)MinC'];
size_y = length(sigma);
size_x = length(gamma);
for i=1:6
    figure(i)
    %x = sigma;		
    %y = flip(gamma);
    x = gamma;		
    y = sigma;
    [xx,yy] = meshgrid(x, y);		
    index = 1+size_y*(i-1);
    zz = plot_list(index:index+size_y-1,:);
    mesh(xx, yy, zz);		% 畫出立體網狀圖 
    xlabel('X 軸 = gamma');	% X 軸的說明文字
    ylabel('Y 軸 = sigma');	% Y 軸的說明文字
    title(plot_name_list(i,:))
    name = [run_date,plot_name_list(i,:),'.png'];
    saveas(gcf,name, 'png');
end