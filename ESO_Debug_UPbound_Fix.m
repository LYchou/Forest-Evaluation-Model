

%將普通債債息c與破產成本邊界Bcc脫勾
%參數設定
%嘗試修改inj帶來的選點問題
clc;clear;
F=200;          %普通債總面額
c=0.09;         %普通債票面利率
Bcc=0;          %破產邊界
X=3.22730467045146;            %ESO履約價
N=25;           %ESO張數
O=50;           %在外流通股數
wage=0;         %期間內總薪資
tax_firm=0.35;     %公司稅率
w=0.5;            %破產成本
V=250;          %資產初始價值
sigma=0.22;     %資產波動度(低)
T=10;           %到期日
step_n=10;     %總期數
r=0.06;         %無風險利率
T_exercise=1;   %可履約區間（最初可履約時間）
percent=0.25;    %最小履約區間 0.2=20%
tax_employee=0; %員工個人所得稅
Beta=0;         %效用折現因子
gamma=1;        %gamma=效用函數的次方值(員工風險趨避係數)
type_default=1; %破產邊界type:1折現型、2固定型（未完成）、0近似不會破產
fix_DB=90;
type_tax_employee=0; %個人稅類型：0固定型、1累進型（未完成）
method=1;%method1最佳化員工效用、method2最佳化ESO價值
mu=0.06;           %資產增長均值

%sigma=公司資產價值標準差(%)
%step_n=期數            %V=公司資產價值        %wage=員工薪資(年)
%X=員工認股權證面額    %N=員工認股權證數量    %T_exercise=員工可履約日
%F=債券面額           %c=債券債息率          %T=債券到期日
%r=無風險利率         %w=破產成本            %gamma=效用函數的次方值             
%tax_firm=公司稅率    %tax_employee=員工所得稅
%Equity_value=股東價值

%x=給定該期已注資x%的員工認股權
%y=該期應注資至y%的員工認股權
%Alpha=找到一個y=a%，極大化員工的效用
%percent=單位百分比(%)

%時間單位程度---------------------------------------------------------------
t=T/step_n; 
%百分比數列長度-------------------------------------------------------------
Percentage=1/percent+1;
%計算破產邊界---------------------------------------------------------------
default_boundary_value=Default_boundary(type_default,step_n,T,F,tax_firm,Bcc,r,fix_DB);
%資產樹上界初始值-----------------------------------------------------------
firm_value_p=V;
Up_boundary_value_p=[];Nodes_p=[];
for pi=Percentage:-1:1
    [up_boundary_value,nodes]=Up_boundary(step_n,r,sigma,T,T_exercise,firm_value_p,default_boundary_value,X,N,percent);
    Up_boundary_value_p=[up_boundary_value;Up_boundary_value_p];
%     Nodes=[nodes;Nodes];
    Nodes_p(pi,:)=nodes;
    firm_value_p=Up_boundary_value_p;
end
%資產樹100%履約上界初始值---------------------------------------------------
firm_value_100=V;
Up_boundary_value_100=[];Nodes_100=[];
for pi=Percentage:-1:1
    [up_boundary_value_100,nodes_100]=Up_boundary_100(step_n,mu,sigma,T,T_exercise,firm_value_100,default_boundary_value,X,N);
    Up_boundary_value_100=[up_boundary_value_100;Up_boundary_value_100];
    Nodes_100(pi,:)=nodes_100;
    firm_value_100=Up_boundary_value_100;
end

%建立資產樹價值-------------------------------------------------------------
[firm_tree_value_100,max_time_node_100]=Firm_tree_value(V,sigma,step_n,t,default_boundary_value,Nodes_100);

%建立個價值樹---------------------------------------------------------------
Equity_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
Stock_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
Debt_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
ESO_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
Utility_value=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
alpha=zeros(Percentage,Percentage,max(max_time_node_100),step_n+1);
%先建立最大的P,Q矩陣
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
    %method1最佳化員工效用-------------------------------------------------
    for j=step_n+1:-1:1%公司資產價值在t時點
       for a=1:Percentage%目前所在的資產樹是以贖回多少百分比， a=1 為 100% ; a=Percentag 為 0%
           %已知員工贖回a%的數值轉換
           a_node=Percentage-a+1;
           for pi=1:Nodes_p(a,j)%不同層樹所展出去的上界皆不同， i=1 為破產邊界
               %在j時點時的資產價值高度，i=1 為破產邊界，往上建
               i_node=max(max_time_node_100)+1-pi;
               for b=a_node:Percentage
                   %已知員工下一期贖回a%的數值轉換=這一期的b%
                   next_time_a=Percentage-b+1;
                   %判斷是否破產
                   if abs( firm_tree_value_100(i_node,j) - default_boundary_value(j) ) > 10^-10
                       if j==step_n+1%最後一期
                           %股東價值--------------------------------------------
                           Equity_value(a,b,i_node,j)=max(firm_tree_value_100(i_node,j)-F*(1+(1-tax_firm)*c*t)+( b - a_node )*X*N*percent,0);
                           %每股價格--------------------------------------------
                           %員工認股權證總價值不變時，面額越低，股數越高，會稀釋股價，導致不易履約
                           Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                           %債券價值--------------------------------------------
                           Debt_value(a,b,i_node,j)=F*(1+c*t);
                           %ESO價值---------------------------------------------
                           %計算員工財富(已扣稅)
                           [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,Stock_value(a,b,i_node,j),X,a_node,b,N,percent);
                           %判斷員工的最適效用是否會履約ESO
                           Utility_value(a,b,i_node,j)=Wealth^gamma;
                           if excercise~=true && b>a_node
                               Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                               Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                               Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                           end
                       elseif j>=step_n*T_exercise/T+1&&j~=1%員工可以履約
                           %員工履約後的資產價值--------------------------------
                           V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t+( b - a_node )*X*N*percent;
                           %BTT計算機率-----------------------------------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           currentPindex = currentPindex + 1;
                           P(currentPindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %員工履約後的資產價值在BTT接點的B節點------------------
                           BTT_B_node=max(max_time_node_100)-n; 
                           if n>0
                               %在t+delta時點下的最適轉換比率Alpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                               %每股價格----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               %股東價值----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                               %ESO價值-----------------------------------------
                               %計算員工財富(已扣稅)
                               [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,Stock_value(a,b,i_node,j),X,a_node,b,N,percent);
                               %判斷員工的最適效用是否會履約ESO
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
                               %在t+delta時點下的最適轉換比率Alpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                               %每股價格----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               %股東價值----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , exp(log(default_boundary_value(j+1)-2*sigma*t)) ,r,t)+F*c*t;
                               %ESO價值-----------------------------------------
                               %計算員工財富(已扣稅)
                               [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,Stock_value(a,b,i_node,j),X,a_node,b,N,percent);
                               %判斷員工的最適效用是否會履約ESO
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
                               %每股價格----------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %股東價值----------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                               %ESO價值-----------------------------------------
                               %計算員工效用函數算
                               Utility_value(a,b,i_node,j)=0;
                           end
                       elseif j<step_n*T_exercise/T+1||j==1%員工不可以履約
                           if b==1 %在歸屬日前都是0%，這是0%的矩陣位置
                               %員工履約後的資產價值-----------------------------
                               if j>1
                                   V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t;
                               else
                                   V_t=V;
                               end
                               %BTT計算機率-------------------------------------
                               [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                               %員工履約後的資產價值在BTT接點的B節點-------------
                               BTT_B_node=max(max_time_node_100)-n;
                               if j==1
                                   i_node=BTT_B_node;
                               end
                               currentPindex = currentPindex + 1;
                               P(currentPindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                               if n>0
                                   %在t+delta時點下的最適轉換比率Alpha-----------
                                   if j==step_n*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %每股價格------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   %股東價值------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %債券價值------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   if j>1
                                       Debt_value(a,b,i_node,j)=Debt_value(a,b,i_node,j)+F*c*t;
                                   end
                                   %ESO價值-------------------------------------
                                   %計算員工年薪(已扣稅)
                                   Wealth=Tax_employee(type_tax_employee,tax_employee,t,wage,X,X,a_node,b,N,percent);
                                   %計算員工效用函數算
                                   [Qu,Qm,Qd,Qn]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                                   currentQindex = currentQindex + 1;
                                   Q(currentQindex,:)=[i_node,j,a_node,b,Qn,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                                   Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,Beta,t);
                               elseif n==0
                                   %在t+delta時點下的最適轉換比率Alpha-----------
                                   if j==step_n*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
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
                                   %計算員工年薪(已扣稅)
                                   Wealth=Tax_employee(type_tax_employee,tax_employee,t,wage,X,X,a_node,b,N,percent);
                                   %計算員工效用函數算
                                   [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                                   currentQindex = currentQindex + 1;
                                   Q(currentQindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                                   Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,Beta,t);
                               elseif n<0
                                   %每股價格------------------------------------
                                   Stock_value(a,b,i_node,j)=0;
                                   %股東價值------------------------------------
                                   Equity_value(a,b,i_node,j)=0;
                                   %債券價值------------------------------------
                                   Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                                   %ESO價值------------------------------------
                                   %計算員工效用函數算
                                   Utility_value(a,b,i_node,j)=0;
                               end
                           end
                       %currentGindex = currentGindex + 1;
                       %G(currentGindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1)];
                       end
                   else
                       %每股價格------------------------------------------------
                       Stock_value(a,b,i_node,j)=0;
                       %股東價值------------------------------------------------
                       Equity_value(a,b,i_node,j)=0;
                       %債券價值------------------------------------------------
                       Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                       %ESO價值-------------------------------------------------
                       %計算員工效用函數算
                       Utility_value(a,b,i_node,j)=0;
                   end

               end           
               %找出員工效用最大化時應贖回至多少b%
               alpha_Utility=min(find(Utility_value(a,a_node:Percentage,i_node,j)==max(Utility_value(a,a_node:Percentage,i_node,j))))+a_node-1;
               Payoff=max(Stock_value(a,alpha_Utility,i_node,j)-X,0);
               alpha(a,alpha_Utility,i_node,j)=(alpha_Utility-1)*percent;
               next_time_a=Percentage-alpha_Utility+1;
               %判斷是否破產
               if abs( firm_tree_value_100(i_node,j) - default_boundary_value(j) ) >10^-10 || j==1
                   if j==step_n+1
                       ESO_value(a,alpha_Utility,i_node,j)=N*( alpha_Utility - a_node )*percent*Payoff;
                   elseif j>=step_n*T_exercise/T+1&&j~=1
                       %員工最適履約後的資產價值---------------------------------
                       V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t+( alpha_Utility - a_node )*X*N*percent;
                       %員工最適履約後的資產價值在BTT接點的B節點------------------
                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                       BTT_B_node=max(max_time_node_100)-n;
                       if n>0
                           %在t+delta時點下的最適轉換比率Alpha-----------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node+1,j+1) ,alpha_Utility);
                           ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+N*( alpha_Utility - a_node )*percent*Payoff;
                           if Payoff==0 && alpha_Utility>a_node
                               ESO_value(a,alpha_Utility,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end                       
                       elseif n==0
                           %在t+delta時點下的最適轉換比率Alpha-----------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , 0 ,alpha_Utility);
                           ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+N*( alpha_Utility - a_node )*percent*Payoff;
                           if Payoff==0 && alpha_Utility>a_node
                               ESO_value(a,alpha_Utility,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end 
                       elseif n<0
                           ESO_value(a,alpha_Utility,i_node,j)=0;
                       end
                   elseif j<step_n*T_exercise/T+1 || j==1
                       
                       if a_node==1 %在歸屬日前都是0%，這是0%的矩陣位置
                           %員工最適履約後的資產價值-----------------------------
                           if j>1
                               V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t;
                           else
                               V_t=V;
                           end
                           %員工最適履約後的資產價值在BTT接點的B節點--------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           BTT_B_node=max(max_time_node_100)-n;
                           if j==1
                               i_node=BTT_B_node;
                           end
                           %BTT計算機率-----------------------------------------
                           if n>0
                               %在t+delta時點下的最適轉換比率Alpha---------------
                               if j==step_n*T_exercise/T||T_exercise==0
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node+1,j+1) ,alpha_Utility);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                           elseif n==0
                               %在t+delta時點下的最適轉換比率Alpha---------------
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
    %method2最佳化ESO價值---------------------------------------------------------
    for j=step_n+1:-1:2%公司資產價值在t時點
       for a=1:Percentage%目前所在的資產樹是以贖回多少百分比， a=1 為 100% ; a=Percentag 為 0%
           %已知員工贖回a%的數值轉換
           a_node=Percentage-a+1;
           for pi=1:Nodes_p(a,j)%不同層樹所展出去的上界皆不同， i=1 為破產邊界
               %在j時點時的資產價值高度，i=1 為破產邊界，往上建
               i_node=max(max_time_node_100)+1-pi;
               for b=a_node:Percentage
                   %已知員工下一期贖回a%的數值轉換=這一期的b%
                   next_time_a=Percentage-b+1;
                   %判斷是否破產
                   if abs( firm_tree_value_100(i_node,j) - default_boundary_value(j) ) > 10^-10
                       if j==step_n+1%最後一期
                           %股東價值--------------------------------------------
                           Equity_value(a,b,i_node,j)=max(firm_tree_value_100(i_node,j)-F*(1+(1-tax_firm)*c*t)+( b - a_node )*X*N*percent,0);
                           %每股價格--------------------------------------------
                           %員工認股權證總價值不變時，面額越低，股數越高，會稀釋股價，導致不易履約
                           Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                           %債券價值--------------------------------------------
                           Debt_value(a,b,i_node,j)=F*(1+c*t);
                           %ESO價值---------------------------------------------
                           Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                           ESO_value(a,b,i_node,j)=N*( b - a_node )*percent*Payoff;
                       elseif j>=step_n*T_exercise/T+1%員工可以履約
                           %員工履約後的資產價值--------------------------------
                           V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t+( b - a_node )*X*N*percent;
                           %BTT計算機率-----------------------------------------
                           currentPindex = currentPindex + 1;
                           P(currentPindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %員工履約後的資產價值在BTT接點的B節點------------------
                           BTT_B_node=max(max_time_node_100)-n; 
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
                               Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                               %ESO價值-----------------------------------------
                               %計算員工效用函數算
                               ESO_value(a,b,i_node,j)=0;
                           end
                       elseif j<step_n*T_exercise/T+1%員工不可以履約
                           if b==1 %在歸屬日前都是0%，這是0%的矩陣位置
                               %員工履約後的資產價值-----------------------------
                               V_t=firm_tree_value_100(i_node,j)-(1-tax_firm)*F*c*t;
                               %BTT計算機率-------------------------------------
                               [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                               currentPindex = currentPindex + 1;
                               P(currentPindex,:)=[i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                               %員工履約後的資產價值在BTT接點的B節點-------------
                               BTT_B_node=max(max_time_node_100)-n;
                               if n>0
                                   %在t+delta時點下的最適轉換比率Alpha-----------
                                   if j==step_n*T_exercise/T||T_exercise==0
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
                                   if j==step_n*T_exercise/T
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
                                   Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                                   %ESO價值------------------------------------
                                   ESO_value(a,b,i_node,j)=0;
                               end
                           end
                        %currentGindex = currentGindex + 1;
                        %G(currentGindex,:)=[i_node,j,a_node,b,V_t,default_boundary_value(j+1)];
                       end
                   else
                       %每股價格------------------------------------------------
                       Stock_value(a,b,i_node,j)=0;
                       %股東價值------------------------------------------------
                       Equity_value(a,b,i_node,j)=0;
                       %債券價值------------------------------------------------
                       Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value_100(i_node,j);
                       %ESO價值-------------------------------------------------
                       ESO_value(a,b,i_node,j)=0;
                   end

               end           
               %找出員工效用最大化時應贖回至多少b%
               alpha_Utility=min(find(ESO_value(a,a_node:Percentage,i_node,j)==max(ESO_value(a,a_node:Percentage,i_node,j))))+a_node-1;
               alpha(a,alpha_Utility,i_node,j)=(alpha_Utility-1)*percent;
               
               currentLindex = currentLindex + 1;
               L(currentLindex,:)=[i_node,j,a_node,alpha_Utility,firm_tree_value_100(i_node,j),default_boundary_value(j)];
           end
       end
    end


    %員工履約後的資產價值-----------------------------
    [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V,default_boundary_value(2));
    BTT_B_node=max(max_time_node_100)-n;
    currentPindex = currentPindex + 1;
    P(currentPindex,:)=[max(max_time_node_100),1,BTT_B_node,1,n,V,default_boundary_value(2),Pu,Pm,Pd,Pu+Pm+Pd];
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

end

%處理PQ，把用不到的值去掉
finalPindex = find(P(:,1)==0,1);
P(finalPindex:end,:)=[];
finalQindex = find(Q(:,1)==0,1);
Q(finalQindex:end,:)=[];
finalLindex = find(L(:,1)==0,1);
L(finalLindex:end,:)=[];

%計算不考慮機率的平均履約比例
aaa = (L(:,3)-1) ./ (Percentage-1); %還原a%
bbb = (L(:,4)-1) ./ (Percentage-1); %還原b%
%(b%-a%) 計算已履約比例
lll = (bbb-aaa) ./ (1-aaa) ; %  (b%-a%) / (1-a%)
lll(isnan(lll))=0; % a%=100%時分母為0，會有NaN的結果，補零
lll(lll==0) = []; %把原本就沒有履約跟NaN結果都刪掉
L_Avg_Exercise = mean(lll);

function default_boundary_value=Default_boundary(type,step_n,T,F,tax_firm,Bcc,r,fix_DB)
%破產邊界計算
    t=T/step_n;
    default_boundary_value=zeros(1,step_n+1);
    
    if type==0
        %破產邊界近似於零---------------------------------------------------
        default_boundary_value(2:end)=0.01;
    elseif type==1
        %債券折現破產函數---------------------------------------------------
        default_boundary_value(step_n+1)=F*(1+(1-tax_firm)*Bcc*t);
        for i=step_n:-1:2
            %計算每個時點的破產邊界
            default_boundary_value(i)=default_boundary_value(i+1)*exp(-r*t)+(1-tax_firm)*F*Bcc*t;
        end
    elseif type==2
        %破產邊界設為固定值------------------------------------------
        if nargin<8,error('Type2 at least 8 input arguments required'),end
        default_boundary_value(2:end)=fix_DB;
    end

end

function [up_boundary_value,nodes]=Up_boundary(step_n,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N,percent)
%影響資產樹跳躍的關鍵 sigma,X,N,percent
%當員工決定贖回的部位越大，較有可能使得資產樹跳躍時支點變多
%前提是跳躍的幅度必須大於2*sigma*sqrt(t)

%上界計算
    t=T/step_n;
    up_boundary_value=zeros(1,step_n+1);
    nodes=zeros(1,step_n+1);
    if sum(size(firm_value))==2
        %ESO未履約的最下層樹------------------------------------------------
        up_boundary_value(1)=firm_value;
        nodes(1)=1;
        for i=2:step_n+1
            %n為B點的節點和破產邊界的距離是幾倍
            n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
            %最上界的節點(A點)至破產邊界的距離
            up_boundary_value(i)=exp( log(default_boundary_value(i))+(n+1)*2*sigma*sqrt(t) );
            %資產上界到下界的節點數
            nodes(i)=n+2;
        end
    else
        %ESO已履約過的其他層樹----------------------------------------------
        for i=step_n*T_exercise/T+1:step_n+1
            %擷取該時間點資產的上界
            firm_jump=firm_value(:,i);
            %計算不同層資產樹往上跳躍時，會跳到的位置的極大值
            %firm_jump=firm_jump + (1:length(firm_jump))' *X*N*percent; 
            firm_jump=firm_jump + (1:length(firm_jump))' *X*N*percent; 
            firm_jump=max(firm_jump);
            %計算資產跳躍的節點的上界
            if default_boundary_value(i)==0
                n_jump=0;
            else
                n_jump=choosej(sigma,0,t,firm_jump,default_boundary_value(i));
                %n_jump=choosej(sigma,r,t,firm_jump,default_boundary_value(i));
            end
            if i==step_n*T_exercise/T+1
                %歸屬日僅考慮資產跳躍節點的問題------------------------------
                n=n_jump;
            else
                %不僅考慮資產跳躍還有BTT三元樹分支接點-----------------------
                %n為B點的節點和破產邊界的距離是幾倍
                n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
                %比較資產樹跳躍的節點和A點的節點誰大
                n=max(n+1,n_jump);                
            end  
            up_boundary_value(i)=exp( log(default_boundary_value(i))+n*2*sigma*sqrt(t) );
            nodes(i)=n+1;
        end
    end

end


function [up_boundary_value,nodes]=Up_boundary_100(step_n,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N)
%影響資產樹跳躍的關鍵 sigma,X,N,percent
%當員工決定贖回的部位越大，較有可能使得資產樹跳躍時支點變多
%前提是跳躍的幅度必須大於2*sigma*sqrt(t)

%上界計算
    t=T/step_n;
    up_boundary_value=zeros(1,step_n+1);
    nodes=zeros(1,step_n+1);
    if sum(size(firm_value))==2
        %ESO未履約的最下層樹------------------------------------------------
        up_boundary_value(1)=firm_value;
        nodes(1)=1;
        for i=2:step_n+1
            %n為B點的節點和破產邊界的距離是幾倍
            n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
            %最上界的節點(A點)至破產邊界的距離
            up_boundary_value(i)=exp( log(default_boundary_value(i))+(n+1)*2*sigma*sqrt(t) );
            %資產上界到下界的節點數
            nodes(i)=n+2;
        end
    else
        %ESO已履約過的其他層樹----------------------------------------------
        for i=step_n*T_exercise/T+1:step_n+1
            %擷取該時間點資產的上界
            firm_jump=firm_value(:,i);
            %計算不同層資產樹往上跳躍時，會跳到的位置的極大值
            %firm_jump=firm_jump + (1:length(firm_jump))' *X*N*percent; 
            firm_jump=firm_jump + (1:length(firm_jump))' *X*N; 
            firm_jump=max(firm_jump);
            %計算資產跳躍的節點的上界
            if default_boundary_value(i)==0
                n_jump=0;
            else
                n_jump=choosej(sigma,0,t,firm_jump,default_boundary_value(i));
                %n_jump=choosej(sigma,r,t,firm_jump,default_boundary_value(i));
            end
            if i==step_n*T_exercise/T+1
                %歸屬日僅考慮資產跳躍節點的問題------------------------------
                n=n_jump;
            else
                %不僅考慮資產跳躍還有BTT三元樹分支接點-----------------------
                %n為B點的節點和破產邊界的距離是幾倍
                n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
                %比較資產樹跳躍的節點和A點的節點誰大
                n=max(n+1,n_jump);                
            end  
            up_boundary_value(i)=exp( log(default_boundary_value(i))+n*2*sigma*sqrt(t) );
            nodes(i)=n+1;
        end
    end

end

function n=choosej(sigma,r,t,firm_value,default_value)
%找出B點位置，計算資產價值相對於破產邊界幾個兩倍sigma根號t
    firm_value=firm_value*exp(r*t);
    %n=round( log(firm_value/default_value) / (2*sigma*sqrt(t)) );
    
    %當破產邊界設為0.01時，firm_value可能為負值，log後會有虛數
    %n可以小於0，處理一下負值log後的虛數問題
    if firm_value<0
        %當firm_value為負值時，n=-1，意味此firm_value破產
        n = -1;
    else
        n = round( log(firm_value/default_value) / (2*sigma*sqrt(t)) );
    end
    
end

function [firm_tree_value,max_time_node]=Firm_tree_value(V,sigma,step_n,t,default_boundary_value,Nodes)
%建立資產樹價值
    %資產樹每個時點的最大節點
    max_time_node=max(Nodes);
    %計算時點中的最大節點
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
%計算員工年收入(以扣稅)
    %Percentage=1/percent+1;
    %計算員工履約後的單位報酬
    Payoff=max(S-X,0);
    if Payoff>0
        excercise=true;
        Wealth=( wage*t + Payoff*( b - a_node )*N*percent );
    else
        excercise=false;
        Wealth=wage*t;    
    end
    if type==0
        %員工不需要課稅或稅率為常數------------------------------------------
        Wealth=(1-tax_employee)*Wealth;
    elseif type==1
        %員工需依照稅的級距課稅----------------------------------------------
    else
        %其他情況，自行設定 ------------------------------------------------
    end
end

function [Pu,Pm,Pd,n]=BTT(sigma,r,mu,t,V_t,default_value)
    %資產節點值--------------------------------
    n=choosej(sigma, r,t,V_t,default_value);
    u=exp(sigma*sqrt(t));
    Vm=default_value*u^(2*n);
    Vu=default_value*u^(2*(n+1));
    Vd=default_value*u^(2*(n-1));
    %平均值-----------------------------------
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
