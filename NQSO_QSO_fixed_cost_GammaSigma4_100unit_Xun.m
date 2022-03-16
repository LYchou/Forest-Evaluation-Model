clc
clear
% �]�w����
A_discription = '�����]NQSO max asset ��0�A�]�]�ݵ��G�p��A�ѼƳ]�w���W�Ԫ�,step_unit = 4';
% ������ (�Ω�s�Ϫ��ɦW)
run_date = '20210819';
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
Total_CE = 52421244.4442340;
fixed_CE = Total_CE;
threshold = 100;

X=8e6/10;
O=1000*10;

% %����i���i�Ƥ��o��Y�K
% X=8e6/10;
% O=1000*10;



% �V����1�A�V���I���ߡC(�u��@�ɨS�����I���� gamma~=1)
% �t�~�ڥ[�J�@�ӭ��I�S�O�����ߪ�case : gamma = 0.05
gamma=[0.1 0.3 0.5 0.7 0.9];

%gamma=flip(gamma);

% �쥻�� sigma = 0.1~0.7 ���C�����A�t�~�A�b0.1�M0.1857�����h��T���I
sigma = [0.1 0.2 0.3 0.4 0.5];

threshold = 100;

% �վ� mu �M sigma
% mu=0.125;
% mu = transfer_mu(mu,V,F,c);
% Beta = mu; % ��� mu �@�_�վ�

mu = r;
Beta = mu;


for i = 1:length(sigma)
    sigma(i) = transfer_sigma(sigma(i),V,F);
end

%%

% �M��ҫ��̤j�i�H��J�� wage ��@�G���k�j�M�W��
maxWage = search_maxWage(V,5000,step,T,F,tax_firm,c,r);
maxWage = maxWage+5000; % 5000�N�O���F���j�M�W�ɶW�L�i��Jrange���~

% NQSO
ESO_type=1;
type_tax_employee=1;
searchTimes = 70;


MaxN_NQSO=zeros(length(gamma),length(sigma));
result_maxAsset_NQSO = [];
result_maxEquity_NQSO = [];
result_minCost_NQSO = [];
result_maxStock_NQSO = [];
result_all_NQSO = [];

for list_1=1:length(gamma)
    for list_2=1:length(sigma)
        result_particular_level = [];
        previousWage_right = maxWage;
        N=0;
        while 1
           %wage=0�A����N=N*�|���|�W�L�T�wCE
           wage = 0;
           [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option4(V,sigma(list_2),T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma(list_1),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
           CE_employee=CE(0,r,Beta,t,Utility,0,gamma(list_1),step,tax_employee,0);
           if CE_employee>Total_CE ,break,end
           if N>300 ,break,end
           
           %�������Pmu�Mgamma�U�̦h�i�H�o�X�i
           MaxN_NQSO(list_1,list_2)=N;
           
           % �G���k�j�M
           [wage,CE_employee_minError,P_check,Q_check,minError_parameter] = binary_search_fixed_CE4(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma(list_2),T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma(list_1),tax_employee,Beta,w,tax_firm,percent,type_default,method,Div);
           %previousWage_right = wage;
           result_temp = [list_1,list_2,gamma(list_1),sigma(list_2),N,minError_parameter,CE_employee_minError,P_check,Q_check];
           result_particular_level = [result_particular_level;result_temp];
           result_all_NQSO = [result_all_NQSO;result_temp];
           
           disp('NQSO : ');
           disp(['(list_1,list_2)=(',num2str(list_1),',',num2str(list_2),')  / ','N = ',num2str(N),' #(P<0) = ',num2str(P_check),' #(Q<0) = ',num2str(Q_check)]);
           disp(' ');
           
           N = N + 1;
           
           
        end
        
        
        % �̨Τ� ( given gamma(list_1) �A sigma(list_2) �U )
        % �����T�ӭ��V 1. max Asset 2. max Equity 3. min cost
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

        % 3. min cost
        min=V;
        min_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Utility = result_particular_level(i,14);
           cost = result_particular_level(i,12)+result_particular_level(i,13);
           if(cost<min)
               min=cost;
               min_result=result_particular_level(i,:);
           end
        end
        result_minCost_NQSO=[result_minCost_NQSO;min_result];
        
        
%         % 4. max stock price
%         max=0;
%         max_result=[];
%         [n1,n2]=size(result_particular_level);
%         for i=1:n1
%            Stock = result_particular_level(i,11);
%            if(Stock>max)
%                max=Stock;
%                max_result=result_particular_level(i,:);
%            end
%         end
%         result_maxStock_NQSO=[result_maxStock_NQSO;max_result];
    end
end

% mu=mu*,gamma=gamma*�U�A�̨αi�ơA�������
result_prefer_NQSO_maxAsset=zeros(length(gamma),length(sigma));
result_prefer_NQSO_maxEquity=zeros(length(gamma),length(sigma));
result_prefer_NQSO_minCost=zeros(length(gamma),length(sigma));
% result_prefer_NQSO_maxStock=zeros(length(gamma),length(sigma));
result_prefer_NQSO_ESOratio_maxAsset=zeros(length(gamma),length(sigma));
result_prefer_NQSO_ESOratio_maxEquity=zeros(length(gamma),length(sigma));
result_prefer_NQSO_ESOratio_minCost=zeros(length(gamma),length(sigma));
%�g�J�W�z�ŧi�x�}
for i=1:length(gamma)*length(sigma)
    % index
    x=result_maxAsset_NQSO(i,1);
    y=result_maxAsset_NQSO(i,2);
    % �i��
    result_prefer_NQSO_maxAsset(x,y)=result_maxAsset_NQSO(i,5);
    result_prefer_NQSO_maxEquity(x,y)=result_maxEquity_NQSO(i,5);
    result_prefer_NQSO_minCost(x,y)=result_minCost_NQSO(i,5);
%     result_prefer_NQSO_maxStock(x,y)=result_maxStock_NQSO(i,5);
    % ESO�������`���������
    result_prefer_NQSO_ESOratio_maxAsset(x,y)=(result_maxAsset_NQSO(i,12))/Total_cost;
    result_prefer_NQSO_ESOratio_maxEquity(x,y)=(result_maxEquity_NQSO(i,12))/Total_cost;
    result_prefer_NQSO_ESOratio_minCost(x,y)=(result_minCost_NQSO(i,12))/Total_cost;
end


%%

% QSO
ESO_type=0;
type_tax_employee=2;
searchTimes = 70;


MaxN_QSO=zeros(length(gamma),length(sigma));
result_maxAsset_QSO = [];
result_maxEquity_QSO = [];
result_maxUtility_QSO = [];
result_minCost_QSO = [];
result_maxStock_QSO = [];
result_all_QSO = [];

for list_1=1:length(gamma)
    for list_2=1:length(sigma)
        result_particular_level = [];
        previousWage_right = maxWage;
        N=0;
        while 1
           %wage=0�A����N=N*�|���|�W�L�T�wCE
           wage = 0;
           [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO4(V,sigma(list_2),T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma(list_1),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
           CE_employee=CE(0,r,Beta,t,Utility,0,gamma(list_1),step,tax_employee,0);
           if CE_employee>Total_CE ,break,end
           if N>300 ,break,end
           
           %�������Pmu�Mgamma�U�̦h�i�H�o�X�i
           MaxN_QSO(list_1,list_2)=N;
           
           % �G���k�j�M
           [wage,CE_employee_minError,P_check,Q_check,minError_parameter] = binary_search_fixed_CE4(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma(list_2),T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma(list_1),tax_employee,Beta,w,tax_firm,percent,type_default,method,Div);
           %previousWage_right = wage;
           result_temp = [list_1,list_2,gamma(list_1),sigma(list_2),N,minError_parameter,CE_employee_minError,P_check,Q_check];
           result_particular_level = [result_particular_level;result_temp];
           result_all_QSO = [result_all_QSO;result_temp];
           
           disp('QSO : ');
           disp(['(list_1,list_2)=(',num2str(list_1),',',num2str(list_2),')  / ','N = ',num2str(N)]);
           disp(' ');
           
           N = N + 1;
           
        end
        
        
        % �̨Τ� ( given gamma(list_1)�Asigma(list_2) �U )
        % �����T�ӭ��V 1. max Asset 2. max Equity 3. max utility
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
        
        % 3. min cost
        min=V;
        min_result=[];
        [n1,n2]=size(result_particular_level);
        for i=1:n1
           Utility = result_particular_level(i,14);
           cost = result_particular_level(i,12)+result_particular_level(i,13);
           if(cost<min)
               min=cost;
               min_result=result_particular_level(i,:);
           end
        end
        result_minCost_QSO=[result_minCost_QSO;min_result];
        
%         % 4. max stock price
%         max=0;
%         max_result=[];
%         [n1,n2]=size(result_particular_level);
%         for i=1:n1
%            Stock = result_particular_level(i,11);
%            if(Stock>max)
%                max=Stock;
%                max_result=result_particular_level(i,:);
%            end
%         end
%         result_maxStock_QSO=[result_maxStock_QSO;max_result];
%         
    end
end

% mu=mu*,gamma=gamma*�U�A�̨αi�ơA�������
result_prefer_QSO_maxAsset=zeros(length(gamma),length(sigma));
result_prefer_QSO_maxEquity=zeros(length(gamma),length(sigma));
result_prefer_QSO_minCost=zeros(length(gamma),length(sigma));
% result_prefer_QSO_maxStock=zeros(length(gamma),length(sigma));
result_prefer_QSO_ESOratio_maxAsset=zeros(length(gamma),length(sigma));
result_prefer_QSO_ESOratio_maxEquity=zeros(length(gamma),length(sigma));
result_prefer_QSO_ESOratio_minCost=zeros(length(gamma),length(sigma));
%�g�J�W�z�ŧi�x�}
for i=1:length(gamma)*length(sigma)
    % index
    x=result_maxAsset_QSO(i,1);
    y=result_maxAsset_QSO(i,2);
    % �i��
    result_prefer_QSO_maxAsset(x,y)=result_maxAsset_QSO(i,5);
    result_prefer_QSO_maxEquity(x,y)=result_maxEquity_QSO(i,5);
    result_prefer_QSO_minCost(x,y)=result_minCost_QSO(i,5);
%     result_prefer_QSO_maxStock(x,y)=result_maxStock_QSO(i,5);
    % ESO�������`���������
    result_prefer_QSO_ESOratio_maxAsset(x,y)=(result_maxAsset_QSO(i,12))/Total_cost;
    result_prefer_QSO_ESOratio_maxEquity(x,y)=(result_maxEquity_QSO(i,12))/Total_cost;
    result_prefer_QSO_ESOratio_minCost(x,y)=(result_minCost_QSO(i,12))/Total_cost;
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
% % mu=mu*,gamma=gamma*�U�A�̨αi�ơA�������
% result_prefer_QSO_maxStock=zeros(length(mu),length(gamma));
% %�g�J�W�z�ŧi�x�}
% for i=1:length(mu)*length(gamma)
%     % index
%     x=result_maxAsset_QSO(i,1);
%     y=result_maxAsset_QSO(i,2);
%     % �i��
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
% % mu=mu*,gamma=gamma*�U�A�̨αi�ơA�������
% result_prefer_NQSO_maxStock=zeros(length(mu),length(gamma));
% %�g�J�W�z�ŧi�x�}
% for i=1:length(mu)*length(gamma)
%     % index
%     x=result_maxAsset_NQSO(i,1);
%     y=result_maxAsset_NQSO(i,2);
%     % �i��
%     result_prefer_NQSO_maxStock(x,y)=result_maxStock_NQSO(i,5);
% end
% 
% 
