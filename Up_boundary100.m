function [up_boundary_value,nodes]=Up_boundary100(step,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N,percent)
%�v�T�겣����D������ sigma,X,N,percent
%����u�M�wū�^������V�j�A�����i��ϱo�겣����D�ɤ��I�ܦh
%�e���O���D���T�ץ����j��2*sigma*sqrt(t)

%�W�ɭp��
    t=T/step;
    up_boundary_value=zeros(1,step+1);
    nodes=zeros(1,step+1);
    if sum(size(firm_value))==2 %�b0%��
        %ESO���i�����̤U�h��------------------------------------------------
        up_boundary_value(1)=firm_value;
        nodes(1)=1;
        for i=2:step+1
            %n��B�I���`�I�M�}����ɪ��Z���O�X��
            n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
            %�̤W�ɪ��`�I(A�I)�ܯ}����ɪ��Z��
            up_boundary_value(i)=exp( log(default_boundary_value(i))+(n+1)*2*sigma*sqrt(t) );
            %�겣�W�ɨ�U�ɪ��`�I��
            nodes(i)=n+2;
        end
    else %�b0%�H�W��
        %ESO�w�i���L����L�h��----------------------------------------------
        for i=step*T_exercise/T+1:step+1
            %�^���Ӯɶ��I�겣���W��
            firm_jump=firm_value(:,i);
            %�p�⤣�P�h�겣�𩹤W���D�ɡA�|���쪺��m�����j��
            %firm_jump=firm_jump + (1:length(firm_jump))' *X*N*percent;
            firm_jump=firm_jump + (1:length(firm_jump))' *X*N;
            firm_jump=max(firm_jump*2);
            %�p��겣���D���`�I���W��
            if default_boundary_value(i)==0
                n_jump=0;
            else
                %���Ӥ��Υ�r�����A�]���O��ۤv�P����default_Boudary��
                n_jump=choosej(sigma,0,t,firm_jump,default_boundary_value(i)); 
            end
            if i==step*T_exercise/T+1
                %�k�ݤ�ȦҼ{�겣���D�`�I�����D------------------------------
                n=n_jump;
            else
                %���ȦҼ{�겣���D�٦�BTT�T������䱵�I-----------------------
                %n��B�I���`�I�M�}����ɪ��Z���O�X��
                n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
                %����겣����D���`�I�MA�I���`�I�֤j
                n=max(n+1,n_jump);                
            end  
            up_boundary_value(i)=exp( log(default_boundary_value(i))+n*2*sigma*sqrt(t) );
            nodes(i)=n+1;
        end
    end
end