function Expected_Value=expected_value(Pu,Pm,Pd,A,B,C,discount_rate,t)
    Expected_Value=(Pu*A+Pm*B+Pd*C)*exp(-discount_rate*t);
end