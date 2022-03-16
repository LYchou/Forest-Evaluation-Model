function CE_employee= CE(wage,r,Beta,t,Utility,Utility_no_ESO,gamma,step_unit,tax_employee,k)
%計算Certainty Equivalent
   if k==0%jain的效用函數的法
       if(Beta==0)
       payment_per = ((Utility/step_unit)^(1/gamma))-((Utility_no_ESO/step_unit)^(1/gamma));
       else    
       payment_per=((Utility*(1-exp(-Beta*t))/(1-exp(-Beta*t*step_unit))))^(1/gamma)-((Utility_no_ESO*(1-exp(-Beta*t))/(1-exp(-Beta*t*step_unit))))^(1/gamma);
       %只折現到第1期而已
       end
       CE_employee = payment_per*(1-exp(-r*t*step_unit))/(1-exp(-r*t));
   elseif k==1%黃老師的效用函數的算法
       if Utility_no_ESO==0
           if(Beta==0)
               payment_per = (((Utility/step_unit)*(1-gamma))^(1/(1-gamma)));
               else    
               payment_per=(((Utility*(1-exp(-Beta*t))/(1-exp(-Beta*t*step_unit))))*(1-gamma))^(1/(1-gamma));
           end       
       else
           if(Beta==0)
                   payment_per = (((Utility/step_unit)*(1-gamma))^(1/(1-gamma)))-(((Utility_no_ESO/step_unit)*(1-gamma))^(1/(1-gamma)));
           else    
                   payment_per=(((Utility*(1-exp(-Beta*t))/(1-exp(-Beta*t*step_unit))))*(1-gamma))^(1/(1-gamma))-(((Utility_no_ESO*(1-exp(-Beta*t))/(1-exp(-Beta*t*step_unit))))*(1-gamma))^(1/(1-gamma));
           end
       end
       CE_employee = payment_per*(1-exp(-r*t*step_unit))/(1-exp(-r*t));
           
   end
   
   
       
end