function [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div)
%sigma=���q�겣���ȼзǮt(%)
%step=����            %V=���q�겣����        %wage=���u�~��(�~)
%X=���u�{���v�ҭ��B    %N=���u�{���v�Ҽƶq    %T_exercise=���u�i�i����
%F=�Ũ魱�B           %c=�Ũ�Ů��v          %T=�Ũ�����
%r=�L���I�Q�v         %w=�}������            %gamma=�ĥΨ�ƪ������             
%tax_firm=���q�|�v    %tax_employee=���u�ұo�|
%Equity_value=�ѪF����

%x=���w�Ӵ��w�`��x%�����u�{���v
%y=�Ӵ����`���y%�����u�{���v
%Alpha=���@��y=a%�A���j�ƭ��u���ĥ�
%percent=���ʤ���(%)

if nargin<15,error('at least 15 input arguments required'),end
%�ɶ����{��---------------------------------------------------------------
t=T/step; 
%�ʤ���ƦC����-------------------------------------------------------------
Percentage=1/percent+1;
%�p��}�����---------------------------------------------------------------
default_boundary_value=Default_boundary(type_default,step,T,F,tax_firm,c,r,wage); %�H�����e
default_wage_value=Default_boundary(type_default,step,T,0,tax_firm,c,r,wage); %���q�˳� ���u�Ӯ�������
%�겣��W�ɪ�l��-----------------------------------------------------------
firm_value=V;
Up_boundary_value=[];Nodes=[];
for i=Percentage:-1:1 %��X�U�h�겣�ƻP�U�Ӯɴ����W��
    [up_boundary_value,nodes]=Up_boundary(step,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N,percent); %�W��
    Up_boundary_value=[up_boundary_value;Up_boundary_value]; %�W����DB�X���I(2sigma�ڸ�delta t)
%     Nodes=[nodes;Nodes];
    Nodes(i,:)=nodes;
    firm_value=Up_boundary_value;
end
%�إ߸겣�����-------------------------------------------------------------
[firm_tree_value,max_time_node]=Firm_tree_value(V,sigma,step,t,default_boundary_value,Nodes);
%�إ߭ӻ��Ⱦ�---------------------------------------------------------------
Equity_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
Stock_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
Debt_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
ESO_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
Utility_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
alpha=zeros(Percentage,Percentage,max(max_time_node),step+1);
Dividend_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
TB_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
BC_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
Salary_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
P=[];Q=[];



if method==1
    %method1�̨Τƭ��u�ĥ�-------------------------------------------------
    for j=step+1:-1:1%���q�겣���Ȧbt���I
%     for j=step+1:-1:step*T_exercise/T+1
%       for j=step*T_exercise/T:-1:2
       for a=1:Percentage%�ثe�Ҧb���겣��O�Hū�^�h�֦ʤ���A a=1 �� 100% ; a=Percentage �� 0%
           %�w�����uū�^a%���ƭ��ഫ
           a_node=Percentage-a+1;
           for i=1:Nodes(a,j)%���P�h��Үi�X�h���W�ɬҤ��P�A i=1 ���}�����
               %�bj���I�ɪ��겣���Ȱ��סAi=1 ���}����ɡA���W��
               i_node=max(max_time_node)+1-i;
               for b=a_node:Percentage %0% 50% 100%
                   %�w�����u�U�@��ū�^a%���ƭ��ഫ=�o�@����b%
                   next_time_a=Percentage-b+1;
                   %�P�_�O�_�}��
                   if abs( firm_tree_value(i_node,j) - default_boundary_value(j) ) > 10^-10
                       if j==step+1%�̫�@��
                           %�ѪF����--------------------------------------------
                           %ESO�|�ޥ[�JN*(S-X)*tax
                           Equity_value(a,b,i_node,j)=max((firm_tree_value(i_node,j)-F*(1+(1-tax_firm)*c*t)-O*Div*t-(1-tax_firm)*wage*t+(1-tax_firm)*( b - a_node )*X*N*percent)/(1-tax_firm*(( b - a_node )*N*percent/(O+(b-1)*N*percent))),0);
                           %�C�ѻ���--------------------------------------------
                           %���u�{���v���`���Ȥ��ܮɡA���B�V�C�A�ѼƶV���A�|�}���ѻ��A�ɭP�����i��
                           Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                           
                           %�Ũ����--------------------------------------------
                           
                           Debt_value(a,b,i_node,j)=F*(1+c*t);
                           Dividend_value(a,b,i_node,j)=O*Div*t;
                           %ESO����---------------------------------------------
                           TB_value(a,b,i_node,j)=F*tax_firm*c*t+tax_firm*wage*t;
                           BC_value(a,b,i_node,j)=0;
                           Salary_value(a,b,i_node,j)=wage*t;
                           %�p����u�]�I(�w���|)
                           [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,Stock_value(a,b,i_node,j),X,a_node,b,N,percent,Div,O);
                           %�P�_���u���̾A�ĥάO�_�|�i��ESO
                           Utility_value(a,b,i_node,j)=Wealth^gamma;
                           if excercise~=true && b>a_node %���i�i���A�����ۨS���i������
                               Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                               Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                               Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                               Dividend_value(a,b,i_node,j)=Dividend_value(a,a_node,i_node,j);
                           end    
                           if excercise==true %�i��ESO�|���͵|�ޮĪG
                              TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+tax_firm*( Stock_value(a,b,i_node,j)-X)*( b - a_node )*N*percent;
                           end
                       elseif j>=step*T_exercise/T+1&&j~=1%���u�i�H�i��
                           %���u�i���᪺�겣����--------------------------------
                           V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t+( b - a_node )*X*N*percent;
                           %BTT�p����v-----------------------------------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %���u�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                           BTT_B_node=max(max_time_node)-n; 
                           if BTT_B_node==1 %�Y�W�L��� �ץ��^��
                               BTT_B_node=2;
                           end
                           if n>0 
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               %�ѪF����----------------------------------------
                               if  b - a_node>0 && Stock_value(a,b,i_node,j)>X  %�NESO�|�ޮĪG���N �D�X�z�Q�ƪ��ѻ�
                                   S=zeros(2,1);
                                   S(2,1)=Stock_value(a,b,i_node,j);
                                   while S(2,1)-S(1,1)>0.0001 %���L�]�즬�K ������ѻ��|�p��X�s�ѻ�->�s���q����->�s�ѻ� �]��ѻ�����
                                       Injection_TS=tax_firm*(S(2,1)-X)*( b - a_node )*N*percent;
                                       V1=V_t+Injection_TS;
                                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V1,default_boundary_value(j+1));
    %                                    P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                                       %���u�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                                       BTT_B_node=max(max_time_node)-n; 
                                       if BTT_B_node==1
                                           BTT_B_node=2;
                                       end
                                       S(1,1)=S(2,1);
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                       %�C�ѻ���----------------------------------------
                                       S(2,1)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   end
                                   Stock_value(a,b,i_node,j)=S(2,1);
                               end
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                               Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , Dividend_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+O*Div*t;

                               %ESO����-----------------------------------------
                               TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , TB_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                               BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , BC_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , Salary_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+wage*t;

                               %�p����u�]�I(�w���|)
                               [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,Stock_value(a,b,i_node,j),X,a_node,b,N,percent,Div,O);
                               %�P�_���u���̾A�ĥάO�_�|�i��ESO
                               [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                               Q=[Q;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                               Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,Beta,t);
                               if excercise~=true && b>a_node  %�p�G�w��b�ɤ��|�i���A�h�����Ȧs��a_node(�L�i��)����
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   Utility_value(a,b,i_node,j)=Utility_value(a,a_node,i_node,j);
                                   Dividend_value(a,b,i_node,j)=Dividend_value(a,a_node,i_node,j);
                               end
                               if excercise==true %NQSO�i���ɡAESO�|���͵|��
                                   TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+( b - a_node )*( Stock_value(a,b,i_node,j)-X)*N*percent*tax_firm;
                               end

                           elseif n==0 && V_t>default_boundary_value(j) %�w�������I����U�����H�����e
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               if Stock_value(a,b,i_node,j)>X %�NESO�|�ޮĪG���N �D�X�z�Q�ƪ��ѻ� 
                                   S=zeros(2,1);
                                   S(2,1)=Stock_value(a,b,i_node,j);
                                   while S(2,1)-S(1,1)>0.0001  %���L�]�즬�K
                                       Injection_TS=tax_firm*(S(2,1)-X)*( b - a_node )*N*percent;
                                       V1=V_t+Injection_TS;
                                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V1,default_boundary_value(j+1));
    %                                    P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                                       %���u�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                                       BTT_B_node=max(max_time_node)-n; 
                                       S(1,1)=S(2,1);
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0,b);
                                       %�C�ѻ���----------------------------------------
                                       S(2,1)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                                   end
                                   Stock_value(a,b,i_node,j)=S(2,1);
                               end
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , (1-w)*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t)+F*c*t;
                               Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+O*Div*t;

                               %ESO����-----------------------------------------
                               TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                               BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , w*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)),r,t);
                               Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+wage*t;

                               %�p����u�]�I(�w���|)
                               [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,Stock_value(a,b,i_node,j),X,a_node,b,N,percent,Div,O);
                               %�P�_���u���̾A�ĥάO�_�|�i��ESO
                               [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                               Q=[Q;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                               Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,Beta,t);
                               if excercise~=true && b>a_node
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   Utility_value(a,b,i_node,j)=Utility_value(a,a_node,i_node,j);
                                   Dividend_value(a,b,i_node,j)=Dividend_value(a,a_node,i_node,j);
                               end
                               if excercise==true %�i��ESO���|��
                                   TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+( b - a_node )*( Stock_value(a,b,i_node,j)-X)*N*percent*tax_firm;
                               end
                           else %n<=0�N�N��}��
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*(firm_tree_value(i_node,j)-default_wage_value(j));
                               Dividend_value(a,b,i_node,j)=0;
                               %ESO����-----------------------------------------
                               TB_value(a,b,i_node,j)=0;
                               BC_value(a,b,i_node,j)=w*(firm_tree_value(i_node,j)-default_wage_value(j));
                               Salary_value(a,b,i_node,j)=default_wage_value(j);
                               %�p����u�ĥΨ�ƺ�
                               Utility_value(a,b,i_node,j)=0;
                           end
                       elseif j<step*T_exercise/T+1||j==1%���u���i�H�i��
                           if b==1 %�b�k�ݤ�e���O0%�A�o�O0%���x�}��m
                               %���u�i���᪺�겣����-----------------------------
                               if j>1
                                   V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t;
                               else
                                   V_t=V;
                               end
                               %BTT�p����v-------------------------------------
                               [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                               %���u�i���᪺�겣���ȦbBTT���I��B�`�I-------------
                               BTT_B_node=max(max_time_node)-n;
                               if j==1
                                   i_node=BTT_B_node;
                               end
                               P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                               if n>0 
                                   %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                                   if j==step*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node+1,j+1) ,r,t);
                                   TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , TB_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , BC_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , Salary_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);

                                   if j>1
                                       Debt_value(a,b,i_node,j)=Debt_value(a,b,i_node,j)+F*c*t;
                                       Dividend_value(a,b,i_node,j)=Dividend_value(a,b,i_node,j)+O*Div*t;
                                       TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+F*tax_firm*c*t+tax_firm*wage*t;
                                       Salary_value(a,b,i_node,j)=Salary_value(a,b,i_node,j)+wage*t;
                                   end
                                   %ESO����-------------------------------------
                                   %�p����u�~�~(�w���|)
                                   Wealth=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,X,X,a_node,b,0,percent,Div,O);
                                   %�p����u�ĥΨ�ƺ�
                                   [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                                   Q=[Q;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                                   Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,Beta,t);
                               elseif n==0 && V_t>default_boundary_value(j) %�w�������I����U�����H�����e
                                   %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                                   if j==step*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , (1-w)*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t)+F*c*t;
                                   Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+O*Div*t;

                                   %ESO����------------------------------------
                                   TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                                   BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , w*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t);
                                   Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+wage*t;

                                   %�p����u�~�~(�w���|)
                                   Wealth=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,X,X,a_node,b,N,percent,Div,O);
                                   %�p����u�ĥΨ�ƺ�
                                   [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                                   Q=[Q;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                                   Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,Beta,t);
                               else %n<=0�N�N��}��
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=0;
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=0;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=(1-w)*(firm_tree_value(i_node,j)-default_wage_value(j));%�M��᪺��
                                   Dividend_value(a,b,i_node,j)=0;
                                   %ESO����-----------------------------------------
                                   TB_value(a,b,i_node,j)=0;
                                   BC_value(a,b,i_node,j)=w*(firm_tree_value(i_node,j)-default_wage_value(j)); %�ѤU�������M�����
                                   Salary_value(a,b,i_node,j)=default_wage_value(j); %���u�Ӯ�����

                                   %�p����u�ĥΨ�ƺ�
                                   Utility_value(a,b,i_node,j)=0;
                               end
                           end
                       end
                   else
                       %�C�ѻ���------------------------------------------------
                       Stock_value(a,b,i_node,j)=0;
                       %�ѪF����------------------------------------------------
                       Equity_value(a,b,i_node,j)=0;
                       %�Ũ����------------------------------------------------
                       Debt_value(a,b,i_node,j)=(1-w)*(firm_tree_value(i_node,j)-default_wage_value(j));
                       Dividend_value(a,b,i_node,j)=0;
                       %ESO����-----------------------------------------
                       TB_value(a,b,i_node,j)=0;
                       BC_value(a,b,i_node,j)=w*(firm_tree_value(i_node,j)-default_wage_value(j));
                       Salary_value(a,b,i_node,j)=default_wage_value(j);
                       %�p����u�ĥΨ�ƺ�
                       Utility_value(a,b,i_node,j)=0;
                   end
               end           
               %��X���u�ĥγ̤j�Ʈ���ū�^�ܦh��b%
               alpha_Utility=min(find(Utility_value(a,a_node:Percentage,i_node,j)==max(Utility_value(a,a_node:Percentage,i_node,j))))+a_node-1;
               Payoff=max(Stock_value(a,alpha_Utility,i_node,j)-X,0);
               alpha(a,alpha_Utility,i_node,j)=(alpha_Utility-1)*percent;
               next_time_a=Percentage-alpha_Utility+1;
               %�P�_�O�_�}��                           
               if abs( firm_tree_value(i_node,j) - default_boundary_value(j) ) >10^-10 || j==1
                   if j==step+1
                       ESO_value(a,alpha_Utility,i_node,j)=N*( alpha_Utility - a_node )*percent*Payoff;
                   elseif j>=step*T_exercise/T+1&&j~=1
                       %���u�̾A�i���᪺�겣����---------------------------------
                       V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t+( alpha_Utility - a_node )*X*N*percent+tax_firm*( alpha_Utility - a_node )*Payoff*N*percent;
                       %���u�̾A�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                       BTT_B_node=max(max_time_node)-n;
                       if n>0 
                           %�bt+delta���I�U���̾A�ഫ��vAlpha-----------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node+1,j+1) ,alpha_Utility);
                           ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+N*( alpha_Utility - a_node )*percent*Payoff;
                           if Payoff==0 && alpha_Utility>a_node
                               ESO_value(a,alpha_Utility,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end                       
                       elseif n==0 && V_t>default_boundary_value(j) %�w�������I����U�����H�����e
                           %�bt+delta���I�U���̾A�ഫ��vAlpha-----------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , 0 ,alpha_Utility);
                           ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+N*( alpha_Utility - a_node )*percent*Payoff;
                           if Payoff==0 && alpha_Utility>a_node
                               ESO_value(a,alpha_Utility,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end 
                       else %n<=0�N�N��}��
                           ESO_value(a,alpha_Utility,i_node,j)=0;
                       end
                   elseif j<step*T_exercise/T+1 || j==1
                       
                       if a_node==1 %�b�k�ݤ�e���O0%�A�o�O0%���x�}��m
                           %���u�̾A�i���᪺�겣����-----------------------------
                           if j>1
                               V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t;
                           else
                               V_t=V;
                           end
                           %���u�̾A�i���᪺�겣���ȦbBTT���I��B�`�I--------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           BTT_B_node=max(max_time_node)-n;
                           if j==1
                               i_node=BTT_B_node;
                           end
                           %BTT�p����v-----------------------------------------
                           if n>0 
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               if j==step*T_exercise/T||T_exercise==0
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node+1,j+1) ,alpha_Utility);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                           elseif n==0 && V_t>default_boundary_value(j)%�w�������I����U�����H�����e
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               if j==step*T_exercise/T||T_exercise==0
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , 0 ,alpha_Utility);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                           else %n<=0�N�N��}��
                               ESO_value(a,alpha_Utility,i_node,j)=0;
                           end 
                       end
                       
                   end
               else
                   ESO_value(a,a_node,i_node,j)=0;
               end
           end
       end
    end
    
    
%     ESO=ESO_value(Percentage,1,i_node,1);
%     Stock=Stock_value(Percentage,1,i_node,1);
%     Equity=Equity_value(Percentage,1,i_node,1);
%     Debt=Debt_value(Percentage,1,i_node,1);
%     Utility=Utility_value(Percentage,1,i_node,1);
    
    Equity=Equity_value(Percentage,1,BTT_B_node,1);
    Debt=Debt_value(Percentage,1,BTT_B_node,1);
    Utility=Utility_value(Percentage,1,BTT_B_node,1);
    ESO=ESO_value(Percentage,1,BTT_B_node,1);
    Stock=Stock_value(Percentage,1,BTT_B_node,1);
    Dividend=Dividend_value(Percentage,1,BTT_B_node,1);
    TB=TB_value(Percentage,1,BTT_B_node,1);
    BC=BC_value(Percentage,1,BTT_B_node,1);
    Salary=Salary_value(Percentage,1,BTT_B_node,1);
    
    
elseif method==2
    %method2�̨Τ�ESO����---------------------------------------------------------
    for j=step+1:-1:2%���q�겣���Ȧbt���I
       for a=1:Percentage%�ثe�Ҧb���겣��O�Hū�^�h�֦ʤ���A a=1 �� 100% ; a=Percentag �� 0%
           %�w�����uū�^a%���ƭ��ഫ
           a_node=Percentage-a+1;
           for i=1:Nodes(a,j)%���P�h��Үi�X�h���W�ɬҤ��P�A i=1 ���}�����
               %�bj���I�ɪ��겣���Ȱ��סAi=1 ���}����ɡA���W��
               i_node=max(max_time_node)+1-i;
               for b=a_node:Percentage
                   %�w�����u�U�@��ū�^a%���ƭ��ഫ=�o�@����b%
                   next_time_a=Percentage-b+1;
                   %�P�_�O�_�}��
                   if abs( firm_tree_value(i_node,j) - default_boundary_value(j) ) > 10^-10
                       if j==step+1%�̫�@��
                           %�ѪF����--------------------------------------------
                           Equity_value(a,b,i_node,j)=max((firm_tree_value(i_node,j)-F*(1+(1-tax_firm)*c*t)-O*Div*t-(1-tax_firm)*wage*t+(1-tax_firm)*( b - a_node )*X*N*percent)/(1-tax_firm*(( b - a_node )*N*percent/(O+(b-1)*N*percent))),0);
                           %�C�ѻ���--------------------------------------------
                           %���u�{���v���`���Ȥ��ܮɡA���B�V�C�A�ѼƶV���A�|�}���ѻ��A�ɭP�����i��
                           Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                           %�Ũ����--------------------------------------------
                           Debt_value(a,b,i_node,j)=F*(1+c*t);
                           Dividend_value(a,b,i_node,j)=O*Div*t;
                           
                           TB_value(a,b,i_node,j)=F*tax_firm*c*t+tax_firm*wage*t;
                           BC_value(a,b,i_node,j)=0;
                           Salary_value(a,b,i_node,j)=wage*t;
                           %ESO����---------------------------------------------
                           Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                           ESO_value(a,b,i_node,j)=N*( b - a_node )*percent*Payoff;
                           if Payoff==0 && b>a_node %���i�i���A�����ۨS���i������
                               Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                               Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                               Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                               Dividend_value(a,b,i_node,j)=Dividend_value(a,a_node,i_node,j);
                           end    
                           if Payoff>0 %�i��ESO�|���͵|�ޮĪG
                              TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+tax_firm*( Stock_value(a,b,i_node,j)-X)*( b - a_node )*N*percent;
                           end
                       elseif j>=step*T_exercise/T+1%���u�i�H�i��
                           %���u�i���᪺�겣����--------------------------------
                           V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t+( b - a_node )*X*N*percent;
                           %BTT�p����v-----------------------------------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %���u�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                           BTT_B_node=max(max_time_node)-n; 
                           if n>0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               if Stock_value(a,b,i_node,j)>X  %�NESO�|�ޮĪG���N �D�X�z�Q�ƪ��ѻ�
                                   S=zeros(2,1);
                                   S(2,1)=Stock_value(a,b,i_node,j);
                                   while S(2,1)-S(1,1)>0.0001 %���L�]�즬�K
                                       Injection_TS=tax_firm*(S(2,1)-X)*( b - a_node )*N*percent;
                                       V1=V_t+Injection_TS;
                                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V1,default_boundary_value(j+1));
    %                                    P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                                       %���u�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                                       BTT_B_node=max(max_time_node)-n; 
                                       S(1,1)=S(2,1);
                                       if BTT_B_node==1
                                           BTT_B_node=2;
                                       end
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) ,ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                       %�C�ѻ���----------------------------------------
                                       S(2,1)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   end
                                   Stock_value(a,b,i_node,j)=S(2,1);
                               end
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                               Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , Dividend_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+O*Div*t;

                               %ESO����-----------------------------------------
                               TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , TB_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                               BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , BC_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , Salary_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+wage*t;
                               %ESO����-----------------------------------------
                               Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                               ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+N*( b - a_node )*percent*Payoff;
                               if Payoff==0 && b>a_node
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   Utility_value(a,b,i_node,j)=Utility_value(a,a_node,i_node,j);
                                   ESO_value(a,b,i_node,j)=ESO_value(a,a_node,i_node,j);
                               end
                               if Payoff>0 %�i��ESO�|���͵|�ޮĪG
                                   TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+tax_firm*( Stock_value(a,b,i_node,j)-X)*( b - a_node )*N*percent;
                               end
                           elseif n==0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , (1-w)*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t)+F*c*t;
                               Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+O*Div*t;

                               %ESO����-----------------------------------------
                               TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                               BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , w*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)),r,t);
                               Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+wage*t;
                               %ESO����-----------------------------------------
                               Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                               ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+N*( b - a_node )*percent*Payoff;
                               if Payoff==0 && b>a_node
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   ESO_value(a,b,i_node,j)=ESO_value(a,a_node,i_node,j);
                               end
                           else %n<=0�N�N��}��
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                               Dividend_value(a,b,i_node,j)=0;
                               %ESO����-----------------------------------------
                               TB_value(a,b,i_node,j)=0;
                               BC_value(a,b,i_node,j)=w*firm_tree_value(i_node,j);
                               Salary_value(a,b,i_node,j)=0;
                               %ESO����-----------------------------------------
                               %�p����u�ĥΨ�ƺ�
                               ESO_value(a,b,i_node,j)=0;
                           end
                       elseif j<step*T_exercise/T+1%���u���i�H�i��
                           if b==1 %�b�k�ݤ�e���O0%�A�o�O0%���x�}��m
                               %���u�i���᪺�겣����-----------------------------
%                                if j>1
                                   V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t;
%                                else
%                                    V_t=V;
%                                end
%                                V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t;
                               %BTT�p����v-------------------------------------
                               [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                               %���u�i���᪺�겣���ȦbBTT���I��B�`�I-------------
                               BTT_B_node=max(max_time_node)-n;
                               if n>0
                                   %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                                   if j==step*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node+1,j+1) ,r,t);
                                   TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , TB_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , BC_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , Salary_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);

                                   if j>1
                                       Debt_value(a,b,i_node,j)=Debt_value(a,b,i_node,j)+F*c*t;
                                       Dividend_value(a,b,i_node,j)=Dividend_value(a,b,i_node,j)+O*Div*t;
                                       TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+F*tax_firm*c*t+tax_firm*wage*t;
                                       Salary_value(a,b,i_node,j)=Salary_value(a,b,i_node,j)+wage*t;
                                   end
                                   %ESO����-------------------------------------
                                   ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               elseif n==0
                                   %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                                   if j==step*T_exercise/T
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , (1-w)*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t)+F*c*t;
                                   Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+O*Div*t;

                                   %ESO����------------------------------------
                                   TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                                   BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , w*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t);
                                   Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+wage*t;

                                   %ESO����------------------------------------
                                    ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               else %n<=0�N�N��}��
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=0;
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=0;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                                   Dividend_value(a,b,i_node,j)=0;

                                   %ESO����------------------------------------
                                   TB_value(a,b,i_node,j)=0;
                                   BC_value(a,b,i_node,j)=w*firm_tree_value(i_node,j);
                                   Salary_value(a,b,i_node,j)=0;
                                   %ESO����------------------------------------
                                   ESO_value(a,b,i_node,j)=0;
                               end
                           end
                       end
                   else
                       %�C�ѻ���------------------------------------------------
                       Stock_value(a,b,i_node,j)=0;
                       %�ѪF����------------------------------------------------
                       Equity_value(a,b,i_node,j)=0;
                       %�Ũ����------------------------------------------------
                       Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                       Dividend_value(a,b,i_node,j)=0;
                       %ESO����-------------------------------------------------
                       TB_value(a,b,i_node,j)=0;
                       BC_value(a,b,i_node,j)=w*firm_tree_value(i_node,j);
                       Salary_value(a,b,i_node,j)=0;
                       %ESO����-------------------------------------------------
                       ESO_value(a,b,i_node,j)=0;
                   end
               end           
               %��X���u�ĥγ̤j�Ʈ���ū�^�ܦh��b%
               alpha_Utility=min(find(ESO_value(a,a_node:Percentage,i_node,j)==max(ESO_value(a,a_node:Percentage,i_node,j))))+a_node-1;
               alpha(a,alpha_Utility,i_node,j)=(alpha_Utility-1)*percent;          
           end
       end
    end
    
    
    %���u�i���᪺�겣����-----------------------------
    [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V,default_boundary_value(2));
    BTT_B_node=max(max_time_node)-n;
    P=[P;max(max_time_node),1,BTT_B_node,1,n,V,default_boundary_value(2),Pu,Pm,Pd,Pu+Pm+Pd];
    %�bt t���I�U���̾A�ഫ��vAlpha---------
    if T_exercise==0
        [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(Percentage,1:Percentage,BTT_B_node-1,2) , ESO_value(Percentage,1:Percentage,BTT_B_node,2) , ESO_value(Percentage,1:Percentage,BTT_B_node+1,2) ,1);
    else
        alpha_u=1;alpha_m=1;alpha_d=1;
    end
    %�C�ѻ���------------------------------------
    Stock_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Stock_value(Percentage,alpha_u,BTT_B_node-1,2) , Stock_value(Percentage,alpha_m,BTT_B_node,2) , Stock_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    %�ѪF����------------------------------------
    Equity_value(Percentage,1,BTT_B_node,1)=Stock_value(Percentage,1,BTT_B_node,1)*O;
%     Equity_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Equity_value(Percentage,alpha_u,BTT_B_node-1,2) , Equity_value(Percentage,alpha_m,BTT_B_node,2) , Equity_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    %�Ũ����------------------------------------
    Debt_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Debt_value(Percentage,alpha_u,BTT_B_node-1,2) , Debt_value(Percentage,alpha_m,BTT_B_node,2) , Debt_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    Dividend_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Dividend_value(Percentage,alpha_u,BTT_B_node-1,2) , Dividend_value(Percentage,alpha_m,BTT_B_node,2), Dividend_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);

   %ESO����------------------------------------
   TB_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, TB_value(Percentage,alpha_u,BTT_B_node-1,2) , TB_value(Percentage,alpha_m,BTT_B_node,2) , TB_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
   BC_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, BC_value(Percentage,alpha_u,BTT_B_node-1,2) , BC_value(Percentage,alpha_m,BTT_B_node,2) , BC_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
   Salary_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Salary_value(Percentage,alpha_u,BTT_B_node-1,2) , Salary_value(Percentage,alpha_m,BTT_B_node,2) , Salary_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);

    
    
    %ESO����-------------------------------------
    ESO_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, ESO_value(Percentage,alpha_u,BTT_B_node-1,2) , ESO_value(Percentage,alpha_m,BTT_B_node,2) , ESO_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    
    Equity=Equity_value(Percentage,1,BTT_B_node,1);
    Debt=Debt_value(Percentage,1,BTT_B_node,1);
    Utility=Utility_value(Percentage,1,BTT_B_node,1);
    ESO=ESO_value(Percentage,1,BTT_B_node,1);
    Stock=Stock_value(Percentage,1,BTT_B_node,1);
    Dividend=Dividend_value(Percentage,1,BTT_B_node,1);
    TB=TB_value(Percentage,1,BTT_B_node,1);
    BC=BC_value(Percentage,1,BTT_B_node,1);
    Salary=Salary_value(Percentage,1,BTT_B_node,1);

end




end

