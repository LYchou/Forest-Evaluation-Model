function [wage_minError,ESO_minError,Salary_minError,minError_parameter] = binary_search_fixed_cost(ESO_type,fixed_cost,searchTimes,threshold,previousWage_right,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div)

% ESO_type : 1,NQSO / 0,QSO
% fixed_cost : �T�w������
% searchTimes : �j�M����
% threshold : �]�w�A�ϱo�j�M�X�Ӫ����G abs(fixed_cost-ESO-Salary) < threshold
% previousWage_right : �ѩ�i�Ƴq�`�� N = 0 ~ MaxN 
% (�i�Ƥ֮�wage�@�w�����A���i�Ƥj�M��ɡAwage�|�U���A�ҥH�N���n���ƴM�� wage
% ���j���d��)
% ��l input �N�O Employee_Stock_Option2.m �� input (���Fwage�Btype_tax_employee���~)
% type_tax_employee �|�H�� ESO_type �۰ʽվ� 
% NQSO: type_tax_employee=1 / QSO: type_tax_employee=2;

% ��X
% [�~�~ , �Ҧ�Employee_Stock_Option2.m �� output]
global wage_minError;
global ESO_minError;
global Salary_minError;
global minError_parameter;

if(ESO_type)
    % NQSO
    type_tax_employee=1;
    % wage�a0�A���T�{���n��ESO���W�L�`����
    wage = 0;
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    if((ESO+Salary)>fixed_cost)
        wage_minError = -1;
        ESO_minError = 0; Salary_minError = 0;
    else
        % �}�l�G���k�j�M
        % ��l�]�w
        left = 0; right = previousWage_right;
        middle=(left+right)/2;
        counter = 0;
        ESO = fixed_cost; Salary = fixed_cost; % ����i�J while �j��
        min = fixed_cost+1 ;
        % �i�J�j��j�M
        while(abs(fixed_cost-ESO-Salary) > threshold && counter<searchTimes+1)
            % �H middle ��@ wage ����J
            wage = middle;
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            counter = counter + 1;
            error = abs(fixed_cost-ESO-Salary);
            if(error<min)
                min = error ;
                % ��X���G : ��J���~�~�B�j�M����(���Ƥj��]�w�N�i�H���D�j�M�~�t���j)�B�j�M�~�t�MEmployee_Stock_Option2.m�Ҧ�����X
                minError_parameter = [middle,counter,error,Equity,Debt,Stock,ESO,Salary,Utility];
                ESO_minError = ESO; 
                Salary_minError = Salary;
                wage_minError = wage;
            end
            % �]�w�U�������k��
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
    % wage�a0�A���T�{���n��ESO���W�L�`����
    wage = 0;
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    if((ESO+Salary)>fixed_cost)
        wage_minError = -1;
        ESO_minError = 0; Salary_minError = 0;
    else
        % �}�l�G���k�j�M
        % ��l�]�w
        left = 0; right = previousWage_right;
        middle=(left+right)/2;
        counter = 0;
        ESO = fixed_cost; Salary = fixed_cost; % ����i�J while �j��
        min = fixed_cost+1 ;
        % �i�J�j��j�M
        while(abs(fixed_cost-ESO-Salary) > threshold && counter<searchTimes+1)
            % �H middle ��@ wage ����J
            wage = middle;
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            counter = counter + 1;
            error = abs(fixed_cost-ESO-Salary);
            if(error<min)
                min = error ;
                % ��X���G : ��J���~�~�B�j�M����(���Ƥj��]�w�N�i�H���D�j�M�~�t���j)�B�j�M�~�t�MEmployee_Stock_Option2.m�Ҧ�����X
                minError_parameter = [middle,counter,error,Equity,Debt,Stock,ESO,Salary,Utility];
                ESO_minError = ESO; 
                Salary_minError = Salary;
                wage_minError = wage;
            end
            % �]�w�U�������k��
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
