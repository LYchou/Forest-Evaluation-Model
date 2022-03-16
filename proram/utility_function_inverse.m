function CE = utility_function_inverse(k,utility,utility_parameter)
    if(k==0)
        CE = utility^(1/utility_parameter);
    elseif(k==1)
        if(utility_parameter==1)
            CE = exp(utility);
        else
            CE = (utility*(1-utility_parameter))^(1/(1-utility_parameter));
        end
    else
        CE=-1;
    end
end