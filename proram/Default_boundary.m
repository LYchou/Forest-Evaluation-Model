function default_boundary_value=Default_boundary(type,step,T,F,tax_firm,c,r,wage)
%�}����ɭp��
    t=T/step;
    default_boundary_value=zeros(1,step+1);
    
    if type==0
        %�}����ɪ����s---------------------------------------------------
        default_boundary_value(:)=0.01;
    elseif type==1
        %�Ũ��{�}�����---------------------------------------------------
        default_boundary_value(step+1)=F*(1+(1-tax_firm)*c*t)+(1-tax_firm)*(wage*t);
        for i=step:-1:2
            %�p��C�Ӯ��I���}�����
            default_boundary_value(i)=default_boundary_value(i+1)*exp(-r*t)+(1-tax_firm)*F*c*t+(1-tax_firm)*(wage*t);
        end
    elseif type==2
        % �C���~���� backward�A�u��b���
        default_boundary_value(step+1)=F*(1+(1-tax_firm)*c*t);
        for i=step:-1:2
            %�p��C�Ӯ��I���}�����
            default_boundary_value(i)=default_boundary_value(i+1)*exp(-r*t)+(1-tax_firm)*F*c*t;
        end
        % �C�@���[�J����n��I���~��
        default_boundary_value(2:step+1) = default_boundary_value(2:step+1)+(1-tax_firm)*(wage*t);
            
    else
        %��L�}����ɨ�ơA�ۦ�[�J------------------------------------------
    end
end