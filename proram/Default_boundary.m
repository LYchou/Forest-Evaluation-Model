function default_boundary_value=Default_boundary(type,step,T,F,tax_firm,c,r,wage)
%破產邊界計算
    t=T/step;
    default_boundary_value=zeros(1,step+1);
    
    if type==0
        %破產邊界近似於零---------------------------------------------------
        default_boundary_value(:)=0.01;
    elseif type==1
        %債券折現破產函數---------------------------------------------------
        default_boundary_value(step+1)=F*(1+(1-tax_firm)*c*t)+(1-tax_firm)*(wage*t);
        for i=step:-1:2
            %計算每個時點的破產邊界
            default_boundary_value(i)=default_boundary_value(i+1)*exp(-r*t)+(1-tax_firm)*F*c*t+(1-tax_firm)*(wage*t);
        end
    elseif type==2
        % 每期薪水不 backward，只算在當期
        default_boundary_value(step+1)=F*(1+(1-tax_firm)*c*t);
        for i=step:-1:2
            %計算每個時點的破產邊界
            default_boundary_value(i)=default_boundary_value(i+1)*exp(-r*t)+(1-tax_firm)*F*c*t;
        end
        % 每一期加入當期要支付的薪水
        default_boundary_value(2:step+1) = default_boundary_value(2:step+1)+(1-tax_firm)*(wage*t);
            
    else
        %其他破產邊界函數，自行加入------------------------------------------
    end
end