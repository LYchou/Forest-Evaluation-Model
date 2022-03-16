clc
clear
%固定變數------------------------

w=0.4296;tax_firm=0.21;%w是BC tax_firm是公司稅率
type_default=1;

V=[9.91e9 ];%公司資產價值
F=V*0.18;c=0.078;r=0.06;
mu=0.125;
X=8e6;%履約價
O=1000; %原始股票張數
T=10;%到期日
Div=0;
T_exercise=3;
% wage=670000;%年薪
method=1;
tax_employee=0; 
percent=[0.5];%履約間距
Beta=0.125;
additional_wealth=0;
N=linspace(0,7,8);%履約張數 從0~7

result1=[];
step_unit=4;

step=T*step_unit;
t=1/step_unit;
total_step=step;

Total_CE=[52421244.4442340];
% 固定員工感受度(certainty equivalence)的值為 52421244.4442340，此價
% 值是在認股權張數為 7 張且 gamma=1(風險中立)時，QSO 計算出來認股權和
% 薪水(年薪:670,000，取材自 Otto(2014))對員工的總感受度，以 gamma=1
% 作為基礎是因為相同感受度及相同條件下，風險趨避的員工需要的薪水會比風
% 險中立的員工需要的多，這樣就能確保所有情況下對應到的薪水不為負值。


% NQSO=[1 2];%1代表NQSO 2是QSO
sigma=0.3;gamma=[0.2 0.5 0.7 0.9];

% NQSO
type_tax_employee=1;%type_tax_employee=1是Progressive tax =2是capital gain tax

result=[];
position=[];
for list_2=1:length(gamma)
    for list_3=1:2 
        left=0;
        previousWage=2e7;
        right=previousWage;
        for list_1=1:length(N)
            N(list_1)
            % 二分法搜尋 調整wage找到固定CE
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
                    type_tax_employee=1;%type_tax_employee=1是Progressive tax =2是capital gain tax
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
                    %儲存要的資料

                end
                %二分法跌帶下一次的值
                if error<0 %要提高CE所以增加wage
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




