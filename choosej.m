function n=choosej(sigma,r,t,firm_value,default_value)
%��XB�I��m�A�p��겣���Ȭ۹��}����ɴX�Ө⭿sigma�ڸ�t
    firm_value=firm_value*exp(r*t);
    n=round( log(firm_value/default_value) / (2*sigma*sqrt(t)) );
end