function [wage_minError,CE_employee_minError,P_check,Q_check,minError_parameter] = binary_search_fixed_CE4_2(ESO_type,fixed_CE,searchTimes,threshold,previousWage_right,step_unit,V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,method,Div)

% minError_parameter �[�J TB BC

% ESO_type : 1, NQSO / 0,QSO
% fixed_CE : �T�w��CE
% searchTimes : �j�M����
% threshold : �]�w�A�ϱo�j�M�X�Ӫ����G abs(fixed_cost-ESO-Salary) < threshold
% previousWage_right : �ѩ�i�Ƴq�`�� N = 0 ~ MaxN 
% (�i�Ƥ֮�wage�@�w�����A���i�Ƥj�M��ɡAwage�|�U���A�ҥH�N���n���ƴM�� wage
% ���j���d��)
% ��l input �N�O Employee_Stock_Option3.m �� input (���Fwage�Btype_tax_employee���~)
% type_tax_employee �|�H�� ESO_type �۰ʽվ� 
% NQSO: type_tax_employee=1 / QSO: type_tax_employee=2;

t = 1/step_unit;

% ��X
% [�~�~ , �Ҧ�Employee_Stock_Option2.m �� output]
global wage_minError;
global minError_parameter;
global P_check;
global Q_check;
global CE_employee_minError;

if(ESO_type==1)
    % NQSO
    type_tax_employee=1;
    % wage�a0�A���T�{���n��ESO���W�L�`����
    wage = 0;
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option4(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    CE_employee=CE(0,r,Beta,t,Utility,0,gamma,step,tax_employee,0);
    if CE_employee>fixed_CE
        wage_minError = -1;
    else
        % �}�l�G���k�j�M
        % ��l�]�w
        left = 0; right = previousWage_right;
        middle=(left+right)/2;
        counter = 0;
        CE_employee=0; % ����i�J while �j��
        min=1000*fixed_CE;
        % �i�J�j��j�M
        while(abs(fixed_CE-CE_employee) > threshold && counter<searchTimes+1)
            % �H middle ��@ wage ����J
            wage = middle;
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option4(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            CE_employee=CE(middle,r,Beta,t,Utility,0,gamma,step,tax_employee,0);
            counter = counter + 1;
            error = fixed_CE-CE_employee;
            if(abs(error)<abs(min))
                min = error ;
                % ��X���G : ��J���~�~�B�j�M����(���Ƥj��]�w�N�i�H���D�j�M�~�t���j)�B�j�M�~�t�MEmployee_Stock_Option2.m�Ҧ�����X
                minError_parameter = [middle,counter,error,Equity,Debt,Stock,ESO,Salary,Utility,TB,BC];
                wage_minError = wage;
                P_check = sum( length(find(1<0))+length(find(P<0)) );
                Q_check = sum( length(find(1<0))+length(find(Q<0)) );
                CE_employee_minError = CE_employee;
            end
            % �]�w�U�������k��
            abs((fixed_CE-CE_employee));
            if((fixed_CE-CE_employee)>0)
                left = middle;
                middle=(left+right)/2;
            else
                right = middle;
                middle=(left+right)/2;
            end
            % ���k�ɤw�g�D�`����N���n���O�ɶ��j�M�F
            if(abs(left-right)<10e-5),break,end
        end
    end
else
    % QSO
    type_tax_employee=2;
    % wage�a0�A���T�{���n��ESO���W�L�`����
    wage = 0;
    [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO4(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
    CE_employee=CE(0,r,Beta,t,Utility,0,gamma,step,tax_employee,0);
    if CE_employee>fixed_CE
        wage_minError = -1;
    else
        % �}�l�G���k�j�M
        % ��l�]�w
        left = 0; right = previousWage_right;
        middle=(left+right)/2;
        counter = 0;
        CE_employee=0; % ����i�J while �j��
        min=1000*fixed_CE;
        % �i�J�j��j�M
        while(abs(fixed_CE-CE_employee) > threshold && counter<searchTimes+1)
            % �H middle ��@ wage ����J
            wage = middle;
            [Equity,Debt,Stock,ESO,Utility,alpha,P,Q,ESO_value,Stock_value,~,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option_ISO4(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta,w,tax_firm,percent,type_default,type_tax_employee,method,Div);
            CE_employee=CE(middle,r,Beta,t,Utility,0,gamma,step,tax_employee,0);
            counter = counter + 1;
            error = abs(fixed_CE-CE_employee);
            if(error<min)
                min = error ;
                % ��X���G : ��J���~�~�B�j�M����(���Ƥj��]�w�N�i�H���D�j�M�~�t���j)�B�j�M�~�t�MEmployee_Stock_Option2.m�Ҧ�����X
                minError_parameter = [middle,counter,error,Equity,Debt,Stock,ESO,Salary,Utility,TB,BC];
                wage_minError = wage; 
                P_check = sum( length(find(1<0))+length(find(P<0)) );
                Q_check = sum( length(find(1<0))+length(find(Q<0)) );
                CE_employee_minError = CE_employee;
            end
            % �]�w�U�������k��
            if((fixed_CE-CE_employee)>0)
                left = middle;
                middle=(left+right)/2;
            else
                right = middle;
                middle=(left+right)/2;
            end
            % ���k�ɤw�g�D�`����N���n���O�ɶ��j�M�F
            if(abs(left-right)<10e-5),break,end
        end
    end
end
