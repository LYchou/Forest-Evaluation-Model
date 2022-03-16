clc
clear
%㏕﹚跑计------------------------
A_description='㏕﹚Θセ程贺程ㄎて(禲参gamma,mu砞﹚)N=';
V=9.91e9;
F=V*0.18;c=0.078;
r=0.06;
sigma=0.3;
X=8e6;
O=1000;
T=10;
Div=0 ;
additional_wealth=[0 ];
w=0.4296;%瘆玻Θセ
tax_firm=0.21; 
type_default=1;
%T_exercise=T-3; %糹
T_exercise=3; 
method=1;
tax_employee=0.05; 
percent=0.5;
Beta=0.125;
%range=1000; %箉猭惠璶
%step_unit=[12];
step_unit=4;
step=T*step_unit;
t=1/step_unit;
Total_cost=V*0.0012021*T;%<ㄏノ琭Щぇт计沮(阶ゅい㏕﹚Θセ计)>


%
% %р糹眎计ち眔竃盞
% X=8e6/10;
% O=1000*10;
% %临эN程100


mu= 0.03:0.03:0.3;
%禫钡1禫繧いミ
gamma = 0.1:0.1:0.9;
gamma = [0.01,gamma];

% は锣Θよ
mu = flip(mu);
gamma = flip(gamma);

% 秸俱 mu ㎝ sigma (盢基厨筍瞯㎝猧笆эΘ戈玻)
for i = 1:length(mu)
    mu(i) = transfer_mu(mu(i),V,F,c);
end
sigma = transfer_sigma(sigma,V,F);


% NQSO
ESO_type=1;
type_tax_employee=1;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);

MaxN_NQSO=zeros(length(mu),length(mu));
result_maxAsset_NQSO = [];
result_maxEquity_NQSO = [];
result_maxUtility_NQSO = [];
result_maxStock_NQSO = [];
result_all_NQSO = [];

for list_1=1:length(mu)
    for list_2=1:length(gamma)
        result_particular_level = [];
        previousWage_right = Total_cost;
        N=0;
        while 1
           %wage=0代刚N=N*穦ぃ穦禬筁㏕﹚CE
           wage = 0;
           [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu(list_1),X,N,O,wage,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
           if (ESO+Salary)>Total_cost ,break,end
           if N>100 ,break,end
           
           %魁ぃmu㎝gamma程祇碭眎
           MaxN_NQSO(list_1,list_2)=N;
           
           % だ猭穓碝
           [wage,ESO,Salary,minError_parameter] = binary_search_fixed_cost(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu(list_1),X,N,O,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,method,Div);
           previousWage_right = wage;
           result_temp = [list_1,list_2,mu(list_1),gamma(list_2),N,minError_parameter];
           result_particular_level = [result_particular_level;result_temp];
           result_all_NQSO = [result_all_NQSO;result_temp];
           
           type_tax_employee
           list_1
           list_2
           N
           
           N = N + 1;
           
           
        end
        
        
        % 程ㄎて ( given mu(list_1) , gamma(list_2)  )
        % だΘ 1. max Asset 2. max Equity 3. max utility
        % 1. max asset
        max=0;
        max_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Asset = result_particular_level(i,9)+result_particular_level(i,10);
           if(Asset>max)
               max=Asset;
               max_result=result_particular_level(i,:);
           end
        end
        result_maxAsset_NQSO=[result_maxAsset_NQSO;max_result];

        % 2. max equity
        max=0;
        max_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Equity = result_particular_level(i,9);
           if(Equity>max)
               max=Equity;
               max_result=result_particular_level(i,:);
           end
        end
        result_maxEquity_NQSO=[result_maxEquity_NQSO;max_result];

        % 3. max utility
        max=0;
        max_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Utility = result_particular_level(i,14);
           if(Utility>max)
               max=Utility;
               max_result=result_particular_level(i,:);
           end
        end
        result_maxUtility_NQSO=[result_maxUtility_NQSO;max_result];
        
        
        % 4. max stock price
        max=0;
        max_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Stock = result_particular_level(i,11);
           if(Stock>max)
               max=Stock;
               max_result=result_particular_level(i,:);
           end
        end
        result_maxStock_NQSO=[result_maxStock_NQSO;max_result];
    end
end

% mu=mu*,gamma=gamma*程ㄎ眎计Θセゑㄒ
result_prefer_NQSO_maxAsset=zeros(length(mu),length(gamma));
result_prefer_NQSO_maxEquity=zeros(length(mu),length(gamma));
result_prefer_NQSO_maxUtility=zeros(length(mu),length(gamma));
result_prefer_NQSO_maxStock=zeros(length(mu),length(gamma));
result_prefer_NQSO_ESOratio_maxAsset=zeros(length(mu),length(gamma));
result_prefer_NQSO_ESOratio_maxEquity=zeros(length(mu),length(gamma));
result_prefer_NQSO_ESOratio_maxUtility=zeros(length(mu),length(gamma));
%糶瓃痻皚
for i=1:length(mu)*length(gamma)
    % index
    x=result_maxAsset_NQSO(i,1);
    y=result_maxAsset_NQSO(i,2);
    % 眎计
    result_prefer_NQSO_maxAsset(x,y)=result_maxAsset_NQSO(i,5);
    result_prefer_NQSO_maxEquity(x,y)=result_maxEquity_NQSO(i,5);
    result_prefer_NQSO_maxUtility(x,y)=result_maxUtility_NQSO(i,5);
    result_prefer_NQSO_maxStock(x,y)=result_maxStock_NQSO(i,5);
    % ESOΘセ羆Θセゑㄒ
    result_prefer_NQSO_ESOratio_maxAsset(x,y)=(result_maxAsset_NQSO(i,12))/Total_cost;
    result_prefer_NQSO_ESOratio_maxEquity(x,y)=(result_maxEquity_NQSO(i,12))/Total_cost;
    result_prefer_NQSO_ESOratio_maxUtility(x,y)=(result_maxUtility_NQSO(i,12))/Total_cost;
%     result_prefer_NQSO_ESOratio_maxAsset(x,y)=(result_maxAsset_NQSO(i,12)+result_maxAsset_NQSO(i,13))/Total_cost;
%     result_prefer_NQSO_ESOratio_maxEquity(x,y)=(result_maxEquity_NQSO(i,12)+result_maxEquity_NQSO(i,13))/Total_cost;
%     result_prefer_NQSO_ESOratio_maxUtility(x,y)=(result_maxUtility_NQSO(i,12)+result_maxUtility_NQSO(i,13))/Total_cost;
end




% QSO
ESO_type=0;
type_tax_employee=2;
fixed_cost = Total_cost;
searchTimes = 20;
threshold = fixed_cost*(2.5/1000);

MaxN_QSO=zeros(length(mu),length(mu));
result_maxAsset_QSO = [];
result_maxEquity_QSO = [];
result_maxUtility_QSO = [];
result_maxStock_QSO = [];
result_all_QSO = [];

for list_1=1:length(mu)
    for list_2=1:length(gamma)
        result_particular_level = [];
        previousWage_right = Total_cost;
        N=0;
        while 1
           %wage=0代刚N=N*穦ぃ穦禬筁㏕﹚CE
           wage = 0;
           [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma,T,T_exercise,step,F,c,r,mu(list_1),X,N,O,wage,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
           if (ESO+Salary)>Total_cost ,break,end
           if N>100 ,break,end
           
           %魁ぃmu㎝gamma程祇碭眎
           MaxN_QSO(list_1,list_2)=N;
           
           % だ猭穓碝
           [wage,ESO,Salary,minError_parameter] = binary_search_fixed_cost(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu(list_1),X,N,O,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,method,Div);
           previousWage_right = wage;
           result_temp = [list_1,list_2,mu(list_1),gamma(list_2),N,minError_parameter];
           result_particular_level = [result_particular_level;result_temp];
           result_all_QSO = [result_all_QSO;result_temp];
           
           type_tax_employee
           list_1
           list_2
           N
           
           N = N + 1;
           
           
        end
        
        
        % 程ㄎて ( given mu(list_1) , gamma(list_2)  )
        % だΘ 1. max Asset 2. max Equity 3. max utility
        % 1. max asset
        max=0;
        max_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Asset = result_particular_level(i,9)+result_particular_level(i,10);
           if(Asset>max)
               max=Asset;
               max_result=result_particular_level(i,:);
           end
        end
        result_maxAsset_QSO=[result_maxAsset_QSO;max_result];

        % 2. max equity
        max=0;
        max_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Equity = result_particular_level(i,9);
           if(Equity>max)
               max=Equity;
               max_result=result_particular_level(i,:);
           end
        end
        result_maxEquity_QSO=[result_maxEquity_QSO;max_result];

        % 1. max utility
        max=0;
        max_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Utility = result_particular_level(i,14);
           if(Utility>max)
               max=Utility;
               max_result=result_particular_level(i,:);
           end
        end
        result_maxUtility_QSO=[result_maxUtility_QSO;max_result];
        
        % 4. max stock price
        max=0;
        max_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Stock = result_particular_level(i,11);
           if(Stock>max)
               max=Stock;
               max_result=result_particular_level(i,:);
           end
        end
        result_maxStock_QSO=[result_maxStock_QSO;max_result];
        
    end
end

% mu=mu*,gamma=gamma*程ㄎ眎计Θセゑㄒ
result_prefer_QSO_maxAsset=zeros(length(mu),length(gamma));
result_prefer_QSO_maxEquity=zeros(length(mu),length(gamma));
result_prefer_QSO_maxUtility=zeros(length(mu),length(gamma));
result_prefer_QSO_maxStock=zeros(length(mu),length(gamma));
result_prefer_QSO_ESOratio_maxAsset=zeros(length(mu),length(gamma));
result_prefer_QSO_ESOratio_maxEquity=zeros(length(mu),length(gamma));
result_prefer_QSO_ESOratio_maxUtility=zeros(length(mu),length(gamma));
%糶瓃痻皚
for i=1:length(mu)*length(gamma)
    % index
    x=result_maxAsset_QSO(i,1);
    y=result_maxAsset_QSO(i,2);
    % 眎计
    result_prefer_QSO_maxAsset(x,y)=result_maxAsset_QSO(i,5);
    result_prefer_QSO_maxEquity(x,y)=result_maxEquity_QSO(i,5);
    result_prefer_QSO_maxUtility(x,y)=result_maxUtility_QSO(i,5);
    result_prefer_QSO_maxStock(x,y)=result_maxStock_QSO(i,5);
    % ESOΘセ羆Θセゑㄒ
    result_prefer_QSO_ESOratio_maxAsset(x,y)=(result_maxAsset_QSO(i,12))/Total_cost;
    result_prefer_QSO_ESOratio_maxEquity(x,y)=(result_maxEquity_QSO(i,12))/Total_cost;
    result_prefer_QSO_ESOratio_maxUtility(x,y)=(result_maxUtility_QSO(i,12))/Total_cost;
%     result_prefer_QSO_ESOratio_maxAsset(x,y)=(result_maxAsset_QSO(i,12)+result_maxAsset_QSO(i,13))/Total_cost;
%     result_prefer_QSO_ESOratio_maxEquity(x,y)=(result_maxEquity_QSO(i,12)+result_maxEquity_QSO(i,13))/Total_cost;
%     result_prefer_QSO_ESOratio_maxUtility(x,y)=(result_maxUtility_QSO(i,12)+result_maxUtility_QSO(i,13))/Total_cost;
end

% %%
% result_maxStock_QSO = [];
% for i=1:150
%     start_index = 101*(i-1)+1;
%     max=0;
%     max_result=[];
%     for j=start_index:start_index+100
%         Stock = result_all_QSO(j,11);
%         if(Stock>max)
%            max=Stock;
%            max_result=result_all_QSO(j,:);
%         end
%     end
%     result_maxStock_QSO=[result_maxStock_QSO;max_result];
% end
% 
% % mu=mu*,gamma=gamma*程ㄎ眎计Θセゑㄒ
% result_prefer_QSO_maxStock=zeros(length(mu),length(gamma));
% %糶瓃痻皚
% for i=1:length(mu)*length(gamma)
%     % index
%     x=result_maxAsset_QSO(i,1);
%     y=result_maxAsset_QSO(i,2);
%     % 眎计
%     result_prefer_QSO_maxStock(x,y)=result_maxStock_QSO(i,5);
% end
% %%
% result_maxStock_NQSO = [];
% for i=1:150
%     start_index = 101*(i-1)+1;
%     max=0;
%     max_result=[];
%     for j=start_index:start_index+100
%         Stock = result_all_NQSO(j,11);
%         if(Stock>max)
%            max=Stock;
%            max_result=result_all_NQSO(j,:);
%         end
%     end
%     result_maxStock_NQSO=[result_maxStock_NQSO;max_result];
% end
% 
% % mu=mu*,gamma=gamma*程ㄎ眎计Θセゑㄒ
% result_prefer_NQSO_maxStock=zeros(length(mu),length(gamma));
% %糶瓃痻皚
% for i=1:length(mu)*length(gamma)
%     % index
%     x=result_maxAsset_NQSO(i,1);
%     y=result_maxAsset_NQSO(i,2);
%     % 眎计
%     result_prefer_NQSO_maxStock(x,y)=result_maxStock_NQSO(i,5);
% end
% 
% 
