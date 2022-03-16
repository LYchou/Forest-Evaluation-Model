clc
clear
%�T�w�ܼ�------------------------

w=0.4296;tax_firm=0.21;%w�OBC tax_firm�O���q�|�v
type_default=1;type_tax_employee=1;%type_tax_employee=1�OProgressive tax =2�Ocapital gain tax

V=[9.91e9 ];%���q�겣����
F=V*0.18;c=0.078;r=0.06;
mu=0.125;
X=8e6;%�i����
O=1000; %��l�Ѳ��i��
T=[5,10];
T=10;%�����
Div=0 ;
T_exercise=3;
% wage=670000;%�~�~
method=1;
tax_employee=0; 
percent=[0.5];%�i�����Z
Beta=0.125;


% Total_CE=[500000 1000000 2000000  2500000]; %ESO �� CE �`�X
Total_CE=[2000000]; %ESO �� CE �`�X
Total_CE=[28200713.5437342];

% Total_cost=2000000;

sigma=[0.1 0.3 0.5 0.7];
% sigma=0.3;
gamma=[0.2 0.5 0.8 1];
% gamma=0.5;
additional_wealth=0;
% gamma=0.2;
N=linspace(0,7,8);%�i���i�� �q0~7
% N=[4,5];
result=[];
result1=[];
step_unit=4;
step=T*step_unit;
t=1/step_unit;
total_step=step;
%gamma=0.2-----------------------
% gamma=1;
% Total_CE=[18000000]; %ESO �� CE �`�X
% lb=6000000;ub=10000000;%gamma=0.2�~�����W�U�� 
% threshold=3000;
% %gamma=0.5-----------------------
% gamma=0.5;
% Total_CE=[18000000]; %ESO �� CE �`�X
% lb=5000000;ub=10000000;%gamma=0.5�~�����W�U�� 
% threshold=5000;
% % gamma=0.8------------------------
% gamma=0.8;
% Total_CE=[900000000]; %ESO �� CE �`�X
% lb=100000000;ub=1000000000;
% threshold=8000;
% gamma=1------------------------
gamma=[0.2 0.5 0.8 1];
gamma=[0.7];
% Total_CE=[900000000]; %ESO �� CE �`�X
% Total_CE=[28200713.5437342];
% Total_CE=[6755803.36953571];
Total_CE=[52421244.4442340];

lb=0;ub=2e7;
speed_up_threshold=10;
range=100000;
threshold=10000;
% gamma=1.2------------------------
% gamma=1.2;
% Total_CE=[900000000]; %ESO �� CE �`�X
% lb=60000000;ub=1000000000;
% threshold=10000;


result_all=[];
result=[];
% NQSO=[1 2];%1�N��NQSO 2�OQSO
% g1=1;
% NQSO
g1=1;
for list_5=1:length(Total_CE)
    disp('Total CE='+string(Total_CE(list_5)))
for list_3=1:length(sigma)
    disp('sigma='+string(sigma(list_3)))
for list_4=1:length(gamma)
    disp('gamma='+string(gamma(list_4)))
    g1=(list_5-1)*3+list_4;
    disp('g1='+string(g1))
%     result=[];
    result1=[];
    wage=linspace(lb,ub,range); 
    idx=zeros(1,length(N));%�x�s�i�ƹ����ĴX���~��
    idx(length(N))=1;%�q0�i�}�l �ݭn���~�����ӳ̰� 9941 8830 �ҥHindex�̦h

    for list_2=length(N):-1:1  %list2 �N���~���qESO�i�Ƴ̦h�}�l 
        if list_2==length(N)
            a1=idx(length(N));
        else
            a1=idx((list_2));
        end

        dis=0;
        a2=1;
        %�ۦ���127�欰�^�N�[�t �i���L�� -------------------------------------------------------------------------------------  
        for list_1=a1:a1+1 %�[�t
            %0�iESO �¬��~�����ĥ�
%             [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%             Utility_no_ESO=Utility;
            %N�iESO ���~��+ESO���ĥ�
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            Utility_with_ESO=Utility;
            CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);

            dis=CE_employee-dis;            
%             S1=Salary;
%             E1=ESO;
        end   
        Total_dis=-(CE_employee-Total_CE(list_5)); %�ⶡ�Z
        if dis > 0 && round((Total_dis/dis)*0.9,0)+a1<range && round((Total_dis/dis)*0.9,0)+a1>0
%             [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%             Utility_no_ESO=Utility;
            %N�iESO ���~��+ESO���ĥ�
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(round((Total_dis/dis)*0.9,0)+a1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            Utility_with_ESO=Utility;
            CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);
            if CE_employee-Total_CE(list_5)<0 %�i�H�~���
                a2=a1;
                a1=round((Total_dis/dis)*0.9,0)+a1;  
            end
        end
%         disp('a1='+string(a1)+'  a2='+string(a2)+'  Total_CE='+string(Total_CE(list_5))+' �M�ؼ�CE�t�Z='+string(CE_employee-Total_CE(list_5)))
        while a1-a2>speed_up_threshold && dis>0&& CE_employee-Total_CE(list_5)<0
                for list_1=a1:a1+1 %�[�t
                    %0�iESO �¬��~�����ĥ�
%                     [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%                     Utility_no_ESO=Utility;
                    %N�iESO ���~��+ESO���ĥ�
                    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
                    Utility_with_ESO=Utility;
                    CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);

                    dis=CE_employee-dis;            
        %             S1=Salary;
        %             E1=ESO;
                end   
                Total_dis=-(CE_employee-Total_CE(list_5)); %�ⶡ�Z
                if dis > 0 && round((Total_dis/dis)*0.9,0)+a1<range && round((Total_dis/dis)*0.9,0)+a1>0
%                     [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%                     Utility_no_ESO=Utility;
                    %N�iESO ���~��+ESO���ĥ�
                    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(round((Total_dis/dis)*0.9,0)+a1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
                    Utility_with_ESO=Utility;
                    CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);
                    if CE_employee-Total_CE(list_5)<0 %�i�H�~���
                        a2=a1;
                        a1=round((Total_dis/dis)*0.9,0)+a1;  
                        disp('�ثe�^�N���'+string(a1)+'���h'+'  Total_CE='+string(Total_CE(list_5))+' �M�ؼ�CE�t�Z='+string(CE_employee-Total_CE(list_5)))
                    end
                end    
         end
         %��69��ܦ����^�N�[�t �i���L�� -------------------------------------------------------------------------------------  

        
        for list_1=a1:range %��X�^�N�����G�� �i�H�N�~���C�C�դ� ��ESO_CE�ŦX�ڭ̪��ؼ�
%             [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%             Utility_no_ESO=Utility;
            %N�iESO ���~��+ESO���ĥ�
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            Utility_with_ESO=Utility;
            CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);
            p_correct=sum( length(find(1<0))+length(find(Q<0)) );
            Asset=Equity+Debt+ESO+Dividend+Salary-TB+BC;     
            disp('gamma='+string(gamma(list_4))+'  sigma='+string(sigma(list_3))+'  Total_CE='+string(Total_CE(list_5))+'  ESO�i��='+string(N(list_2))+'  �~�����='+string(wage(list_1))+' �M�ؼ�CE�t�Z='+string(CE_employee-Total_CE(list_5))+'  �ĴX��='+string(list_1))
            
            if abs(CE_employee-Total_CE(list_5))<threshold
                result=[result;sigma(list_3),gamma(list_4),wage(list_1),N(list_2),Salary,ESO,Salary+ESO,Equity,Debt,Equity+Debt,Asset,CE_employee-Total_CE(list_5),Total_CE(list_5),CE_employee];
                result_all=[result_all;sigma(list_3),gamma(list_4),wage(list_1),N(list_2),Salary,ESO,Salary+ESO,Equity,Debt,Equity+Debt,Asset,CE_employee-Total_CE(list_5),Total_CE(list_5),CE_employee];
                if list_2>1
                idx(list_2-1)=list_1;
                end
                break
            end
            result1=[result1;sigma(list_3),gamma(list_4),wage(list_1),N(list_2),Salary,ESO,Salary+ESO,Equity,Debt,Equity+Debt,CE_employee-Total_CE(list_5),Total_CE(list_5),Asset,sigma(list_3),gamma(list_4)];
        end
    end
end
end
end


% QSO

type_tax_employee=2;
for list_5=1:length(Total_CE)
    disp('Total CE='+string(Total_CE(list_5)))
for list_3=1:length(sigma)
    disp('sigma='+string(sigma(list_3)))
for list_4=1:length(gamma)
    disp('gamma='+string(gamma(list_4)))
    g1=(list_5-1)*3+list_4;
    disp('g1='+string(g1))
%     result=[];
    result1=[];
    wage=linspace(lb,ub,range); 
    idx=zeros(1,length(N));%�x�s�i�ƹ����ĴX���~��
    idx(length(N))=1;%�q0�i�}�l �ݭn���~�����ӳ̰� 9941 8830 �ҥHindex�̦h

    for list_2=length(N):-1:1  %list2 �N���~���qESO�i�Ƴ̦h�}�l 
        if list_2==length(N)
            a1=idx(length(N));
        else
            a1=idx((list_2));
        end

        dis=0;
        a2=0;
        %�ۦ���127�欰�^�N�[�t �i���L�� -------------------------------------------------------------------------------------  
        for list_1=a1:a1+1 %�[�t
            %0�iESO �¬��~�����ĥ�
%             [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%             Utility_no_ESO=Utility;
            %N�iESO ���~��+ESO���ĥ�
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            Utility_with_ESO=Utility;
            CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);

            dis=CE_employee-dis;            
%             S1=Salary;
%             E1=ESO;
        end   
        Total_dis=-(CE_employee-Total_CE(list_5)); %�ⶡ�Z
        if dis > 0 && round((Total_dis/dis)*0.9,0)+a1<range && round((Total_dis/dis)*0.9,0)+a1>0
%             [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%             Utility_no_ESO=Utility;
            %N�iESO ���~��+ESO���ĥ�
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(round((Total_dis/dis)*0.9,0)+a1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            Utility_with_ESO=Utility;
            CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);
            if CE_employee-Total_CE(list_5)<0 %�i�H�~���
                a2=a1;
                a1=round((Total_dis/dis)*0.9,0)+a1;  
            end
        end
        while a1-a2>speed_up_threshold && dis>0&& CE_employee-Total_CE(list_5)<0
                for list_1=a1:a1+1 %�[�t
                    %0�iESO �¬��~�����ĥ�
%                     [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%                     Utility_no_ESO=Utility;
                    %N�iESO ���~��+ESO���ĥ�
                    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
                    Utility_with_ESO=Utility;
                    CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);

                    dis=CE_employee-dis;            
        %             S1=Salary;
        %             E1=ESO;
                end   
                Total_dis=-(CE_employee-Total_CE(list_5)); %�ⶡ�Z
                if dis > 0 && round((Total_dis/dis)*0.9,0)+a1<range && round((Total_dis/dis)*0.9,0)+a1>0
%                     [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
%                     Utility_no_ESO=Utility;
                    %N�iESO ���~��+ESO���ĥ�
                    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(round((Total_dis/dis)*0.9,0)+a1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
                    Utility_with_ESO=Utility;
                    CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);
                    if CE_employee-Total_CE(list_5)<0 %�i�H�~���
                        a2=a1;
                        a1=round((Total_dis/dis)*0.9,0)+a1;  
                        disp('�ثe�^�N���'+string(a1)+'���h'+'  Total_CE='+string(Total_CE(list_5))+' �M�ؼ�CE�t�Z='+string(CE_employee-Total_CE(list_5)))
                    end
                end    
         end
         %��69��ܦ����^�N�[�t �i���L�� -------------------------------------------------------------------------------------  

        
        for list_1=a1:range %��X�^�N�����G�� �i�H�N�~���C�C�դ� ��ESO_CE�ŦX�ڭ̪��ؼ�
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,0,O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            Utility_no_ESO=Utility;
            %N�iESO ���~��+ESO���ĥ�
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V,sigma(list_3),T,T_exercise,step,F,c,r,mu,X,N(list_2),O,wage(list_1),additional_wealth,gamma(list_4),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            Utility_with_ESO=Utility;
            CE_employee=CE(wage(list_1),r,Beta,t,Utility_with_ESO,0,gamma(list_4),total_step,tax_employee,0);
            p_correct=sum( length(find(1<0))+length(find(Q<0)) );
            Asset=Equity+Debt+ESO+Dividend+Salary-TB+BC;     
            disp('gamma='+string(gamma(list_4))+'  sigma='+string(sigma(list_3))+'  Total_CE='+string(Total_CE(list_5))+'  ESO�i��='+string(N(list_2))+'  �~�����='+string(wage(list_1))+' �M�ؼ�CE�t�Z='+string(CE_employee-Total_CE(list_5))+'  �ĴX��='+string(list_1))
            
            if abs(CE_employee-Total_CE(list_5))<threshold
                result=[result;sigma(list_3),gamma(list_4),wage(list_1),N(list_2),Salary,ESO,Salary+ESO,Equity,Debt,Equity+Debt,Asset,CE_employee-Total_CE(list_5),Total_CE(list_5),CE_employee];
                result_all=[result_all;sigma(list_3),gamma(list_4),wage(list_1),N(list_2),Salary,ESO,Salary+ESO,Equity,Debt,Equity+Debt,Asset,CE_employee-Total_CE(list_5),Total_CE(list_5),CE_employee];
                if list_2>1
                idx(list_2-1)=list_1;
                end
                break
            end
            result1=[result1;sigma(list_3),gamma(list_4),wage(list_1),N(list_2),Salary,ESO,Salary+ESO,CE_employee-Total_CE(list_5),Total_CE(list_5),Asset,sigma(list_3),gamma(list_4)];
        end
    end
   end
end
end

x=result';
% g1=1;
% %�e��
% for list_4=1:length(gamma)
% for i=1:2
% plot(x(4,(list_4-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*list_4+(i-1)*length(gamma)*length(N)),x(7,(list_4-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*list_4+(i-1)*length(gamma)*length(N)),'--o');
% % xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('�~���[ESO�`����','FontWeight','bold','fontsize',14)
% xlabel('the Ratio of ESO(���`��M�}���ĪG) to Equity(?)','FontWeight','bold','fontsize',14),ylabel('Total Cost of Salary and ESO','FontWeight','bold','fontsize',14)
% title('Total CE='+string(Total_CE(list_5))+'  '+'sigma='+string(sigma(list_3))+'  '+'gamma='+string(gamma(list_4)))
% hold on
% end
% legend('NQSO','QSO','Location','northeast');
% %�e�ϸ��|
% hold off
% print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\��s���G\fixed CE\sigma\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
% 
% g1=g1+1;
% end
% for list_4=1:length(gamma)
% for i=1:2
% plot(x(4,(list_4-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*list_4+(i-1)*length(gamma)*length(N)),x(10,(list_4-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*list_4+(i-1)*length(gamma)*length(N)),'--o');
% % xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
% xlabel('the Ratio of ESO(���`��M�}���ĪG) to Equity(?)','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
% title('Total CE='+string(Total_CE(list_5))+'  '+'sigma='+string(sigma(list_3))+'  '+'gamma='+string(gamma(list_4)))
% hold on
% end
% legend('NQSO','QSO','Location','northeast');
% 
% hold off
% %�e�ϸ��|
% print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\��s���G\fixed CE\sigma\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
% g1=g1+1;
% end
%sigma--------------------------------------------------------
xlswrite('C:\Users\hijac\OneDrive\�ୱ\��j\ESO��s���G0819.xlsx',x,'���`��gamma=0.7');
g1=1;
% for j=1:length(gamma)
for j=1:length(sigma)
for i=1:2
% plot(x(4,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),x(7,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),'--o');
plot(x(4,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),x(7,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),'--o');

% xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('�~���[ESO�`����','FontWeight','bold','fontsize',14)
xlabel('the Ratio of ESO(���`��M�}���ĪG) to Equity(?)','FontWeight','bold','fontsize',14),ylabel('Total Cost of Salary and ESO','FontWeight','bold','fontsize',14)

% title('Total CE='+string(Total_CE(list_5))+'  '+'sigma='+string(sigma(list_3))+'  '+'gamma='+string(gamma(j)))
title('Total CE='+string(Total_CE(list_5))+'  '+'sigma='+string(sigma(j))+'  '+'gamma='+string(gamma(list_4)))
hold on
end
legend('NQSO','QSO','Location','northeast');
%�e�ϸ��|
hold off
print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\0819\fixed CE\sigma2\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>

g1=g1+1;
end
% for j=1:length(gamma)
for j=1:length(sigma)
for i=1:2
% plot(x(4,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),x(10,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),'--o');
plot(x(4,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),x(10,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),'--o');% xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
xlabel('the Ratio of ESO(���`��M�}���ĪG) to Equity(?)','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
% title('Total CE='+string(Total_CE(list_5))+'  '+'sigma='+string(sigma(list_3))+'  '+'gamma='+string(gamma(j)))
title('Total CE='+string(Total_CE(list_5))+'  '+'sigma='+string(sigma(j))+'  '+'gamma='+string(gamma(list_4)))
hold on
end
legend('NQSO','QSO','Location','southwest');

hold off
%�e�ϸ��|
print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\0819\fixed CE\sigma2\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
g1=g1+1;
end

