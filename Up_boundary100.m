function [up_boundary_value,nodes]=Up_boundary100(step,r,sigma,T,T_exercise,firm_value,default_boundary_value,X,N,percent)
%影響資產樹跳躍的關鍵 sigma,X,N,percent
%當員工決定贖回的部位越大，較有可能使得資產樹跳躍時支點變多
%前提是跳躍的幅度必須大於2*sigma*sqrt(t)

%上界計算
    t=T/step;
    up_boundary_value=zeros(1,step+1);
    nodes=zeros(1,step+1);
    if sum(size(firm_value))==2 %在0%時
        %ESO未履約的最下層樹------------------------------------------------
        up_boundary_value(1)=firm_value;
        nodes(1)=1;
        for i=2:step+1
            %n為B點的節點和破產邊界的距離是幾倍
            n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
            %最上界的節點(A點)至破產邊界的距離
            up_boundary_value(i)=exp( log(default_boundary_value(i))+(n+1)*2*sigma*sqrt(t) );
            %資產上界到下界的節點數
            nodes(i)=n+2;
        end
    else %在0%以上樹
        %ESO已履約過的其他層樹----------------------------------------------
        for i=step*T_exercise/T+1:step+1
            %擷取該時間點資產的上界
            firm_jump=firm_value(:,i);
            %計算不同層資產樹往上跳躍時，會跳到的位置的極大值
            %firm_jump=firm_jump + (1:length(firm_jump))' *X*N*percent;
            firm_jump=firm_jump + (1:length(firm_jump))' *X*N;
            firm_jump=max(firm_jump*2);
            %計算資產跳躍的節點的上界
            if default_boundary_value(i)==0
                n_jump=0;
            else
                %應該不用用r成長，因為是跟自己同期的default_Boudary比
                n_jump=choosej(sigma,0,t,firm_jump,default_boundary_value(i)); 
            end
            if i==step*T_exercise/T+1
                %歸屬日僅考慮資產跳躍節點的問題------------------------------
                n=n_jump;
            else
                %不僅考慮資產跳躍還有BTT三元樹分支接點-----------------------
                %n為B點的節點和破產邊界的距離是幾倍
                n=choosej(sigma,r,t,up_boundary_value(i-1),default_boundary_value(i));
                %比較資產樹跳躍的節點和A點的節點誰大
                n=max(n+1,n_jump);                
            end  
            up_boundary_value(i)=exp( log(default_boundary_value(i))+n*2*sigma*sqrt(t) );
            nodes(i)=n+1;
        end
    end
end