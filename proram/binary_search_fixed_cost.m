function [wage_minError,ESO_minError,Salary_minError,minError_parameter] = binary_search_fixed_cost(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div)

% ESO_type : 1,NQSO / 0,QSO
% fixed_cost : 固定的成本
% searchTimes : 搜尋次數
% threshold : 設定，使得搜尋出來的結果 abs(fixed_cost-ESO-Salary) < threshold
% previousWage_right : 由於張數通常由 N = 0 ~ MaxN 
% (張數少時wage一定較高，往張數大尋找時，wage會下降，所以就不要重複尋找 wage
% 較大的範圍)
% 其餘 input 就是 Employee_Stock_Option2.m 的 input (除了wage、type_tax_employee之外)
% type_tax_employee 會隨著 ESO_type 自動調整 
% NQSO: type_tax_employee=1 / QSO: type_tax_employee=2;

% 輸出
% [年薪 , 所有Employee_Stock_Option2.m 的 output]
global wage_minError;
global ESO_minError;
global Salary_minError;
global minError_parameter;

if(ESO_type)
    % NQSO
    type_tax_employee=1;
    % wage帶0，先確認不要光ESO較超過總成本
    wage = 0;
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    if((ESO+Salary)>fixed_cost)
        wage_minError = -1;
        ESO_minError = 0; Salary_minError = 0;
    else
        % 開始二分法搜尋
        % 初始設定
        left = 0; right = previousWage_right;
        middle=(left+right)/2;
        counter = 0;
        ESO = fixed_cost; Salary = fixed_cost; % 讓其進入 while 迴圈
        min = fixed_cost+1 ;
        % 進入迴圈搜尋
        while(abs(fixed_cost-ESO-Salary) > threshold && counter<searchTimes+1)
            % 以 middle 當作 wage 的輸入
            wage = middle;
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            counter = counter + 1;
            error = abs(fixed_cost-ESO-Salary);
            if(error<min)
                min = error ;
                % 輸出結果 : 輸入的年薪、搜尋次數(當次數大於設定就可以知道搜尋誤差較大)、搜尋誤差和Employee_Stock_Option2.m所有的輸出
                minError_parameter = [middle,counter,error,Equity,Debt,Stock,ESO,Salary,Utility];
                ESO_minError = ESO; 
                Salary_minError = Salary;
                wage_minError = wage;
            end
            % 設定下次的左右界
            if((fixed_cost-ESO-Salary)>0)
                left = middle;
                middle=(left+right)/2;
            else
                right = middle;
                middle=(left+right)/2;
            end
        end
    end
else
    % QSO
    type_tax_employee=2;
    % wage帶0，先確認不要光ESO較超過總成本
    wage = 0;
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    if((ESO+Salary)>fixed_cost)
        wage_minError = -1;
        ESO_minError = 0; Salary_minError = 0;
    else
        % 開始二分法搜尋
        % 初始設定
        left = 0; right = previousWage_right;
        middle=(left+right)/2;
        counter = 0;
        ESO = fixed_cost; Salary = fixed_cost; % 讓其進入 while 迴圈
        min = fixed_cost+1 ;
        % 進入迴圈搜尋
        while(abs(fixed_cost-ESO-Salary) > threshold && counter<searchTimes+1)
            % 以 middle 當作 wage 的輸入
            wage = middle;
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            counter = counter + 1;
            error = abs(fixed_cost-ESO-Salary);
            if(error<min)
                min = error ;
                % 輸出結果 : 輸入的年薪、搜尋次數(當次數大於設定就可以知道搜尋誤差較大)、搜尋誤差和Employee_Stock_Option2.m所有的輸出
                minError_parameter = [middle,counter,error,Equity,Debt,Stock,ESO,Salary,Utility];
                ESO_minError = ESO; 
                Salary_minError = Salary;
                wage_minError = wage;
            end
            % 設定下次的左右界
            if((fixed_cost-ESO-Salary)>0)
                left = middle;
                middle=(left+right)/2;
            else
                right = middle;
                middle=(left+right)/2;
            end
        end
    end
end
