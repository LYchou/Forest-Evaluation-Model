clc
clear
V=2000;sigma=0.2;T=3;T_exercise=2;step=T*1;F=500;c=0.06;r=0.02;mu=0.08;
X=20;N=100;O=100;wage=3;gamma=0.5;tax_employee=0.05;Beta=0.125;
w=0;tax_firm=0;percent=1;
type_default=1;type_tax_employee=0;
%--------------------------------------------------------------------------

%�ɶ����{��---------------------------------------------------------------
t=T/step; 
%�ʤ���ƦC����-------------------------------------------------------------
Percentage=1/percent+1;
%�p��}�����---------------------------------------------------------------
default_boundary_value=Default_boundary(type_default,step,T,F,tax_firm,c,r);
%�겣��W�ɪ�l��-----------------------------------------------------------
firm_value=V;
Up_boundary_value=[];Nodes=[];
for i=Percentage:-1:1
    [up_boundary_value,nodes]=Up_boundary(step,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N,percent);
    Up_boundary_value=[up_boundary_value;Up_boundary_value];
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
P=[];Q=[];


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
                       Equity_value(a,b,i_node,j)=max(firm_tree_value(i_node,j)-F*(1+(1-tax_firm)*c*t)+( b - a_node )*X*N*percent,0);
                       %�C�ѻ���--------------------------------------------
                       %���u�{���v���`���Ȥ��ܮɡA���B�V�C�A�ѼƶV���A�|�}���ѻ��A�ɭP�����i��
                       Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                       %�Ũ����--------------------------------------------
                       Debt_value(a,b,i_node,j)=F*(1+c*t);
                       %ESO����---------------------------------------------
                       Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                       ESO_value(a,b,i_node,j)=N*( b - a_node )*percent*Payoff;
                   elseif j>=step*T_exercise/T+1%���u�i�H�i��
                       %���u�i���᪺�겣����--------------------------------
                       V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t+( b - a_node )*X*N*percent;
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
                           Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                           %ESO����-----------------------------------------
                           %�p����u�ĥΨ�ƺ�
                           ESO_value(a,b,i_node,j)=0;
                       end
                   elseif j<step*T_exercise/T+1%���u���i�H�i��
                       if b==1 %�b�k�ݤ�e���O0%�A�o�O0%���x�}��m
                           %���u�i���᪺�겣����-----------------------------
                           V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t;
                           %BTT�p����v-------------------------------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %���u�i���᪺�겣���ȦbBTT���I��B�`�I-------------
                           BTT_B_node=max(max_time_node)-n;
                           if n>0
                               %�bt+delta���I�U���̾A�ഫ��vAlpha-----------
                               if j==step*T_exercise/T
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
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , exp(log(default_boundary_value(j+1)-2*sigma*t)) ,r,t)+F*c*t;
                               %ESO����------------------------------------
                                ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                           elseif n<0
                               %�C�ѻ���------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %�ѪF����------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %�Ũ����------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
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
                   %ESO����-------------------------------------------------
                   ESO_value(a,b,i_node,j)=0;
               end
           end           
           %��X���u�ĥγ̤j�Ʈ���ū�^�ܦh��b%
           alpha_Utility=min(find(ESO_value(a,a_node:Percentage,i_node,j)==max(ESO_value(a,a_node:Percentage,i_node,j))))+a_node-1;
           Payoff=max(Stock_value(a,alpha_Utility,i_node,j)-X,0);
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

Equity
Debt
Stock
ESO
Utility
Asset=Equity+Debt+ESO

for i=1:size(Equity_value,3)
    for j=2:size(Equity_value,4)
        E(i,j)=Equity_value(2,1,i,j);
        D(i,j)=Debt_value(2,1,i,j);
        S(i,j)=Stock_value(2,1,i,j);
        eso(i,j)=ESO_value(2,1,i,j);
    end
end
E(max(max_time_node),1)=Equity_value(2,1,BTT_B_node,1);
D(max(max_time_node),1)=Debt_value(2,1,BTT_B_node,1);
S(max(max_time_node),1)=Stock_value(2,1,BTT_B_node,1);
eso(max(max_time_node),1)=ESO_value(2,1,BTT_B_node,1);

EE=Equity_value(:,:,:,step+1);
DD=Debt_value(:,:,:,step+1);
VV=zeros(Percentage,Percentage,max(max_time_node));
for i=1:max(max_time_node)
    VV(:,:,i)=firm_tree_value(i,step+1);
end

AAAAA=EE+DD-VV;
Asset-V