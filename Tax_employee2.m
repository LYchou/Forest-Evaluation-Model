 function [Wealth,excercise,max_tax_rate]=Tax_employee2(type,tax_employee,t,wage,additional_wealth,S,X,a_node,b,N,percent,Div,O)
%�p����u�~���J(�H���|)
% �P��Ӥ��P���O�A�^�ǳ̰���|�ŶZ���|�v
    Percentage=1/percent+1;
    %�p����u�i���᪺�����S
    Payoff=max(S-X,0);
    if Payoff>0
        excercise=true;
        Wealth= (wage+additional_wealth)*t + Payoff*( b - a_node )*N*percent + O*Div*t* (( b - a_node ) *N*percent/(O+b *N*percent));
    else
        excercise=false;
        Wealth=(wage+additional_wealth)*t; %���i�����������ѧQ
    end

    if type==0
        %���u���ݭn�ҵ|�ε|�v���`��------------------------------------------
        Wealth=(1-tax_employee)*Wealth;
    elseif type==1
        %���u�ݨ̷ӵ|���ŶZ�ҵ|----------------------------------------------
        threshold=[9525 38700 82500 157500 200000 500000];
%         threshold=threshold*10;
        rate=[0.1 0.12 0.22 0.24 0.32 0.35 0.37];
        aggregate=zeros(1,length(threshold));%�C�@�ŶZ���ֶi�|�v
        for i =1:length(threshold)
            if i==1
                aggregate(1,i)=threshold(i)*rate(i);
            else
            aggregate(1,i)=aggregate(1,i-1)+(threshold(i)-threshold(i-1))*rate(i);
            end
        end
        %�ֶi�|�v
        for i=1:length(threshold)
            if Wealth<threshold(i)*t
                break
            end
            if Wealth>threshold(length(threshold))*t
                i=i+1;
            end
        end
        if i==1
            Wealth=Wealth-Wealth*rate(i);   
        else
            Wealth=Wealth-aggregate(i-1)*t-(Wealth-threshold(i-1)*t)*rate(i);
        end
        max_tax_rate = rate(i);
        
    elseif type==2 %�~�����ֶi ESO��Capital gain tax

        Wealth=(wage+additional_wealth)*t;
        threshold=[9525 38700 82500 157500 200000 500000];
        rate=[0.1 0.12 0.22 0.24 0.32 0.35 0.37];
        aggregate=zeros(1,length(threshold));%�C�@�ŶZ���ֶi�|�v
        for i =1:length(threshold)
            if i==1
                aggregate(1,i)=threshold(i)*rate(i);
            else
            aggregate(1,i)=aggregate(1,i-1)+(threshold(i)-threshold(i-1))*rate(i);
            end
        end
        %�ֶi�|�v
        for i=1:length(threshold)
            if Wealth<threshold(i)*t
                break
            end
            if Wealth>threshold(length(threshold))*t
                i=i+1;
            end
        end
        if i==1
            Wealth=Wealth-Wealth*rate(i);   
        else
            Wealth=Wealth-aggregate(i-1)*t-(Wealth-threshold(i-1)*t)*rate(i);
        end
        max_tax_rate = rate(i);
        %ESO_payoff
        if Payoff>0
         Wealth1=( Payoff*( b - a_node )*N*percent )+ O*Div*t* (( b - a_node ) *N*percent/(O+b *N*percent));
         
            if Wealth1>434550*t
               Wealth1=Wealth1-(434550-39375)*t*0.15-(Wealth1-434550*t)*0.2;
            elseif Wealth1>39375*t && Wealth1<=434550*t
               Wealth1=Wealth1-(Wealth1-39375*t)*0.15 ;
            end    
      
          Wealth=Wealth+Wealth1;
        end
        
    elseif type==3 %�~�����ֶi ESO�K�|
          Wealth=(wage+additional_wealth)*t;
        threshold=[9525 38700 82500 157500 200000 500000];
        rate=[0.1 0.12 0.22 0.24 0.32 0.35 0.37];
        aggregate=zeros(1,length(threshold));%�C�@�ŶZ���ֶi�|�v
        for i =1:length(threshold)
            if i==1
                aggregate(1,i)=threshold(i)*rate(i);
            else
            aggregate(1,i)=aggregate(1,i-1)+(threshold(i)-threshold(i-1))*rate(i);
            end
        end
        %�ֶi�|�v
        for i=1:length(threshold)
            if Wealth<threshold(i)*t
                break
            end
            if Wealth>threshold(length(threshold))*t
                i=i+1;
            end
        end
        if i==1
            Wealth=Wealth-Wealth*rate(i);   
        else
            Wealth=Wealth-aggregate(i-1)*t-(Wealth-threshold(i-1)*t)*rate(i);
        end
        max_tax_rate = rate(i);
        %ESO_payoff
        if Payoff>0
            Wealth1=( Payoff*( b - a_node )*N*percent )+ O*Div*t* (( b - a_node ) *N*percent/(O+b *N*percent));

            Wealth1=(1-tax_employee)*Wealth1;
            Wealth=Wealth+Wealth1;
        end
    else %��L���p�A�ۦ�]�w ------------------------------------------------
    end
end