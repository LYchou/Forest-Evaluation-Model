 function [Wealth,excercise,max_tax_rate]=Tax_employee2(type,tax_employee,t,wage,additional_wealth,S,X,a_node,b,N,percent,Div,O)
%計算員工年收入(以扣稅)
% 與原來不同的是，回傳最高賦稅級距的稅率
    Percentage=1/percent+1;
    %計算員工履約後的單位報酬
    Payoff=max(S-X,0);
    if Payoff>0
        excercise=true;
        Wealth= (wage+additional_wealth)*t + Payoff*( b - a_node )*N*percent + O*Div*t* (( b - a_node ) *N*percent/(O+b *N*percent));
    else
        excercise=false;
        Wealth=(wage+additional_wealth)*t; %不履約拿不到當期股利
    end

    if type==0
        %員工不需要課稅或稅率為常數------------------------------------------
        Wealth=(1-tax_employee)*Wealth;
    elseif type==1
        %員工需依照稅的級距課稅----------------------------------------------
        threshold=[9525 38700 82500 157500 200000 500000];
%         threshold=threshold*10;
        rate=[0.1 0.12 0.22 0.24 0.32 0.35 0.37];
        aggregate=zeros(1,length(threshold));%每一級距的累進稅率
        for i =1:length(threshold)
            if i==1
                aggregate(1,i)=threshold(i)*rate(i);
            else
            aggregate(1,i)=aggregate(1,i-1)+(threshold(i)-threshold(i-1))*rate(i);
            end
        end
        %累進稅率
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
        
    elseif type==2 %薪水為累進 ESO為Capital gain tax

        Wealth=(wage+additional_wealth)*t;
        threshold=[9525 38700 82500 157500 200000 500000];
        rate=[0.1 0.12 0.22 0.24 0.32 0.35 0.37];
        aggregate=zeros(1,length(threshold));%每一級距的累進稅率
        for i =1:length(threshold)
            if i==1
                aggregate(1,i)=threshold(i)*rate(i);
            else
            aggregate(1,i)=aggregate(1,i-1)+(threshold(i)-threshold(i-1))*rate(i);
            end
        end
        %累進稅率
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
        
    elseif type==3 %薪水為累進 ESO免稅
          Wealth=(wage+additional_wealth)*t;
        threshold=[9525 38700 82500 157500 200000 500000];
        rate=[0.1 0.12 0.22 0.24 0.32 0.35 0.37];
        aggregate=zeros(1,length(threshold));%每一級距的累進稅率
        for i =1:length(threshold)
            if i==1
                aggregate(1,i)=threshold(i)*rate(i);
            else
            aggregate(1,i)=aggregate(1,i-1)+(threshold(i)-threshold(i-1))*rate(i);
            end
        end
        %累進稅率
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
    else %其他情況，自行設定 ------------------------------------------------
    end
end