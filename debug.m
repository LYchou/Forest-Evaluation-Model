clc
clear
V=2000;sigma=0.2;T=3;T_exercise=2;step=T*1;F=500;c=0.06;r=0.02;mu=0.08;
X=20;N=100;O=100;wage=3;gamma=0.5;tax_employee=0.05;Beta=0.125;
w=0;tax_firm=0;percent=1;
type_default=1;type_tax_employee=0;
%--------------------------------------------------------------------------

%時間單位程度---------------------------------------------------------------
t=T/step; 
%百分比數列長度-------------------------------------------------------------
Percentage=1/percent+1;
%計算破產邊界---------------------------------------------------------------
default_boundary_value=Default_boundary(type_default,step,T,F,tax_firm,c,r);
%資產樹上界初始值-----------------------------------------------------------
firm_value=V;
Up_boundary_value=[];Nodes=[];
for i=Percentage:-1:1
    [up_boundary_value,nodes]=Up_boundary(step,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N,percent);
    Up_boundary_value=[up_boundary_value;Up_boundary_value];
%     Nodes=[nodes;Nodes];
    Nodes(i,:)=nodes;
    firm_value=Up_boundary_value;
end
%建立資產樹價值-------------------------------------------------------------
[firm_tree_value,max_time_node]=Firm_tree_value(V,sigma,step,t,default_boundary_value,Nodes);
%建立個價值樹---------------------------------------------------------------
Equity_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
Stock_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
Debt_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
ESO_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
Utility_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
alpha=zeros(Percentage,Percentage,max(max_time_node),step+1);
P=[];Q=[];


for j=step+1:-1:2%公司資產價值在t時點
   for a=1:Percentage%目前所在的資產樹是以贖回多少百分比， a=1 為 100% ; a=Percentag 為 0%
       %已知員工贖回a%的數值轉換
       a_node=Percentage-a+1;
       for i=1:Nodes(a,j)%不同層樹所展出去的上界皆不同， i=1 為破產邊界
           %在j時點時的資產價值高度，i=1 為破產邊界，往上建
           i_node=max(max_time_node)+1-i;
           for b=a_node:Percentage
               %已知員工下一期贖回a%的數值轉換=這一期的b%
               next_time_a=Percentage-b+1;
               %判斷是否破產
               if abs( firm_tree_value(i_node,j) - default_boundary_value(j) ) > 10^-10
                   if j==step+1%最後一期
                       %股東價值--------------------------------------------
                       Equity_value(a,b,i_node,j)=max(firm_tree_value(i_node,j)-F*(1+(1-tax_firm)*c*t)+( b - a_node )*X*N*percent,0);
                       %每股價格--------------------------------------------
                       %員工認股權證總價值不變時，面額越低，股數越高，會稀釋股價，導致不易履約
                       Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                       %債券價值--------------------------------------------
                       Debt_value(a,b,i_node,j)=F*(1+c*t);
                       %ESO價值---------------------------------------------
                       Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                       ESO_value(a,b,i_node,j)=N*( b - a_node )*percent*Payoff;
                   elseif j>=step*T_exercise/T+1%員工可以履約
                       %員工履約後的資產價值--------------------------------
                       V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t+( b - a_node )*X*N*percent;
                       %BTT計算機率-----------------------------------------
                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                       P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                       %員工履約後的資產價值在BTT接點的B節點------------------
                       BTT_B_node=max(max_time_node)-n; 
                       if n>0
                           %在t+delta時點下的最適轉換比率Alpha---------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                           %每股價格----------------------------------------
                           Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                           %股東價值----------------------------------------
                           Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                           %債券價值----------------------------------------
                           Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                           %ESO價值-----------------------------------------
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
                           %在t+delta時點下的最適轉換比率Alpha---------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                           %每股價格----------------------------------------
                           Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                           %股東價值----------------------------------------
                           Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                           %債券價值----------------------------------------
                           Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , exp(log(default_boundary_value(j+1)-2*sigma*t)) ,r,t)+F*c*t;
                           %ESO價值-----------------------------------------
                           Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                           ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+N*( b - a_node )*percent*Payoff;
                           if Payoff==0 && b>a_node
                               Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                               Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                               Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                               ESO_value(a,b,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end
                       elseif n<0
                           %每股價格----------------------------------------
                           Stock_value(a,b,i_node,j)=0;
                           %股東價值----------------------------------------
                           Equity_value(a,b,i_node,j)=0;
                           %債券價值----------------------------------------
                           Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                           %ESO價值-----------------------------------------
                           %計算員工效用函數算
                           ESO_value(a,b,i_node,j)=0;
                       end
                   elseif j<step*T_exercise/T+1%員工不可以履約
                       if b==1 %在歸屬日前都是0%，這是0%的矩陣位置
                           %員工履約後的資產價值-----------------------------
                           V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t;
                           %BTT計算機率-------------------------------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %員工履約後的資產價值在BTT接點的B節點-------------
                           BTT_B_node=max(max_time_node)-n;
                           if n>0
                               %在t+delta時點下的最適轉換比率Alpha-----------
                               if j==step*T_exercise/T
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               %每股價格------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               %股東價值------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                               %債券價值------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                               %ESO價值-------------------------------------
                               ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                           elseif n==0
                               %在t+delta時點下的最適轉換比率Alpha-----------
                               if j==step*T_exercise/T
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               %每股價格------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               %股東價值------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                               %債券價值------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , exp(log(default_boundary_value(j+1)-2*sigma*t)) ,r,t)+F*c*t;
                               %ESO價值------------------------------------
                                ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                           elseif n<0
                               %每股價格------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %股東價值------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %債券價值------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                               %ESO價值------------------------------------
                               ESO_value(a,b,i_node,j)=0;
                           end
                       end
                   end
               else
                   %每股價格------------------------------------------------
                   Stock_value(a,b,i_node,j)=0;
                   %股東價值------------------------------------------------
                   Equity_value(a,b,i_node,j)=0;
                   %債券價值------------------------------------------------
                   Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                   %ESO價值-------------------------------------------------
                   ESO_value(a,b,i_node,j)=0;
               end
           end           
           %找出員工效用最大化時應贖回至多少b%
           alpha_Utility=min(find(ESO_value(a,a_node:Percentage,i_node,j)==max(ESO_value(a,a_node:Percentage,i_node,j))))+a_node-1;
           Payoff=max(Stock_value(a,alpha_Utility,i_node,j)-X,0);
           alpha(a,alpha_Utility,i_node,j)=(alpha_Utility-1)*percent;          
       end
   end
end


%員工履約後的資產價值-----------------------------
[Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V,default_boundary_value(2));
BTT_B_node=max(max_time_node)-n;
P=[P;max(max_time_node),1,BTT_B_node,1,n,V,default_boundary_value(2),Pu,Pm,Pd,Pu+Pm+Pd];
%在t t時點下的最適轉換比率Alpha---------
if T_exercise==0
    [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(Percentage,1:Percentage,BTT_B_node-1,2) , ESO_value(Percentage,1:Percentage,BTT_B_node,2) , ESO_value(Percentage,1:Percentage,BTT_B_node+1,2) ,1);
else
    alpha_u=1;alpha_m=1;alpha_d=1;
end
%每股價格------------------------------------
Stock_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Stock_value(Percentage,alpha_u,BTT_B_node-1,2) , Stock_value(Percentage,alpha_m,BTT_B_node,2) , Stock_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
%股東價值------------------------------------
% Equity_value(Percentage,1,BTT_B_node,1)=Stock_value(Percentage,1,BTT_B_node,1)*O;
Equity_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Equity_value(Percentage,alpha_u,BTT_B_node-1,2) , Equity_value(Percentage,alpha_m,BTT_B_node,2) , Equity_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
%債券價值------------------------------------
Debt_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Debt_value(Percentage,alpha_u,BTT_B_node-1,2) , Debt_value(Percentage,alpha_m,BTT_B_node,2) , Debt_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
%ESO價值-------------------------------------
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