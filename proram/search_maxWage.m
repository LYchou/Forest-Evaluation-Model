function [maxWage] = search_maxWage(V,threshold,step,T,F,tax_firm,c,r)

% �ѩ�wage��J�Ӥj�A�|�ϱoDB�j����쩹�ᱵ���Ҧ��I�A�|�X���D�C
% ���קK���ơA�ڷj�M����쩹��@����DB�j�����겣���ȡA�Y�i�קK�����D�C

    type = 1;  % �ϥ� default_boundary_value ���Ũ��{�}�����
    wage = 0;
    while 1
        default_boundary_value=Default_boundary(type,step,T,F,tax_firm,c,r,wage);
        if(V-default_boundary_value(2)<0)
            break
        else
            maxWage = wage; % �sV-default_boundary_value(2)>0 �ɪ�wage
            wage = wage + threshold;
        end
    end
end