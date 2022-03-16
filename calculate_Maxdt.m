function Maxdt = calculate_Maxdt(r,mu,sigma,wage,F,c,tax_firm,T,type_default,threshold_ratio)
%t=1/step_unit(一期的時間長度(年))
%r=無風險利率
%mu=公司資產價值報酬率(%)
%sigma=公司資產價值標準差(%)
%wage=員工薪資(年)
%F=債券面額
%c=債券債息率
%tax_firm=公司稅率
%T=債券到期日
%type_default(柏泓設定一般都是1)
%threshold_ratio=二分法搜尋的誤差的比率(為dt=1位差的ratio)

%先驗證dt=1時middle point是否沒有問題
t=1;
[maxDB_ratio,~] = find_maxDBratio(type_default,t,T,F,tax_firm,c,r,wage);
error=log(maxDB_ratio)+mu*t-sigma*sqrt(t);
threshold=threshold_ratio*error;
if((log(maxDB_ratio)+mu*t)<sigma*sqrt(t))
    Maxdt=t;
else
    %dt需要比1小
    error = log(maxDB_ratio)+mu*t-sigma*sqrt(t); %t=1
    left_t=0;
    right_t=1;
    middle_t = (left_t+right_t)/2;
    count=0;
    % 繼續搜尋的條件(目標找到最大的dt，並且middle point沒有問題):
    % abs(error)>threshold (避免dt太小)
    % 不滿足這條式子: max_LnDBdiff + mu*t < sigma*qrt(dt) ，初始進入while是t=1
    while((abs(error)>threshold ||error>0)&&(count<100))
        count = count+1;
        t = middle_t;
        [maxDB_ratio,t_adj,~] = find_maxDBratio(type_default,t,T,F,tax_firm,c,r,wage);
        t = t_adj;
        error = log(maxDB_ratio)+mu*t-sigma*sqrt(t);
        disp(['count=',num2str(count),' , t=',num2str(t),' , error=',num2str(error)]);
        % 下次迭帶設定
        if(error>0)
           right_t = middle_t;
        else
           left_t = middle_t;
        end
        middle_t = (left_t+right_t)/2;
    end
    if(count<100)
        Maxdt=t;
    else
        Maxdt=0;
    end
end
