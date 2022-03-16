function utility = utility_function(k,utility_parameter,Wealth)
    % Jain 
    if(k==0)
        utility = Wealth^utility_parameter;
    end
    % Hall&Murphy (Stock Options for Undiversified Executives)
    % �]�O���Ѯv���ĥΨ�ƪ���k
    if(k==1)
        if(utility_parameter==1)
            utility = log(Wealth);
        else
            %  rho=1 utlity function
            utility = (1/(1-utility_parameter))*(Wealth^(1-utility_parameter));
        end
    end
end