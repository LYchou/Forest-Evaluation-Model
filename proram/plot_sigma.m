clc
clear
%固定變數------------------------
V=900;
sigma=[0.2 0.6 1];
sigma=0.6;
F=500;c=0.06;r=0.02;
mu=0.02;
X=10;N=10;O=100; 
T=[5,10];
T=5;
% Div=[0 0.25 0.5 0.75 ] ;
Div=0 ;
T_exercise=3;
wage=0;
% wage=[0 0.2,0.4,0.6,0.8 1];
wage=10;
gamma=0.5 ;
% gamma=[0.25,0.5,0.75,1];
w=0;tax_firm=0;
%step_unit=[1,2,4,12,24,36,52];
type_default=1;type_tax_employee=0;
result=[];
% 
step_unit=[12];%wage=0;
method=1;
tax_employee=0.05;
% tax_employee=[0.05,0.3]; 
percent=[1];
% percent=[0.25,0.5,1];
Beta=0.125;
layer=1;%最下面那層layer=1
k=1;%k=1畫履約stock price k=2畫firm_value
for list_4=1:length(tax_employee)
    for list_1=1:length(T)
        for list_3=1:length(Beta)
            for list_5=1:length(percent)
               for list_2=1:length(step_unit)
                   for list_8=1:length(Div)
                       for list_7=1:length(wage)
                           for list_6=1:length(gamma) 
                               for list_9=1:length(sigma) 
                                step=T(list_1)*step_unit(list_2);
                                Percentage=1/percent+1; 
                                for method=1:2
                                    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,Utility_value,ESO_value,firm_tree_value,Equity_value,Debt_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value]=Employee_Stock_Option(V,sigma(list_9),T(list_1),T_exercise(list_1),step,F,c,r,mu,X,N,O,wage(list_7),gamma(list_6),tax_employee(list_4),Beta(list_3),w,tax_firm,percent(list_5),type_default,type_tax_employee,method,Div(list_8));
                                    U1=Debt_value;%他Utility值會存到這= =
                                    if method==2
                                        U1=Utility_value;
                                    end
                                    S1=ESO_value;%他Stock值會存到這= =
                                    total_step=step;
                                    %從可履約開始往後畫
                                    period=linspace(total_step*T_exercise/T+1,total_step+1,total_step*((T-T_exercise)/T)+1);
                                    y_list=zeros(1,total_step+1-total_step*T_exercise/T);
                                    for i=total_step*T_exercise/T+1:total_step+1    
                                        y=point(layer,i,Percentage,Nodes,max_time_node,U1,firm_tree_value,S1,k);
                                        y_list(1,i-total_step*T_exercise/T)=y;
                                    end
                                    plot(period,y_list,'o');
                                    xlabel('period'),ylabel('Stock price');
                                    if k==2
                                       ylabel('Firm value');
                                    end
                                    hold on
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
% legend('ESO');
legend('ESO','American call');
% legend('sigma1=0.2','sigma2=0.6','sigma3=1');

