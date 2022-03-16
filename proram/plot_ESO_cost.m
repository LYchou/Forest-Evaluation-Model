%------------------------------------------------------------------------------------------------------------------------------------------------
clc
clear
%固定變數------------------------
V=[9.91e9 ];
sigma=0.3;
sigma=[0.2 0.5 0.8 1];
% sigma=[0.2 0.25 0.3 0.35];
F=V*0.18;c=0.078;r=0.06;
mu=0.125;
% mu=linspace(0.02,0.1,11);
% X=50;N=1000;O=16000; 
X=8e6;N=linspace(0,10,11);O=1000; 
% N=10;
T=10;
Div=[0 50000 100000] ;
Div=0 ;
T_exercise=3;

wage=[0 670000  5807000 500000000];
wage=670000;
additional_wealth=[670000 50000000 500000000];
additional_wealth=0;
% wage=[0 0.2,0.4,0.6,0.8 1];
% wage=2;
gamma=[0.2 0.5 0.8 1];
gamma=0.5;
% gamma=[0.25,0.5,0.75,1];
w=0.4296;tax_firm=0.21;
% w=0;tax_firm=0;
%step_unit=[1,2,4,12,24,36,52];
type_default=1;
type_tax_employee=[1 2];
result=[];
% 
step_unit=[4];%wage=0;
% %美式(部分履約)-----------------------2
% T_exercise=[3 3 3];
% T_duration=[5 8 10];
method=1;
tax_employee=0;
% tax_employee=[0.05,0.3]; 
percent=[0.5];
% percent=[0.25,0.5,1];
Beta=0.125;

timer=1;
for list_14=1:length(type_tax_employee)
for list_4=1:length(tax_employee)
    for list_6=1:length(gamma)
    for list_7=1:length(wage)    
    for list_1=1:length(T)
        for list_3=1:length(Beta)
            for list_5=1:length(percent)
               for list_2=1:length(step_unit)
                   for list_8=1:length(Div) 

                         for list_12=1:length(additional_wealth)
                              for list_11=1:length(sigma)
                                   for list_10=1:length(V)
                                         for list_9=1:length(N) 
                                            step=T(list_1)*step_unit(list_2);
                                            t=1/step_unit(list_2);
                                            total_step=step;
                                            if list_14==1 %NQSO
                                            N1=0;
                                            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary]=Employee_Stock_Option2(V(list_10),sigma(list_11),T(list_1),T_exercise(list_1),step,F,c,r,mu,X,N1,O,wage(list_7),additional_wealth(list_12),gamma(list_6),tax_employee(list_4),Beta(list_3),w,tax_firm,percent(list_5),type_default,type_tax_employee(list_14),method,Div(list_8));
                                            Utility_no_ESO=Utility;
                                            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option2(V(list_10),sigma(list_11),T(list_1),T_exercise(list_1),step,F,c,r,mu,X,N(list_9),O,wage(list_7),additional_wealth(list_12),gamma(list_6),tax_employee(list_4),Beta(list_3),w,tax_firm,percent(list_5),type_default,type_tax_employee(list_14),method,Div(list_8));
                                            elseif list_14==2 %QSO
                                            N1=0;
                                            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary]=Employee_Stock_Option_ISO(V(list_10),sigma(list_11),T(list_1),T_exercise(list_1),step,F,c,r,mu,X,N1,O,wage(list_7),additional_wealth(list_12),gamma(list_6),tax_employee(list_4),Beta(list_3),w,tax_firm,percent(list_5),type_default,type_tax_employee(list_14),method,Div(list_8));
                                            Utility_no_ESO=Utility;
                                            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option_ISO(V(list_10),sigma(list_11),T(list_1),T_exercise(list_1),step,F,c,r,mu,X,N(list_9),O,wage(list_7),additional_wealth(list_12),gamma(list_6),tax_employee(list_4),Beta(list_3),w,tax_firm,percent(list_5),type_default,type_tax_employee(list_14),method,Div(list_8));
                                            end
                                  %                                              [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=ESO_year(V(list_10),sigma(list_11),T(list_1),T_exercise(list_1),T_duration(list_1),step,F,c,r,mu,X,N(list_9),O,wage(list_7),additional_wealth(list_12),gamma(list_6),tax_employee(list_4),Beta(list_3),w,tax_firm,percent(list_5),type_default,type_tax_employee,method,Div(list_8));

                                            p_correct=sum( length(find(1<0))+length(find(Q<0)) );
            
                                            Asset=Equity+Debt+ESO+Dividend+Salary-TB+BC;
                                            Utility_with_ESO=Utility;

                                            CE_employee=CE(wage(list_7),r,Beta(list_3),t,Utility_with_ESO,Utility_no_ESO,gamma(list_6),total_step,tax_employee(list_4),0);
                                            CE_wage_ESO=CE(wage(list_7),r,Beta(list_3),t,Utility_with_ESO,0,gamma(list_6),total_step,tax_employee(list_4),0);
                                            CE_wage=CE(wage(list_7),r,Beta(list_3),t,Utility_no_ESO,0,gamma(list_6),total_step,tax_employee(list_4),0);

          %                                 
            %                                     result=[result;method,V,step_unit(list_2),T_exercise(list_1),T(list_1),percent(list_5),Beta(list_3),tax_employee(list_4),gamma(list_6),wage(list_7),Div(list_8),p_correct,Equity,Debt,Dividend,Salary,ESO,TB,BC,Asset];                          
                                            result=[result;type_tax_employee(list_14),V(list_10),step_unit(list_2),T_exercise(list_1),T(list_1),N(list_9),percent(list_5),Beta(list_3),tax_employee(list_4),gamma(list_6),sigma(list_11),wage(list_7),Div(list_8),p_correct,Equity,Debt,Dividend,Salary,ESO,TB,BC,Asset,CE_employee,CE_wage_ESO,CE_wage];                             
                                            disp(string(timer))
                                            timer=timer+1;
                                         end
                                     end
                                  end
                              end
                           end
                      end
                   end
               end
           end
        end
    end
end
end
x=result';
xlswrite('C:\Users\hijac\OneDrive\桌面\交大\image\0819\ESO研究結果0819.xlsx',x,'sigma');


%畫圖-------------------------------------------------------------------------------------------

g1=1;
% list_1=3;
for j=1:2
for i=1:length(sigma)
% for i=1:length(gamma)
% for i=1:length(wage)   
% for i=1:length(additional_wealth)  
% for i=1:length(Div)      
    %     a=33*list_1-32;
    % %      a=1;
        CE1=x(19,:);
    %     for i=1:3
%     i=list_4;
    k2=(j-1)*length(a2)*length(sigma)  ;
    CE=CE1(length(a2)*(i-1)+1+k2:length(a2)*i+k2);
    if i==1
        plot(N,CE,'--o');
    elseif i==2
        plot(N,CE,'--x');
    elseif i==3
        plot(N,CE,'--*');
    elseif i==4
        plot(N,CE,'--+');
    end
%     xlabel('ESO張數'),ylabel('總CE')
    if j==1
    xlabel('the Ratio of NQSO(有注資和稀釋效果) to Equity(?)'),ylabel('ESO Cost')
    else
    xlabel('the Ratio of QSO(有注資和稀釋效果) to Equity(?)'),ylabel('ESO Cost')
    end
    ylabel('ESO cost')
%     title('年薪='+string(wage)+'  Sigma=0.3')
    title('年薪='+string(wage)+'  Gamma=0.5')
%     title('年薪='+string(wage)+'  Gamma=0.5'+'  Sigma=0.3')
%     title('Gamma=0.5  Sigma=0.3')

    hold on
end

               
%     legend('gamma=0.2','gamma=0.5','gamma=0.8','gamma=1','Location','NorthWest');
%     legend('wage=0(min)','wage=670000(mean)','wage=5807000(max)','wage=500000000(irrational)','Location','NorthWest');
%      legend('wage=0(min)','wage=200000000(irratiional)','Location','NorthWest');
%     legend('additional wealth=670000','additional wealth=50000000','additional wealth=500000000','Location','NorthWest');
        legend('sigma=0.2','sigma=0.5','sigma=0.8','sigma=1','Location','NorthWest');
%  legend('T=5','T=8','T=10');
% legend('percent=0.25','percent=0.5','percent=1');
% legend('annual Div=0','annual Div=50000','annual Div=100000','Location','NorthWest');
% print(gcf,'C:\Users\hijac\OneDrive\桌面\交大\image\研究結果\靜態分析\ad_wealth\'+string(g1),'-dpng')   %儲存為png格式的圖片到當前路徑</font>
print(gcf,'C:\Users\hijac\OneDrive\桌面\交大\image\0819\靜態分析\sigma\'+string(g1),'-dpng')   %儲存為png格式的圖片到當前路徑</font>
g1=g1+1;
hold off
end



