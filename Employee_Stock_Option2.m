function [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div)
%sigma=公司資產價值標準差(%)
%step=期數            %V=公司資產價值        %wage=員工薪資(年)
%X=員工認股權證面額    %N=員工認股權證數量    %T_exercise=員工可履約日
%F=債券面額           %c=債券債息率          %T=債券到期日
%r=無風險利率         %w=破產成本            %gamma=效用函數的次方值             
%tax_firm=公司稅率    %tax_employee=員工所得稅
%Equity_value=股東價值

%x=給定該期已注資x%的員工認股權
%y=該期應注資至y%的員工認股權
%Alpha=找到一個y=a%，極大化員工的效用
%percent=單位百分比(%)

if nargin<15,error('at least 15 input arguments required'),end
%時間單位程度---------------------------------------------------------------
t=T/step; 
%百分比數列長度-------------------------------------------------------------
Percentage=1/percent+1;
%計算破產邊界---------------------------------------------------------------
default_boundary_value=Default_boundary(type_default,step,T,F,tax_firm,c,r,wage); %違約門檻
default_wage_value=Default_boundary(type_default,step,T,0,tax_firm,c,r,wage); %公司倒閉 員工該拿的價值
%資產樹上界初始值-----------------------------------------------------------
firm_value=V;
Up_boundary_value=[];Nodes=[];
for i=Percentage:-1:1 %找出各層資產數與各個時期的上界
    [up_boundary_value,nodes]=Up_boundary(step,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N,percent); %上界
    Up_boundary_value=[up_boundary_value;Up_boundary_value]; %上界離DB幾個點(2sigma根號delta t)
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
Dividend_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
TB_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
BC_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
Salary_value=zeros(Percentage,Percentage,max(max_time_node),step+1);
P=[];Q=[];



if method==1
    %method1最佳化員工效用-------------------------------------------------
    for j=step+1:-1:1%公司資產價值在t時點
%     for j=step+1:-1:step*T_exercise/T+1
%       for j=step*T_exercise/T:-1:2
       for a=1:Percentage%目前所在的資產樹是以贖回多少百分比， a=1 為 100% ; a=Percentage 為 0%
           %已知員工贖回a%的數值轉換
           a_node=Percentage-a+1;
           for i=1:Nodes(a,j)%不同層樹所展出去的上界皆不同， i=1 為破產邊界
               %在j時點時的資產價值高度，i=1 為破產邊界，往上建
               i_node=max(max_time_node)+1-i;
               for b=a_node:Percentage %0% 50% 100%
                   %已知員工下一期贖回a%的數值轉換=這一期的b%
                   next_time_a=Percentage-b+1;
                   %判斷是否破產
                   if abs( firm_tree_value(i_node,j) - default_boundary_value(j) ) > 10^-10
                       if j==step+1%最後一期
                           %股東價值--------------------------------------------
                           %ESO稅盾加入N*(S-X)*tax
                           Equity_value(a,b,i_node,j)=max((firm_tree_value(i_node,j)-F*(1+(1-tax_firm)*c*t)-O*Div*t-(1-tax_firm)*wage*t+(1-tax_firm)*( b - a_node )*X*N*percent)/(1-tax_firm*(( b - a_node )*N*percent/(O+(b-1)*N*percent))),0);
                           %每股價格--------------------------------------------
                           %員工認股權證總價值不變時，面額越低，股數越高，會稀釋股價，導致不易履約
                           Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                           
                           %債券價值--------------------------------------------
                           
                           Debt_value(a,b,i_node,j)=F*(1+c*t);
                           Dividend_value(a,b,i_node,j)=O*Div*t;
                           %ESO價值---------------------------------------------
                           TB_value(a,b,i_node,j)=F*tax_firm*c*t+tax_firm*wage*t;
                           BC_value(a,b,i_node,j)=0;
                           Salary_value(a,b,i_node,j)=wage*t;
                           %計算員工財富(已扣稅)
                           [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,Stock_value(a,b,i_node,j),X,a_node,b,N,percent,Div,O);
                           %判斷員工的最適效用是否會履約ESO
                           Utility_value(a,b,i_node,j)=Wealth^gamma;
                           if excercise~=true && b>a_node %不可履約，直接抄沒有履約的值
                               Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                               Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                               Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                               Dividend_value(a,b,i_node,j)=Dividend_value(a,a_node,i_node,j);
                           end    
                           if excercise==true %履約ESO會產生稅盾效果
                              TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+tax_firm*( Stock_value(a,b,i_node,j)-X)*( b - a_node )*N*percent;
                           end
                       elseif j>=step*T_exercise/T+1&&j~=1%員工可以履約
                           %員工履約後的資產價值--------------------------------
                           V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t+( b - a_node )*X*N*percent;
                           %BTT計算機率-----------------------------------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                           %員工履約後的資產價值在BTT接點的B節點------------------
                           BTT_B_node=max(max_time_node)-n; 
                           if BTT_B_node==1 %若超過邊界 修正回來
                               BTT_B_node=2;
                           end
                           if n>0 
                               %在t+delta時點下的最適轉換比率Alpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                               %每股價格----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               %股東價值----------------------------------------
                               if  b - a_node>0 && Stock_value(a,b,i_node,j)>X  %將ESO稅盾效果迭代 求出理想化的股價
                                   S=zeros(2,1);
                                   S(2,1)=Stock_value(a,b,i_node,j);
                                   while S(2,1)-S(1,1)>0.0001 %讓他跑到收歛 思路為股價會計算出新股價->新公司價值->新股價 跑到股價收斂
                                       Injection_TS=tax_firm*(S(2,1)-X)*( b - a_node )*N*percent;
                                       V1=V_t+Injection_TS;
                                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V1,default_boundary_value(j+1));
    %                                    P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                                       %員工履約後的資產價值在BTT接點的B節點------------------
                                       BTT_B_node=max(max_time_node)-n; 
                                       if BTT_B_node==1
                                           BTT_B_node=2;
                                       end
                                       S(1,1)=S(2,1);
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                       %每股價格----------------------------------------
                                       S(2,1)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   end
                                   Stock_value(a,b,i_node,j)=S(2,1);
                               end
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                               Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , Dividend_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+O*Div*t;

                               %ESO價值-----------------------------------------
                               TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , TB_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                               BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , BC_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , Salary_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+wage*t;

                               %計算員工財富(已扣稅)
                               [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,Stock_value(a,b,i_node,j),X,a_node,b,N,percent,Div,O);
                               %判斷員工的最適效用是否會履約ESO
                               [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                               Q=[Q;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                               Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,Beta,t);
                               if excercise~=true && b>a_node  %如果已知b時不會履約，則應當把值存成a_node(無履約)的值
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   Utility_value(a,b,i_node,j)=Utility_value(a,a_node,i_node,j);
                                   Dividend_value(a,b,i_node,j)=Dividend_value(a,a_node,i_node,j);
                               end
                               if excercise==true %NQSO履約時，ESO會產生稅盾
                                   TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+( b - a_node )*( Stock_value(a,b,i_node,j)-X)*N*percent*tax_firm;
                               end

                           elseif n==0 && V_t>default_boundary_value(j) %已知中間點接到下期的違約門檻
                               %在t+delta時點下的最適轉換比率Alpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                               %每股價格----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               if Stock_value(a,b,i_node,j)>X %將ESO稅盾效果迭代 求出理想化的股價 
                                   S=zeros(2,1);
                                   S(2,1)=Stock_value(a,b,i_node,j);
                                   while S(2,1)-S(1,1)>0.0001  %讓他跑到收歛
                                       Injection_TS=tax_firm*(S(2,1)-X)*( b - a_node )*N*percent;
                                       V1=V_t+Injection_TS;
                                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V1,default_boundary_value(j+1));
    %                                    P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                                       %員工履約後的資產價值在BTT接點的B節點------------------
                                       BTT_B_node=max(max_time_node)-n; 
                                       S(1,1)=S(2,1);
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0,b);
                                       %每股價格----------------------------------------
                                       S(2,1)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                                   end
                                   Stock_value(a,b,i_node,j)=S(2,1);
                               end
                               %股東價值----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , (1-w)*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t)+F*c*t;
                               Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+O*Div*t;

                               %ESO價值-----------------------------------------
                               TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                               BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , w*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)),r,t);
                               Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+wage*t;

                               %計算員工財富(已扣稅)
                               [Wealth,excercise]=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,Stock_value(a,b,i_node,j),X,a_node,b,N,percent,Div,O);
                               %判斷員工的最適效用是否會履約ESO
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
                               if excercise==true %履約ESO的稅盾
                                   TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+( b - a_node )*( Stock_value(a,b,i_node,j)-X)*N*percent*tax_firm;
                               end
                           else %n<=0就代表破產
                               %每股價格----------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %股東價值----------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*(firm_tree_value(i_node,j)-default_wage_value(j));
                               Dividend_value(a,b,i_node,j)=0;
                               %ESO價值-----------------------------------------
                               TB_value(a,b,i_node,j)=0;
                               BC_value(a,b,i_node,j)=w*(firm_tree_value(i_node,j)-default_wage_value(j));
                               Salary_value(a,b,i_node,j)=default_wage_value(j);
                               %計算員工效用函數算
                               Utility_value(a,b,i_node,j)=0;
                           end
                       elseif j<step*T_exercise/T+1||j==1%員工不可以履約
                           if b==1 %在歸屬日前都是0%，這是0%的矩陣位置
                               %員工履約後的資產價值-----------------------------
                               if j>1
                                   V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t;
                               else
                                   V_t=V;
                               end
                               %BTT計算機率-------------------------------------
                               [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                               %員工履約後的資產價值在BTT接點的B節點-------------
                               BTT_B_node=max(max_time_node)-n;
                               if j==1
                                   i_node=BTT_B_node;
                               end
                               P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                               if n>0 
                                   %在t+delta時點下的最適轉換比率Alpha-----------
                                   if j==step*T_exercise/T||T_exercise==0
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
                                   %ESO價值-------------------------------------
                                   %計算員工年薪(已扣稅)
                                   Wealth=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,X,X,a_node,b,0,percent,Div,O);
                                   %計算員工效用函數算
                                   [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                                   Q=[Q;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                                   Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,Beta,t);
                               elseif n==0 && V_t>default_boundary_value(j) %已知中間點接到下期的違約門檻
                                   %在t+delta時點下的最適轉換比率Alpha-----------
                                   if j==step*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %每股價格------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                                   %股東價值------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %債券價值------------------------------------
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , (1-w)*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t)+F*c*t;
                                   Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+O*Div*t;

                                   %ESO價值------------------------------------
                                   TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                                   BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , w*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t);
                                   Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+wage*t;

                                   %計算員工年薪(已扣稅)
                                   Wealth=Tax_employee(type_tax_employee,tax_employee,t,wage,additional_wealth,X,X,a_node,b,N,percent,Div,O);
                                   %計算員工效用函數算
                                   [Qu,Qm,Qd]=BTT(sigma,r,mu,t,V_t,default_boundary_value(j+1));
                                   Q=[Q;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Qu,Qm,Qd,Qu+Qm+Qd];
                                   Utility_value(a,b,i_node,j)=Wealth^gamma + expected_value(Qu,Qm,Qd, Utility_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,Beta,t);
                               else %n<=0就代表破產
                                   %每股價格------------------------------------
                                   Stock_value(a,b,i_node,j)=0;
                                   %股東價值------------------------------------
                                   Equity_value(a,b,i_node,j)=0;
                                   %債券價值------------------------------------
                                   Debt_value(a,b,i_node,j)=(1-w)*(firm_tree_value(i_node,j)-default_wage_value(j));%清算後的錢
                                   Dividend_value(a,b,i_node,j)=0;
                                   %ESO價值-----------------------------------------
                                   TB_value(a,b,i_node,j)=0;
                                   BC_value(a,b,i_node,j)=w*(firm_tree_value(i_node,j)-default_wage_value(j)); %剩下的錢的清算價值
                                   Salary_value(a,b,i_node,j)=default_wage_value(j); %員工該拿的錢

                                   %計算員工效用函數算
                                   Utility_value(a,b,i_node,j)=0;
                               end
                           end
                       end
                   else
                       %每股價格------------------------------------------------
                       Stock_value(a,b,i_node,j)=0;
                       %股東價值------------------------------------------------
                       Equity_value(a,b,i_node,j)=0;
                       %債券價值------------------------------------------------
                       Debt_value(a,b,i_node,j)=(1-w)*(firm_tree_value(i_node,j)-default_wage_value(j));
                       Dividend_value(a,b,i_node,j)=0;
                       %ESO價值-----------------------------------------
                       TB_value(a,b,i_node,j)=0;
                       BC_value(a,b,i_node,j)=w*(firm_tree_value(i_node,j)-default_wage_value(j));
                       Salary_value(a,b,i_node,j)=default_wage_value(j);
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
               if abs( firm_tree_value(i_node,j) - default_boundary_value(j) ) >10^-10 || j==1
                   if j==step+1
                       ESO_value(a,alpha_Utility,i_node,j)=N*( alpha_Utility - a_node )*percent*Payoff;
                   elseif j>=step*T_exercise/T+1&&j~=1
                       %員工最適履約後的資產價值---------------------------------
                       V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t+( alpha_Utility - a_node )*X*N*percent+tax_firm*( alpha_Utility - a_node )*Payoff*N*percent;
                       %員工最適履約後的資產價值在BTT接點的B節點------------------
                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                       BTT_B_node=max(max_time_node)-n;
                       if n>0 
                           %在t+delta時點下的最適轉換比率Alpha-----------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node+1,j+1) ,alpha_Utility);
                           ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+N*( alpha_Utility - a_node )*percent*Payoff;
                           if Payoff==0 && alpha_Utility>a_node
                               ESO_value(a,alpha_Utility,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end                       
                       elseif n==0 && V_t>default_boundary_value(j) %已知中間點接到下期的違約門檻
                           %在t+delta時點下的最適轉換比率Alpha-----------------
                           [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , 0 ,alpha_Utility);
                           ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+N*( alpha_Utility - a_node )*percent*Payoff;
                           if Payoff==0 && alpha_Utility>a_node
                               ESO_value(a,alpha_Utility,i_node,j)=ESO_value(a,a_node,i_node,j);
                           end 
                       else %n<=0就代表破產
                           ESO_value(a,alpha_Utility,i_node,j)=0;
                       end
                   elseif j<step*T_exercise/T+1 || j==1
                       
                       if a_node==1 %在歸屬日前都是0%，這是0%的矩陣位置
                           %員工最適履約後的資產價值-----------------------------
                           if j>1
                               V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t;
                           else
                               V_t=V;
                           end
                           %員工最適履約後的資產價值在BTT接點的B節點--------------
                           [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                           BTT_B_node=max(max_time_node)-n;
                           if j==1
                               i_node=BTT_B_node;
                           end
                           %BTT計算機率-----------------------------------------
                           if n>0 
                               %在t+delta時點下的最適轉換比率Alpha---------------
                               if j==step*T_exercise/T||T_exercise==0
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node+1,j+1) ,alpha_Utility);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , ESO_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                           elseif n==0 && V_t>default_boundary_value(j)%已知中間點接到下期的違約門檻
                               %在t+delta時點下的最適轉換比率Alpha---------------
                               if j==step*T_exercise/T||T_exercise==0
                                   [alpha_u,alpha_m,alpha_d]=optimal_alpha( Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node-1,j+1) , Utility_value(next_time_a,alpha_Utility:Percentage,BTT_B_node,j+1) , 0 ,alpha_Utility);
                               else
                                   alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                               end
                               ESO_value(a,alpha_Utility,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                           else %n<=0就代表破產
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
    %method2最佳化ESO價值---------------------------------------------------------
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
                           Equity_value(a,b,i_node,j)=max((firm_tree_value(i_node,j)-F*(1+(1-tax_firm)*c*t)-O*Div*t-(1-tax_firm)*wage*t+(1-tax_firm)*( b - a_node )*X*N*percent)/(1-tax_firm*(( b - a_node )*N*percent/(O+(b-1)*N*percent))),0);
                           %每股價格--------------------------------------------
                           %員工認股權證總價值不變時，面額越低，股數越高，會稀釋股價，導致不易履約
                           Stock_value(a,b,i_node,j)=Equity_value(a,b,i_node,j)/(O+(b-1)*N*percent);
                           %債券價值--------------------------------------------
                           Debt_value(a,b,i_node,j)=F*(1+c*t);
                           Dividend_value(a,b,i_node,j)=O*Div*t;
                           
                           TB_value(a,b,i_node,j)=F*tax_firm*c*t+tax_firm*wage*t;
                           BC_value(a,b,i_node,j)=0;
                           Salary_value(a,b,i_node,j)=wage*t;
                           %ESO價值---------------------------------------------
                           Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                           ESO_value(a,b,i_node,j)=N*( b - a_node )*percent*Payoff;
                           if Payoff==0 && b>a_node %不可履約，直接抄沒有履約的值
                               Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                               Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                               Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                               Dividend_value(a,b,i_node,j)=Dividend_value(a,a_node,i_node,j);
                           end    
                           if Payoff>0 %履約ESO會產生稅盾效果
                              TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+tax_firm*( Stock_value(a,b,i_node,j)-X)*( b - a_node )*N*percent;
                           end
                       elseif j>=step*T_exercise/T+1%員工可以履約
                           %員工履約後的資產價值--------------------------------
                           V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t+( b - a_node )*X*N*percent;
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
                               if Stock_value(a,b,i_node,j)>X  %將ESO稅盾效果迭代 求出理想化的股價
                                   S=zeros(2,1);
                                   S(2,1)=Stock_value(a,b,i_node,j);
                                   while S(2,1)-S(1,1)>0.0001 %讓他跑到收歛
                                       Injection_TS=tax_firm*(S(2,1)-X)*( b - a_node )*N*percent;
                                       V1=V_t+Injection_TS;
                                       [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V1,default_boundary_value(j+1));
    %                                    P=[P;i_node,j,a_node,b,n,V_t,default_boundary_value(j+1),Pu,Pm,Pd,Pu+Pm+Pd];
                                       %員工履約後的資產價值在BTT接點的B節點------------------
                                       BTT_B_node=max(max_time_node)-n; 
                                       S(1,1)=S(2,1);
                                       if BTT_B_node==1
                                           BTT_B_node=2;
                                       end
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) ,ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                       %每股價格----------------------------------------
                                       S(2,1)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   end
                                   Stock_value(a,b,i_node,j)=S(2,1);
                               end
                               %股東價值----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , Debt_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*c*t;
                               Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , Dividend_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+O*Div*t;

                               %ESO價值-----------------------------------------
                               TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , TB_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                               BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , BC_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                               Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , Salary_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t)+wage*t;
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
                               if Payoff>0 %履約ESO會產生稅盾效果
                                   TB_value(a,b,i_node,j)=TB_value(a,b,i_node,j)+tax_firm*( Stock_value(a,b,i_node,j)-X)*( b - a_node )*N*percent;
                               end
                           elseif n==0
                               %在t+delta時點下的最適轉換比率Alpha---------------
                               [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , 0 ,b);
                               %每股價格----------------------------------------
                               Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               %股東價值----------------------------------------
                               Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*(O+(b-1)*N*percent);
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , (1-w)*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t)+F*c*t;
                               Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+O*Div*t;

                               %ESO價值-----------------------------------------
                               TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                               BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , w*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)),r,t);
                               Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+wage*t;
                               %ESO價值-----------------------------------------
                               Payoff=max(Stock_value(a,b,i_node,j)-X,0);
                               ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+N*( b - a_node )*percent*Payoff;
                               if Payoff==0 && b>a_node
                                   Stock_value(a,b,i_node,j)=Stock_value(a,a_node,i_node,j);
                                   Equity_value(a,b,i_node,j)=Equity_value(a,a_node,i_node,j);
                                   Debt_value(a,b,i_node,j)=Debt_value(a,a_node,i_node,j);
                                   ESO_value(a,b,i_node,j)=ESO_value(a,a_node,i_node,j);
                               end
                           else %n<=0就代表破產
                               %每股價格----------------------------------------
                               Stock_value(a,b,i_node,j)=0;
                               %股東價值----------------------------------------
                               Equity_value(a,b,i_node,j)=0;
                               %債券價值----------------------------------------
                               Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                               Dividend_value(a,b,i_node,j)=0;
                               %ESO價值-----------------------------------------
                               TB_value(a,b,i_node,j)=0;
                               BC_value(a,b,i_node,j)=w*firm_tree_value(i_node,j);
                               Salary_value(a,b,i_node,j)=0;
                               %ESO價值-----------------------------------------
                               %計算員工效用函數算
                               ESO_value(a,b,i_node,j)=0;
                           end
                       elseif j<step*T_exercise/T+1%員工不可以履約
                           if b==1 %在歸屬日前都是0%，這是0%的矩陣位置
                               %員工履約後的資產價值-----------------------------
%                                if j>1
                                   V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t;
%                                else
%                                    V_t=V;
%                                end
%                                V_t=firm_tree_value(i_node,j)-(1-tax_firm)*F*c*t-O*Div*t-(1-tax_firm)*wage*t;
                               %BTT計算機率-------------------------------------
                               [Pu,Pm,Pd,n]=BTT(sigma,r,r,t,V_t,default_boundary_value(j+1));
                               %員工履約後的資產價值在BTT接點的B節點-------------
                               BTT_B_node=max(max_time_node)-n;
                               if n>0
                                   %在t+delta時點下的最適轉換比率Alpha-----------
                                   if j==step*T_exercise/T||T_exercise==0
                                       [alpha_u,alpha_m,alpha_d]=optimal_alpha( ESO_value(next_time_a,b:Percentage,BTT_B_node-1,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node,j+1) , ESO_value(next_time_a,b:Percentage,BTT_B_node+1,j+1) ,b);
                                   else
                                       alpha_u=a_node;alpha_m=a_node;alpha_d=a_node;
                                   end
                                   %每股價格------------------------------------
                                   Stock_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Stock_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Stock_value(next_time_a,alpha_m,BTT_B_node,j+1) , Stock_value(next_time_a,alpha_d,BTT_B_node+1,j+1) ,r,t);
                                   %股東價值------------------------------------
                                   Equity_value(a,b,i_node,j)=Stock_value(a,b,i_node,j)*O;
                                   %債券價值------------------------------------
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
                                   Debt_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Debt_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Debt_value(next_time_a,alpha_m,BTT_B_node,j+1) , (1-w)*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t)+F*c*t;
                                   Dividend_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Dividend_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Dividend_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+O*Div*t;

                                   %ESO價值------------------------------------
                                   TB_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, TB_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , TB_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+F*tax_firm*c*t+tax_firm*wage*t;
                                   BC_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, BC_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , BC_value(next_time_a,alpha_m,BTT_B_node,j+1) , w*exp(log(default_boundary_value(j+1))-2*sigma*sqrt(t)) ,r,t);
                                   Salary_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, Salary_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , Salary_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t)+wage*t;

                                   %ESO價值------------------------------------
                                    ESO_value(a,b,i_node,j)=expected_value(Pu,Pm,Pd, ESO_value(next_time_a,alpha_u,BTT_B_node-1,j+1) , ESO_value(next_time_a,alpha_m,BTT_B_node,j+1) , 0 ,r,t);
                               else %n<=0就代表破產
                                   %每股價格------------------------------------
                                   Stock_value(a,b,i_node,j)=0;
                                   %股東價值------------------------------------
                                   Equity_value(a,b,i_node,j)=0;
                                   %債券價值------------------------------------
                                   Debt_value(a,b,i_node,j)=(1-w)*firm_tree_value(i_node,j);
                                   Dividend_value(a,b,i_node,j)=0;

                                   %ESO價值------------------------------------
                                   TB_value(a,b,i_node,j)=0;
                                   BC_value(a,b,i_node,j)=w*firm_tree_value(i_node,j);
                                   Salary_value(a,b,i_node,j)=0;
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
                       Dividend_value(a,b,i_node,j)=0;
                       %ESO價值-------------------------------------------------
                       TB_value(a,b,i_node,j)=0;
                       BC_value(a,b,i_node,j)=w*firm_tree_value(i_node,j);
                       Salary_value(a,b,i_node,j)=0;
                       %ESO價值-------------------------------------------------
                       ESO_value(a,b,i_node,j)=0;
                   end
               end           
               %找出員工效用最大化時應贖回至多少b%
               alpha_Utility=min(find(ESO_value(a,a_node:Percentage,i_node,j)==max(ESO_value(a,a_node:Percentage,i_node,j))))+a_node-1;
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
    Equity_value(Percentage,1,BTT_B_node,1)=Stock_value(Percentage,1,BTT_B_node,1)*O;
%     Equity_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Equity_value(Percentage,alpha_u,BTT_B_node-1,2) , Equity_value(Percentage,alpha_m,BTT_B_node,2) , Equity_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    %債券價值------------------------------------
    Debt_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Debt_value(Percentage,alpha_u,BTT_B_node-1,2) , Debt_value(Percentage,alpha_m,BTT_B_node,2) , Debt_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
    Dividend_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Dividend_value(Percentage,alpha_u,BTT_B_node-1,2) , Dividend_value(Percentage,alpha_m,BTT_B_node,2), Dividend_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);

   %ESO價值------------------------------------
   TB_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, TB_value(Percentage,alpha_u,BTT_B_node-1,2) , TB_value(Percentage,alpha_m,BTT_B_node,2) , TB_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
   BC_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, BC_value(Percentage,alpha_u,BTT_B_node-1,2) , BC_value(Percentage,alpha_m,BTT_B_node,2) , BC_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);
   Salary_value(Percentage,1,BTT_B_node,1)=expected_value(Pu,Pm,Pd, Salary_value(Percentage,alpha_u,BTT_B_node-1,2) , Salary_value(Percentage,alpha_m,BTT_B_node,2) , Salary_value(Percentage,alpha_d,BTT_B_node+1,2) ,r,t);

    
    
    %ESO價值-------------------------------------
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

