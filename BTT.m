 function [Pu,Pm,Pd,n]=BTT(sigma,r,mu,t,V_t,default_value)

    %方法一----------------------------------------------------------------
%     n=choosej(sigma,r,t,V_t,default_value);
%     V_B=default_value*exp(2*sigma*sqrt(t)*n);
%     mu_hat=log(V_B/V_t);
% %     mu=(r-0.5*sigma^2)*t;
%     mu=(mu-0.5*sigma^2)*t;
%     Var=sigma^2*t;
%     
%     beta_value=mu_hat-mu;
%     alpha_value=beta_value+2*sigma*sqrt(t);
%     gamma_value=beta_value-2*sigma*sqrt(t);
%     
%     det=(beta_value-alpha_value)*(gamma_value-beta_value)*(gamma_value-alpha_value);
%     det_u=(beta_value*gamma_value+Var)*(gamma_value-beta_value);
%     det_m=(alpha_value*gamma_value+Var)*(alpha_value-gamma_value);
%     det_d=(alpha_value*beta_value+Var)*(beta_value-alpha_value);
%     
%     Pu=det_u/det;
%     Pm=det_m/det;
%     Pd=det_d/det;
    

    %方法二----------------------------------------------------------------
%     n=choosej(sigma,r,t,V_t,default_value);
%     V_B=default_value*exp(2*sigma*sqrt(t)*n);
%     mu_hat=log(V_B/V_t);
%     mu=(r-0.5*sigma^2)*t;
%     Var=sigma^2*t;
%     
%     beta_value=mu_hat-mu;
%     alpha_value=beta_value+2*sigma*sqrt(t);
%     gamma_value=beta_value-2*sigma*sqrt(t);
%     syms Pu Pm Pd
%     eqns =[ Pu * alpha_value     + Pm * beta_value     + Pd * gamma_value   == 0
%             Pu * alpha_value^2   + Pm * beta_value^2   + Pd * gamma_value^2 == Var
%             Pu                   + Pm                  + Pd                 == 1       ];
%     vars = [Pu Pm Pd];
%     S=solve(eqns,vars);
%     Pu=double(S.Pu);
%     Pm=double(S.Pm);
%     Pd=double(S.Pd);
    

    %方法三----------------------------------------------------------------
%     n=choosej(sigma,r,t,V_t,default_value);
%     V_B=default_value*exp(2*sigma*sqrt(t)*n);
%     mu_hat=log(V_B/V_t);
%     mu=(r-0.5*sigma^2)*t;
%     Var=sigma^2*t;
%     
%     beta_value=mu_hat-mu;
%     alpha_value=beta_value+2*sigma*sqrt(t);
%     gamma_value=beta_value-2*sigma*sqrt(t);
%     det_value =[alpha_value     , beta_value     , gamma_value   
%                 alpha_value^2   , beta_value^2   , gamma_value^2 
%                 1               , 1              , 1            ];
%     det_right=[0;Var;1];det_ans=zeros(1,3);
%     for i=1:3
%         det_left=det_value;
%         det_left(:,i)=det_right;
%         det_ans(i)=det(det_left)/det(det_value);
%     end
%     Pu=det_ans(1);
%     Pm=det_ans(2);
%     Pd=det_ans(3);
    

    %方法四----------------------------------------------------------------
    %資產節點值--------------------------------
%     n=choosej(sigma,r,t,V_t,default_value);
%     u=exp(sigma*sqrt(t));
%     Vm=default_value*u^(2*n);
%     Vu=default_value*u^(2*n+1);
%     Vd=default_value*u^(2*n-1);
%     %平均值-----------------------------------
%     V_rf=V_t*exp(r*t);
%     %聯立方程式--------------------------------
%     syms Pu Pm Pd
%     eqns =[ Pu*(Vu-V_rf)   + Pm*(Vm-V_rf)   + Pd*(Vd-V_rf)   == 0
%             Pu*(Vu-V_rf)^2 + Pm*(Vm-V_rf)^2 + Pd*(Vd-V_rf)^2 == V_t^2*exp(2*r*t)*(exp(sigma^2*t)-1)
%             Pu             + Pm             + Pd             == 1                                   ];
%     vars = [Pu Pm Pd];
%     S=solve(eqns,vars);
%     Pu=double(S.Pu);
%     Pm=double(S.Pm);
%     Pd=double(S.Pd);
    

    %方法五----------------------------------------------------------------
    %資產節點值--------------------------------
    n=choosej(sigma, r,t,V_t,default_value);
    u=exp(sigma*sqrt(t));
    Vm=default_value*u^(2*n);
    Vu=default_value*u^(2*(n+1));
    Vd=default_value*u^(2*(n-1));
    %平均值-----------------------------------
    V_rf=V_t*exp(mu*t);
    det_value =[ Vu-V_rf       , Vm-V_rf       , Vd-V_rf
                 (Vu-V_rf)^2   , (Vm-V_rf)^2   , (Vd-V_rf)^2  
                 1             , 1             , 1            ];
    det_right=[0;V_t^2*exp(2*mu*t)*(exp(sigma^2*t)-1);1];
    det_ans=zeros(1,3);
    for i=1:3
        det_left=det_value;
        det_left(:,i)=det_right;
        det_ans(i)=det(det_left)/det(det_value);
    end
    Pu=det_ans(1);
    Pm=det_ans(2);
    Pd=det_ans(3);
   
   
end