clc
clear
% �]�w����
A_discription = '�ϥ�debug���{�� 3�A��j�M�~�t���p�A�åB�G���k�j�Mwage�W�ɤ��վ�(previousWage_right = Total_cost)�A�A��T�w�����դj���F��j�|�ޮĪG�A�j�M�̤j�i�Ƴ]�w��300�i�A�T�w�����U�A�Q�פ��Pgamma���Psigma�U�T�س̨Τƪ����G�AmaxN=100�A�N�Ѳ����S�v�P�i�ʫ׮ե����겣�A�P�ɽվ�Beta�C';
% ������ (�Ω�s�Ϫ��ɦW)
run_date = '20210611';
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
%Total_cost=V*0.0012021*T;%<�ϥάf�������쪺�ƾ�(�פ夤�T�w�������Ʀr)>
Total_cost=V*0.094*T;%<�ϥ�panda�����W��(�פ夤�T�w�������Ʀr)>

X=8e6;
O=1000;

% %����i���i�Ƥ��o��Y�K
% X=8e6/10;
% O=1000*10;



% �V����1�A�V���I���ߡC(�u��@�ɨS�����I���� gamma~=1)
% �t�~�ڥ[�J�@�ӭ��I�S�O�����ߪ�case : gamma = 0.05
gamma=[0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
%gamma=flip(gamma);

% �쥻�� sigma = 0.1~0.7 ���C�����A�t�~�A�b0.1�M0.1857�����h��T���I
sigma = 0.1:0.1:0.7;

% �վ� mu �M sigma
mu=0.125;
mu = transfer_mu(mu,V,F,c);
Beta = mu; % ��� mu �@�_�վ�
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
        % ���ճ̤jwage�i�H�o�h�֡AEmployee_Stock_Option3���|�����D
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
        
         % ���ճ̤jwage�i�H�o�h�֡AEmployee_Stock_Option3���|�����D
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
