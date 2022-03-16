

%�N���q�ŶŮ�c�P�}���������Bcc���
%�ѼƳ]�w
%���խק�inj�a�Ӫ����I���D
clc;clear;
F=200;          %���q���`���B
c=0.09;         %���q�Ų����Q�v
Bcc=0;          %�}�����
X=3.22730467045146;            %ESO�i����
N=25;           %ESO�i��
O=50;           %�b�~�y�q�Ѽ�
wage=0;         %�������`�~��
tax_firm=0.35;     %���q�|�v
w=0.5;            %�}������
V=250;          %�겣��l����
sigma=0.22;     %�겣�i�ʫ�(�C)
T=10;           %�����
step_n=10;     %�`����
r=0.06;         %�L���I�Q�v
T_exercise=1;   %�i�i���϶��]�̪�i�i���ɶ��^
percent=0.25;    %�̤p�i���϶� 0.2=20%
tax_employee=0; %���u�ӤH�ұo�|
Beta=0;         %�ĥΧ�{�]�l
gamma=1;        %gamma=�ĥΨ�ƪ������(���u���I���׫Y��)
type_default=1; %�}�����type:1��{���B2�T�w���]�������^�B0������|�}��
fix_DB=90;
type_tax_employee=0; %�ӤH�|�����G0�T�w���B1�ֶi���]�������^
method=1;%method1�̨Τƭ��u�ĥΡBmethod2�̨Τ�ESO����
mu=0.06;           %�겣�W������

%sigma=���q�겣���ȼзǮt(%)
%step_n=����            %V=���q�겣����        %wage=���u�~��(�~)
%X=���u�{���v�ҭ��B    %N=���u�{���v�Ҽƶq    %T_exercise=���u�i�i����
%F=�Ũ魱�B           %c=�Ũ�Ů��v          %T=�Ũ�����
%r=�L���I�Q�v         %w=�}������            %gamma=�ĥΨ�ƪ������             
%tax_firm=���q�|�v    %tax_employee=���u�ұo�|
%Equity_value=�ѪF����

%x=���w�Ӵ��w�`��x%�����u�{���v
%y=�Ӵ����`���y%�����u�{���v
%Alpha=���@��y=a%�A���j�ƭ��u���ĥ�
%percent=���ʤ���(%)

%�ɶ����{��---------------------------------------------------------------
t=T/step_n; 
%�ʤ���ƦC����-------------------------------------------------------------
Percentage=1/percent+1;
%�p��}�����---------------------------------------------------------------
default_boundary_value=Default_boundary(type_default,step_n,T,F,tax_firm,Bcc,r,fix_DB);
%�겣��W�ɪ�l��-----------------------------------------------------------
firm_value_p=V;
Up_boundary_value_p=[];Nodes_p=[];
for pi=Percentage:-1:1
    [up_boundary_value,nodes]=Up_boundary(step_n,r,sigma,T,T_exercise,firm_value_p,default_boundary_value,X,N,percent);
    Up_boundary_value_p=[up_boundary_value;Up_boundary_value_p];
%     Nodes=[nodes;Nodes];
    Nodes_p(pi,:)=nodes;
    firm_value_p=Up_boundary_value_p;
end
%�겣��100%�i���W�ɪ�l��---------------------------------------------------
firm_value_100=V;
Up_boundary_value_100=[];Nodes_100=[];
for pi=Percentage:-1:1
    [up_boundary_value_100,nodes_100]=Up_boundary_100(step_n,mu,sigma,T,T_exercise,firm_value_100,default_boundary_value,X,N);
    Up_boundary_value_100=[up_boundary_value_100;Up_boundary_value_100];
    Nodes_100(pi,:)=nodes_100;
    firm_value_100=Up_boundary_value_100;
end

%�إ߸겣�����-------------------------------------------------------------
[firm_tree_value_100,max_time_node_100]=Firm_tree_value(V,sigma,step_n,t,default_boundary_value,Nodes_100);

%�إ߭ӻ��Ⱦ�---------------------------------------------------------------
Equity_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
Stock_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
Debt_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
ESO_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
Utility_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
alpha=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
%���إ̤߳j��P,Q�x�}
[size1,size2] = size(firm_tree_value_100);
PQsize = (size1-1)*(size2-1)*Percentage*Percentage*(size2+1);
P = zeros(PQsize,11);
currentPindex = 0;
Q = zeros(PQsize,11);
currentQindex = 0;
%G = zeros(PQsize,7);
%currentGindex = 0;
L = zeros(PQsize,6);
currentLindex = 0;

Nodes_p(1,1)=0;

if method==1
    %method1�̨Τƭ��u�ĥ�-------------------------------------------------
    for j=step_n+1:-1:1%���q�겣���Ȧbt���I
       for a=1:Percentage%�ثe�Ҧb���겣��O�Hū�^�h�֦ʤ���A a=1 �� 100% ; a=Percentag �� 0%
           %�w�����uū�^a%���ƭ��ഫ
           a_node=Percentage-a+1;
           for pi=1:Nodes_p(a,j)%���P�h��Үi�X�h���W�ɬҤ��P�A i=1 ���}�����
               %�bj���I�ɪ��겣���Ȱ��סAi=1 ���}����ɡA���W��
               i_node=max(max_time_node_100)+1-pi;
               for b=a_node:Percentage
                   %�w�����u�U�@��ū�^a%���ƭ��ഫ=�o�@����b%
                   next_time_a=Percentage-b+1;
                   %�P�_�O�_�}��
                   if abs( firm_tree_value_100(i_node,j) - default_boundary_value(j) ) > 10^-10
                       if j==step_n+1%�̫�@��
                           %�ѪF����--------------------------------------------
                           Equity_value(a,b,i_node,j)=max(firm_tree_value_100(i_node,j)-F*(1+(1-tax_firm)*c*t)+( b - a_node )*X*N*percent,0);
                           %�C�ѻ���--------------------------------------------
                           %���u�{���v���`���Ȥ��ܮɡA���B�V�C�A�ѼƶV���A�|�}���ѻ��A�ɭP�����i��
                           Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                           %�Ũ����--------------------------------------------
                           Debt_value(a,b,i_node,j)=F*(1+c*t);
                           %ESO����---------------------------------------------
                           %�p����u�]�I(�w���|)
                           [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,Stock_value(a,b,i_node,j),X,a_node,b,N,percent);
                           %�P�_���u���̾A�ĥάO�_�|�i��ESO
                           Utility_value(a,b,i_node,j)=Wealth^gamma;
                           if excercise~=true && b>a_node
                               Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                               Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                               Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                           end
                       elseif j>=step_n*T_exercise/T+1&&j~=1%���u�i�H�i��
                           %���u�i���᪺�겣����--------------------------------
                           V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t+( b - a_node )*X*N*percent;
                           %BTT�p����v-----------------------------------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           currentPindex = currentPindex + 1;
                           P(currentPindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %���u�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                           BTT_B_node=max(max_time_node_100)-n; 
                           if n>0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                               %ESO����-----------------------------------------
                               %�p����u�]�I(�w���|)
                               [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,Stock_value(a,b,i_node,j),X,a_node,b,N,percent);
                               %�P�_���u���̾A�ĥάO�_�|�i��ESO
                               [Qu,Qm,Qd,Qn]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                               currentQindex = currentQindex + 1;
                               Q(currentQindex,:)=[i_node,j,a_node,b,Qn,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                               Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,Beta,t);
                               if excercise~=true && b>a_node
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   Utility_value(a,b,i_node,j)=Utility_value(a,a_node,i_node,j);
                               end
                           elseif n==0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , exp(log(default_boundary_value(j+1)-2*sigma*t)) ,r,t)+F*c*t;
                               %ESO����-----------------------------------------
                               %�p����u�]�I(�w���|)
                               [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,Stock_value(a,b,i_node,j),X,a_node,b,N,percent);
                               %�P�_���u���̾A�ĥάO�_�|�i��ESO
                               [Qu,Qm,Qd,Qn]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                               currentQindex = currentQindex + 1;
                               Q(currentQindex,:)=[i_node,j,a_node,b,Qn,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                               Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,Beta,t);
                               if excercise~=true && b>a_node
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   Utility_value(a,b,i_node,j)=Utility_value(a,a_node,i_node,j);
                               end
                           elseif n<0
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                               %ESO����-----------------------------------------
                               %�p����u�ĥΨ�ƺ�
                               Utility_value(a,b,i_node,j)=0;
                           end
                       elseif j<step_n*T_exercise/T+1||j==1%���u���i�H�i��
                           if b==1 %�b�k�ݤ�e���O0%�A�o�O0%���x�}��m
                               %���u�i���᪺�겣����-----------------------------
                               if j>1
                                   V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t;
                               else
                                   V_t=V;
                               end
                               %BTT�p����v-------------------------------------
                               [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                               %���u�i���᪺�겣���ȦbBTT���I��B�`�I-------------
                               BTT_B_node=max(max_time_node_100)-n;
                               if j==1
                                   i_node=BTT_B_node;
                               end
                               currentPindex = currentPindex + 1;
                               P(currentPindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                               if n>0
                                   %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                                   if j==step_n*T_exercise/T||T_exercise==0
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
                                   if j>1
                                       Debt_value(a,b,i_node,j)=Debt_value(a,b,i_node,j)+F*c*t;
                                   end
                                   %ESO����-------------------------------------
                                   %�p����u�~�~(�w���|)
                                   Wealth=Tax_employee(type_tax_employee,tax_employee,t,wage,X,X,a_node,b,N,percent);
                                   %�p����u�ĥΨ�ƺ�
                                   [Qu,Qm,Qd,Qn]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                                   currentQindex = currentQindex + 1;
                                   Q(currentQindex,:)=[i_node,j,a_node,b,Qn,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                                   Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,Beta,t);
                               elseif n==0
                                   %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                                   if j==step_n*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , exp(log(default_boundary_value(j+1)-2*sigma*t)) ,r,t)+F*c*t;
                                   %ESO����------------------------------------
                                   %�p����u�~�~(�w���|)
                                   Wealth=Tax_employee(type_tax_employee,tax_employee,t,wage,X,X,a_node,b,N,percent);
                                   %�p����u�ĥΨ�ƺ�
                                   [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                                   currentQindex = currentQindex + 1;
                                   Q(currentQindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                                   Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,Beta,t);
                               elseif n<0
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=0;
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=0;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                                   %ESO����------------------------------------
                                   %�p����u�ĥΨ�ƺ�
                                   Utility_value(a,b,i_node,j)=0;
                               end
                           end
                       %currentGindex = currentGindex + 1;
                       %G(currentGindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1)];
                       end
                   else
                       %�C�ѻ���------------------------------------------------
                       Stock_value(a,b,i_node,j)=0;
                       %�ѪF����------------------------------------------------
                       Equity_value(a,b,i_node,j)=0;
                       %�Ũ����------------------------------------------------
                       Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                       %ESO����-------------------------------------------------
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
               if abs( firm_tree_value_100(i_node,j) - default_boundary_value(j) ) >10^-10 || j==1
                   if j==step_n+1
                       ESO_value(a,alpha_Utility,i_node,j)=N*( alpha_Utility - a_node )*percent*Payoff;
                   elseif j>=step_n*T_exercise/T+1&&j~=1
                       %���u�̾A�i���᪺�겣����---------------------------------
                       V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t+( alpha_Utility - a_node )*X*N*percent;
                       %���u�̾A�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                       BTT_B_node=max(max_time_node_100)-n;
                       if n>0
                           %�bt+delta���I�U���̾A�ഫ��vAlpha-----------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node+1,j+1) ,alpha_Utility);
                           ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+N*( alpha_Utility - a_node )*percent*Payoff;
                           if Payoff==0 && alpha_Utility>a_node
                               ESO_value(a,alpha_Utility,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end                       
                       elseif n==0
                           %�bt+delta���I�U���̾A�ഫ��vAlpha-----------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , 0 ,alpha_Utility);
                           ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+N*( alpha_Utility - a_node )*percent*Payoff;
                           if Payoff==0 && alpha_Utility>a_node
                               ESO_value(a,alpha_Utility,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end 
                       elseif n<0
                           ESO_value(a,alpha_Utility,i_node,j)=0;
                       end
                   elseif j<step_n*T_exercise/T+1 || j==1
                       
                       if a_node==1 %�b�k�ݤ�e���O0%�A�o�O0%���x�}��m
                           %���u�̾A�i���᪺�겣����-----------------------------
                           if j>1
                               V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t;
                           else
                               V_t=V;
                           end
                           %���u�̾A�i���᪺�겣���ȦbBTT���I��B�`�I--------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           BTT_B_node=max(max_time_node_100)-n;
                           if j==1
                               i_node=BTT_B_node;
                           end
                           %BTT�p����v-----------------------------------------
                           if n>0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               if j==step_n*T_exercise/T||T_exercise==0
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node+1,j+1) ,alpha_Utility);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                           elseif n==0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               if j==step_n*T_exercise/T||T_exercise==0
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , 0 ,alpha_Utility);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                           elseif n<0
                               ESO_value(a,alpha_Utility,i_node,j)=0;
                           end 
                       end
                       
                   end
               else
                   ESO_value(a,a_node,i_node,j)=0;
               end
               
               currentLindex = currentLindex + 1;
               L(currentLindex,:)=[i_node,j,a_node,alpha_Utility,firm_tree_value_100(i_node,j),default_boundary_value(j)];
               
           end
       end
    end
  
    Equity=Equity_value(Percentage,1,BTT_B_node,1);
    Debt=Debt_value(Percentage,1,BTT_B_node,1);
    Utility=Utility_value(Percentage,1,BTT_B_node,1);
    ESO=ESO_value(Percentage,1,BTT_B_node,1);
    Stock=Stock_value(Percentage,1,BTT_B_node,1);
    

elseif method==2
    %method2�̨Τ�ESO����---------------------------------------------------------
    for j=step_n+1:-1:2%���q�겣���Ȧbt���I
       for a=1:Percentage%�ثe�Ҧb���겣��O�Hū�^�h�֦ʤ���A a=1 �� 100% ; a=Percentag �� 0%
           %�w�����uū�^a%���ƭ��ഫ
           a_node=Percentage-a+1;
           for pi=1:Nodes_p(a,j)%���P�h��Үi�X�h���W�ɬҤ��P�A i=1 ���}�����
               %�bj���I�ɪ��겣���Ȱ��סAi=1 ���}����ɡA���W��
               i_node=max(max_time_node_100)+1-pi;
               for b=a_node:Percentage
                   %�w�����u�U�@��ū�^a%���ƭ��ഫ=�o�@����b%
                   next_time_a=Percentage-b+1;
                   %�P�_�O�_�}��
                   if abs( firm_tree_value_100(i_node,j) - default_boundary_value(j) ) > 10^-10
                       if j==step_n+1%�̫�@��
                           %�ѪF����--------------------------------------------
                           Equity_value(a,b,i_node,j)=max(firm_tree_value_100(i_node,j)-F*(1+(1-tax_firm)*c*t)+( b - a_node )*X*N*percent,0);
                           %�C�ѻ���--------------------------------------------
                           %���u�{���v���`���Ȥ��ܮɡA���B�V�C�A�ѼƶV���A�|�}���ѻ��A�ɭP�����i��
                           Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                           %�Ũ����--------------------------------------------
                           Debt_value(a,b,i_node,j)=F*(1+c*t);
                           %ESO����---------------------------------------------
                           Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                           ESO_value(a,b,i_node,j)=N*( b - a_node )*percent*Payoff;
                       elseif j>=step_n*T_exercise/T+1%���u�i�H�i��
                           %���u�i���᪺�겣����--------------------------------
                           V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t+( b - a_node )*X*N*percent;
                           %BTT�p����v-----------------------------------------
                           currentPindex = currentPindex + 1;
                           P(currentPindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %���u�i���᪺�겣���ȦbBTT���I��B�`�I------------------
                           BTT_B_node=max(max_time_node_100)-n; 
                           if n>0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
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
                           elseif n==0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , exp(log(default_boundary_value(j+1)-2*sigma*t)) ,r,t)+F*c*t;
                               %ESO����-----------------------------------------
                               Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                               ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+N*( b - a_node )*percent*Payoff;
                               if Payoff==0 && b>a_node
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   ESO_value(a,b,i_node,j)=ESO_value(a,a_node,i_node,j);
                               end
                           elseif n<0
                               %�C�ѻ���----------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %�ѪF����----------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %�Ũ����----------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                               %ESO����-----------------------------------------
                               %�p����u�ĥΨ�ƺ�
                               ESO_value(a,b,i_node,j)=0;
                           end
                       elseif j<step_n*T_exercise/T+1%���u���i�H�i��
                           if b==1 %�b�k�ݤ�e���O0%�A�o�O0%���x�}��m
                               %���u�i���᪺�겣����-----------------------------
                               V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t;
                               %BTT�p����v-------------------------------------
                               [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                               currentPindex = currentPindex + 1;
                               P(currentPindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                               %���u�i���᪺�겣���ȦbBTT���I��B�`�I-------------
                               BTT_B_node=max(max_time_node_100)-n;
                               if n>0
                                   %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                                   if j==step_n*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                                   %ESO����-------------------------------------
                                   ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               elseif n==0
                                   %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                                   if j==step_n*T_exercise/T
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , exp(log(default_boundary_value(j+1)-2*sigma*t)) ,r,t)+F*c*t;
                                   %ESO����------------------------------------
                                    ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               elseif n<0
                                   %�C�ѻ���------------------------------------
                                   Stock_value(a,b,i_node,j)=0;
                                   %�ѪF����------------------------------------
                                   Equity_value(a,b,i_node,j)=0;
                                   %�Ũ����------------------------------------
                                   Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                                   %ESO����------------------------------------
                                   ESO_value(a,b,i_node,j)=0;
                               end
                           end
                        %currentGindex = currentGindex + 1;
                        %G(currentGindex,:)=[i_node,j,a_node,b,V_t,default_boundary_value(j+1)];
                       end
                   else
                       %�C�ѻ���------------------------------------------------
                       Stock_value(a,b,i_node,j)=0;
                       %�ѪF����------------------------------------------------
                       Equity_value(a,b,i_node,j)=0;
                       %�Ũ����------------------------------------------------
                       Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                       %ESO����-------------------------------------------------
                       ESO_value(a,b,i_node,j)=0;
                   end

               end           
               %��X���u�ĥγ̤j�Ʈ���ū�^�ܦh��b%
               alpha_Utility=min(find(ESO_value(a,a_node:Percentage,i_node,j)==max(ESO_value(a,a_node:Percentage,i_node,j))))+a_node-1;
               alpha(a,alpha_Utility,i_node,j)=(alpha_Utility-1)*percent;
               
               currentLindex = currentLindex + 1;
               L(currentLindex,:)=[i_node,j,a_node,alpha_Utility,firm_tree_value_100(i_node,j),default_boundary_value(j)];
           end
       end
    end


    %���u�i���᪺�겣����-----------------------------
    [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V,default_boundary_value(2));
    BTT_B_node=max(max_time_node_100)-n;
    currentPindex = currentPindex + 1;
    P(currentPindex,:)=[max(max_time_node_100),1,BTT_B_node,1,n,V,default_boundary_value(2),Pu,Pm,Pd,Pu+Pm+Pd];
    %�bt t���I�U���̾A�ഫ��vAlpha---------
    if T_exercise==0
        [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(Percentage,1:Percentage,BTT_B_node-1,2) , ESO_value(Percentage,1:Percentage,BTT_B_node,2) , ESO_value(Percentage,1:Percentage,BTT_B_node+1,2) ,1);
    else
        alpha_u=1;alpha_m=1;alpha_d=1;
    end
    %�C�ѻ���------------------------------------
    Stock_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Stock_value(Percentage,alpha_u,BTT_B_node-1,2) , Stock_value(Percentage,alpha_m,BTT_B_node,2) , Stock_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    %�ѪF����------------------------------------
    % Equity_value(Percentage,1,BTT_B_node,1)=Stock_value(Percentage,1,BTT_B_node,1)*O;
    Equity_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Equity_value(Percentage,alpha_u,BTT_B_node-1,2) , Equity_value(Percentage,alpha_m,BTT_B_node,2) , Equity_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    %�Ũ����------------------------------------
    Debt_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Debt_value(Percentage,alpha_u,BTT_B_node-1,2) , Debt_value(Percentage,alpha_m,BTT_B_node,2) , Debt_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    %ESO����-------------------------------------
    ESO_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, ESO_value(Percentage,alpha_u,BTT_B_node-1,2) , ESO_value(Percentage,alpha_m,BTT_B_node,2) , ESO_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    Equity=Equity_value(Percentage,1,BTT_B_node,1);
    Debt=Debt_value(Percentage,1,BTT_B_node,1);
    Utility=Utility_value(Percentage,1,BTT_B_node,1);
    ESO=ESO_value(Percentage,1,BTT_B_node,1);
    Stock=Stock_value(Percentage,1,BTT_B_node,1);

end

%�B�zPQ�A��Τ��쪺�ȥh��
finalPindex = find(P(:,1)==0,1);
P(finalPindex:end,:)=[];
finalQindex = find(Q(:,1)==0,1);
Q(finalQindex:end,:)=[];
finalLindex = find(L(:,1)==0,1);
L(finalLindex:end,:)=[];

%�p�⤣�Ҽ{���v�������i�����
aaa = (L(:,3)-1) ./ (Percentage-1); %�٭�a%
bbb = (L(:,4)-1) ./ (Percentage-1); %�٭�b%
%(b%-a%) �p��w�i�����
lll = (bbb-aaa) ./ (1-aaa) ; %  (b%-a%) / (1-a%)
lll(isnan(lll))=0; % a%=100%�ɤ�����0�A�|��NaN�����G�A�ɹs
lll(lll==0) = []; %��쥻�N�S���i����NaN���G���R��
L_Avg_Exercise = mean(lll);

function default_boundary_value=Default_boundary(type,step_n,T,F,tax_firm,Bcc,r,fix_DB)
%�}����ɭp��
    t=T/step_n;
    default_boundary_value=zeros(1,step_n+1);
    
    if type==0
        %�}����ɪ����s---------------------------------------------------
        default_boundary_value(2:end)=0.01;
    elseif type==1
        %�Ũ��{�}�����---------------------------------------------------
        default_boundary_value(step_n+1)=F*(1+(1-tax_firm)*Bcc*t);
        for i=step_n:-1:2
            %�p��C�Ӯ��I���}�����
            default_boundary_value(i)=default_boundary_value(i+1)*exp(-r*t)+(1-tax_firm)*F*Bcc*t;
        end
    elseif type==2
        %�}����ɳ]���T�w��------------------------------------------
        if nargin<8,error('Type2 at least 8 input arguments required'),end
        default_boundary_value(2:end)=fix_DB;
    end

end

function [up_boundary_value,nodes]=Up_boundary(step_n,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N,percent)
%�v�T�겣����D������ sigma,X,N,percent
%����u�M�wū�^������V�j�A�����i��ϱo�겣����D�ɤ��I�ܦh
%�e���O���D���T�ץ����j��2*sigma*sqrt(t)

%�W�ɭp��
    t=T/step_n;
    up_boundary_value=zeros(1,step_n+1);
    nodes=zeros(1,step_n+1);
    if sum(size(firm_value))==2
        %ESO���i�����̤U�h��------------------------------------------------
        up_boundary_value(1)=firm_value;
        nodes(1)=1;
        for i=2:step_n+1
            %n��B�I���`�I�M�}����ɪ��Z���O�X��
            n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
            %�̤W�ɪ��`�I(A�I)�ܯ}����ɪ��Z��
            up_boundary_value(i)=exp( log(default_boundary_value(i))+(n+1)*2*sigma*sqrt(t) );
            %�겣�W�ɨ�U�ɪ��`�I��
            nodes(i)=n+2;
        end
    else
        %ESO�w�i���L����L�h��----------------------------------------------
        for i=step_n*T_exercise/T+1:step_n+1
            %�^���Ӯɶ��I�겣���W��
            firm_jump=firm_value(:,i);
            %�p�⤣�P�h�겣�𩹤W���D�ɡA�|���쪺��m�����j��
            %firm_jump=firm_jump + (1:length(firm_jump))' *X*N*percent; 
            firm_jump=firm_jump + (1:length(firm_jump))' *X*N*percent; 
            firm_jump=max(firm_jump);
            %�p��겣���D���`�I���W��
            if default_boundary_value(i)==0
                n_jump=0;
            else
                n_jump=choosej(sigma,0,t,firm_jump,default_boundary_value(i));
                %n_jump=choosej(sigma,r,t,firm_jump,default_boundary_value(i));
            end
            if i==step_n*T_exercise/T+1
                %�k�ݤ�ȦҼ{�겣���D�`�I�����D------------------------------
                n=n_jump;
            else
                %���ȦҼ{�겣���D�٦�BTT�T������䱵�I-----------------------
                %n��B�I���`�I�M�}����ɪ��Z���O�X��
                n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
                %����겣����D���`�I�MA�I���`�I�֤j
                n=max(n+1,n_jump);                
            end  
            up_boundary_value(i)=exp( log(default_boundary_value(i))+n*2*sigma*sqrt(t) );
            nodes(i)=n+1;
        end
    end

end


function [up_boundary_value,nodes]=Up_boundary_100(step_n,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N)
%�v�T�겣����D������ sigma,X,N,percent
%����u�M�wū�^������V�j�A�����i��ϱo�겣����D�ɤ��I�ܦh
%�e���O���D���T�ץ����j��2*sigma*sqrt(t)

%�W�ɭp��
    t=T/step_n;
    up_boundary_value=zeros(1,step_n+1);
    nodes=zeros(1,step_n+1);
    if sum(size(firm_value))==2
        %ESO���i�����̤U�h��------------------------------------------------
        up_boundary_value(1)=firm_value;
        nodes(1)=1;
        for i=2:step_n+1
            %n��B�I���`�I�M�}����ɪ��Z���O�X��
            n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
            %�̤W�ɪ��`�I(A�I)�ܯ}����ɪ��Z��
            up_boundary_value(i)=exp( log(default_boundary_value(i))+(n+1)*2*sigma*sqrt(t) );
            %�겣�W�ɨ�U�ɪ��`�I��
            nodes(i)=n+2;
        end
    else
        %ESO�w�i���L����L�h��----------------------------------------------
        for i=step_n*T_exercise/T+1:step_n+1
            %�^���Ӯɶ��I�겣���W��
            firm_jump=firm_value(:,i);
            %�p�⤣�P�h�겣�𩹤W���D�ɡA�|���쪺��m�����j��
            %firm_jump=firm_jump + (1:length(firm_jump))' *X*N*percent; 
            firm_jump=firm_jump + (1:length(firm_jump))' *X*N; 
            firm_jump=max(firm_jump);
            %�p��겣���D���`�I���W��
            if default_boundary_value(i)==0
                n_jump=0;
            else
                n_jump=choosej(sigma,0,t,firm_jump,default_boundary_value(i));
                %n_jump=choosej(sigma,r,t,firm_jump,default_boundary_value(i));
            end
            if i==step_n*T_exercise/T+1
                %�k�ݤ�ȦҼ{�겣���D�`�I�����D------------------------------
                n=n_jump;
            else
                %���ȦҼ{�겣���D�٦�BTT�T������䱵�I-----------------------
                %n��B�I���`�I�M�}����ɪ��Z���O�X��
                n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
                %����겣����D���`�I�MA�I���`�I�֤j
                n=max(n+1,n_jump);                
            end  
            up_boundary_value(i)=exp( log(default_boundary_value(i))+n*2*sigma*sqrt(t) );
            nodes(i)=n+1;
        end
    end

end

function n=choosej(sigma,r,t,firm_value,default_value)
%��XB�I��m�A�p��겣���Ȭ۹��}����ɴX�Ө⭿sigma�ڸ�t
    firm_value=firm_value*exp(r*t);
    %n=round( log(firm_value/default_value) / (2*sigma*sqrt(t)) );
    
    %��}����ɳ]��0.01�ɡAfirm_value�i�ର�t�ȡAlog��|�����
    %n�i�H�p��0�A�B�z�@�U�t��log�᪺��ư��D
    if firm_value<0
        %��firm_value���t�ȮɡAn=-1�A�N����firm_value�}��
        n = -1;
    else
        n = round( log(firm_value/default_value) / (2*sigma*sqrt(t)) );
    end
    
end

function [firm_tree_value,max_time_node]=Firm_tree_value(V,sigma,step_n,t,default_boundary_value,Nodes)
%�إ߸겣�����
    %�겣��C�Ӯ��I���̤j�`�I
    max_time_node=max(Nodes);
    %�p����I�����̤j�`�I
    max_node=max(max_time_node);
    
    default_boundary_value=log(default_boundary_value);
    firm_tree_value=zeros(max_node,step_n+1);
    firm_tree_value(max_node,1)=V;
    for i=2:step_n+1
        firm_value=exp( default_boundary_value(i)+ ( 0:(max_time_node(i)-1) )*2*sigma*sqrt(t) );
        firm_tree_value(max_node-max_time_node(i)+1:max_node,i)=sort(firm_value,'descend')';
    end
end

function [Wealth,excercise]=Tax_employee(type,tax_employee,t,wage,S,X,a_node,b,N,percent)
%�p����u�~���J(�H���|)
    %Percentage=1/percent+1;
    %�p����u�i���᪺�����S
    Payoff=max(S-X,0);
    if Payoff>0
        excercise=true;
        Wealth=( wage*t + Payoff*( b - a_node )*N*percent );
    else
        excercise=false;
        Wealth=wage*t;    
    end
    if type==0
        %���u���ݭn�ҵ|�ε|�v���`��------------------------------------------
        Wealth=(1-tax_employee)*Wealth;
    elseif type==1
        %���u�ݨ̷ӵ|���ŶZ�ҵ|----------------------------------------------
    else
        %��L���p�A�ۦ�]�w ------------------------------------------------
    end
end

function [Pu,Pm,Pd,n]=BTT(sigma,r,mu,t,V_t,default_value)
    %�겣�`�I��--------------------------------
    n=choosej(sigma, r,t,V_t,default_value);
    u=exp(sigma*sqrt(t));
    Vm=default_value*u^(2*n);
    Vu=default_value*u^(2*(n+1));
    Vd=default_value*u^(2*(n-1));
    %������-----------------------------------
    V_rf=V_t*exp(mu*t);
    det_value =[ Vu-V_rf       , Vm-V_rf       , Vd-V_rf
                 (Vu-V_rf)^2   , (Vm-V_rf)^2   , (Vd-V_rf)^2  
                 1             , 1             , 1            ];
    det_right=[0;V_t^2*exp(2*mu*t)*(exp(sigma^2*t)-1);1];
    det_ans=zeros(1,3);
    for i=1:3
        det_left=det_value;
        det_left(:,i)=det_right;
        det_ans(i)=det(det_left)/det(det_value);
    end
    Pu=det_ans(1);
    Pm=det_ans(2);
    Pd=det_ans(3);
   
end

function [alpha_u,alpha_m,alpha_d]=optimal_alpha(value_u,value_m,value_d,next_time_a_node)
    alpha_u=min(find(value_u==max(value_u)))+next_time_a_node-1;
    alpha_m=min(find(value_m==max(value_m)))+next_time_a_node-1;
    alpha_d=min(find(value_d==max(value_d)))+next_time_a_node-1;
    
end

function Expected_Value=expected_value(Pu,Pm,Pd,A,B,C,discount_rate,t)
    Expected_Value=(Pu*A+Pm*B+Pd*C)*exp(-discount_rate*t);
end
