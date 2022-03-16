function n=choosej(sigma,r,t,firm_value,default_value)
%找出B點位置，計算資產價值相對於破產邊界幾個兩倍sigma根號t
    firm_value=firm_value*exp(r*t);
    n=round( log(firm_value/default_value) / (2*sigma*sqrt(t)) );
end