clc
clear
%�T�w�ܼ�------------------------

w=0.4296;tax_firm=0.21;%w�OBC tax_firm�O���q�|�v
type_default=1;

V=[9.91e9 ];%���q�겣����
F=V*0.18;c=0.078;r=0.06;
mu=0.125;
X=8e6;%�i����
O=1000; %��l�Ѳ��i��
T=10;%�����
Div=0;
T_exercise=3;
% wage=670000;%�~�~
method=1;
tax_employee=0; 
percent=[0.5];%�i�����Z
Beta=0.125;
additional_wealth=0;
N=linspace(0,7,8);%�i���i�� �q0~7

result1=[];
step_unit=4;

step=T*step_unit;
t=1/step_unit;
total_step=step;

Total_CE=[52421244.4442340];
% �T�w���u�P����(certainty equivalence)���Ȭ� 52421244.4442340�A����
% �ȬO�b�{���v�i�Ƭ� 7 �i�B gamma=1(���I����)�ɡAQSO �p��X�ӻ{���v�M
% �~��(�~�~:670,000�A������ Otto(2014))����u���`�P���סA�H gamma=1
% �@����¦�O�]���ۦP�P���פάۦP����U�A���I���ת����u�ݭn���~���|��
% �I���ߪ����u�ݭn���h�A�o�˴N��T�O�Ҧ����p�U�����쪺�~�������t�ȡC


% NQSO=[1 2];%1�N��NQSO 2�OQSO
sigma=0.3;gamma=[0.2 0.5 0.7 0.9];

% NQSO
type_tax_employee=1;%type_tax_employee=1�OProgressive tax =2�Ocapital gain tax

result=[];
position=[];
for list_2=1:length(gamma)
    for list_3=1:2 
        left=0;
        previousWage=2e7;
        right=previousWage;
        for list_1=1:length(N)
            N(list_1)
            % �G���k�j�M �վ�wage���T�wCE
            minError_result=[];

            counter=0;
            CE_wage_ESO=0;
            error=Total_CE;
            min=error;

            left=0;right=previousWage;
            middle=(left+right)/2;
            while (abs(error)>10000 && counter<20)
                position=[position;N(list_1),list_3,gamma(list_2),left,middle,right];
                counter=counter+1;
                if list_3==1
                    type_tax_employee=1;%type_tax_employee=1�OProgressive tax =2�Ocapital gain tax
                    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N(list_1),O,middle,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
                elseif list_3==2
                    type_tax_employee=2;
                    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma,T,T_exercise,step,F,c,r,mu,X,N(list_1),O,middle,additional_wealth,gamma(list_2),tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
                end
               
                CE_wage_ESO=CE(middle,r,Beta,t,Utility,0,gamma(list_2),total_step,tax_employee,0);
                error=Total_CE-CE_wage_ESO;
                if abs(error)<min
                    min=abs(error);
                    minError_result=[N(list_1),Salary+ESO,gamma(list_2),list_3,middle,error,CE_wage_ESO];
                    %�x�s�n�����

                end
                %�G���k�^�a�U�@������
                if error<0 %�n����CE�ҥH�W�[wage
                    right=middle;
                else 
                    left=middle;
                end
                middle=(left+right)/2;
            end
            previousWage=minError_result(5);
            result=[result;minError_result];
        end
    end
end


% for j=1:length(gamma)
%     
%     x1=[];y1=[];
%     x2=[];y2=[];
%     [n1,~]=size(result);
%     for i=1:n1
%         if result(i,4)==1
%             x1=[x1;result(i,1)/O];
%             y1=[y1;result(i,2)];
%         else
%             x2=[x2;result(i,1)/O];
%             y2=[y2;result(i,2)];
%         end
%     end
%     plot(x1,y1,'--o');hold on;plot(x2,y2,'--+');hold off;
%     
% end




