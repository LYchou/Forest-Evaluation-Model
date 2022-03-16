function [alpha_u,alpha_m,alpha_d]=optimal_alpha(value_u,value_m,value_d,next_time_a_node)
    alpha_u=min(find(value_u==max(value_u)))+next_time_a_node-1;
    alpha_m=min(find(value_m==max(value_m)))+next_time_a_node-1;
    alpha_d=min(find(value_d==max(value_d)))+next_time_a_node-1;
    
    
%     alpha_u=max(find(value_u==max(value_u)))+next_time_a_node-1;
%     alpha_m=max(find(value_m==max(value_m)))+next_time_a_node-1;
%     alpha_d=max(find(value_d==max(value_d)))+next_time_a_node-1;
end