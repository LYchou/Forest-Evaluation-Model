function [maxWage] = search_maxWage(V,threshold,step,T,F,tax_firm,c,r)

% 由於wage輸入太大，會使得DB大於期初往後接的所有點，會出問題。
% 為避免此事，我搜尋到期初往後一期的DB大於期初資產價值，即可避免此問題。

    type = 1;  % 使用 default_boundary_value 中債券折現破產函數
    wage = 0;
    while 1
        default_boundary_value=Default_boundary(type,step,T,F,tax_firm,c,r,wage);
        if(V-default_boundary_value(2)<0)
            break
        else
            maxWage = wage; % 存V-default_boundary_value(2)>0 時的wage
            wage = wage + threshold;
        end
    end
end