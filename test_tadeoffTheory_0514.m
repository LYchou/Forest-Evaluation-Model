mu=0.3;

[Equity,Debt,Stock,ESO,Utility2,alpha,P,Q,ESO_value,Stock_value,Equity_value,Debt_value,Utility_value,Dividend_value,Dividend,TB_value,BC_value,TB,BC,Salary_value,Salary,max_time_node,Nodes,firm_tree_value,default_boundary_value]=Employee_Stock_Option2(V,sigma,T,T_exercise,step,F,c,r,mu,X,N,O,wage,additional_wealth,gamma,tax_employee,Beta2,w,tax_firm,percent,type_default,type_tax_employee,method,Div);


[a,b,i_node,j] = size(ESO_value);
for A=1:a
    for B=1:b
        for I=1:i_node
            for J=1:j
                if(A<B)
                    
                else
                    V_t = firm_tree_value(I,J);
                    TB_t = TB_value(A,B,I,J);
                    BC_t = BC_value(A,B,I,J);
                    %
                    D_t = Debt_value(A,B,I,J);
                    E_t = Equity_value(A,B,I,J);
                    Salary_t = Salary_value(A,B,I,J);
                    ESO_t = ESO_value(A,B,I,J);
                    Div_t = Dividend_value(A,B,I,J);
                    left = V_t+TB_t-BC_t;
                    right = D_t+E_t+Salary_t+ESO_t+Div_t;
                    if(abs(left-right)>(10^(-3)))
                        disp(['left = ',num2str(left)]);
                        disp(['right = ',num2str(right)]);
                        %disp(['value = ',num2str(left)]);
                        disp(['a,b,i_node,j = ',num2str(A),',',num2str(B),',',num2str(I),',',num2str(J)]);
                        disp(' ')
                    end
                end
                
            end
        end
    end
end