function [maxDB_ratio,t,default_boundary_value] = find_maxDBdiff(type_default,t,T,F,tax_firm,c,r,wage)

step_unit=floor(1/t);
%t=1/step_unit;
step=T*step_unit;
default_boundary_value=Default_boundary(type_default,step,T,F,tax_firm,c,r,wage);

%假定DB隨著時間越來越小
%找到 DB_t - DB_t1 最大的case
maxDB_ratio = 0;
for i=2:length(default_boundary_value)-1
    DB = default_boundary_value(i);
    DB_next = default_boundary_value(i+1);
    if((DB-DB_next)>maxDB_ratio)
        maxDB_ratio=DB/DB_next;
    end
end