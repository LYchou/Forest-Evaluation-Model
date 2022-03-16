function [firm_tree_value,max_time_node]=Firm_tree_value(V,sigma,step,t,default_boundary_value,Nodes)
%建立資產樹價值
    %資產樹每個時點的最大節點
    max_time_node=max(Nodes);
    %計算時點中的最大節點
    max_node=max(max_time_node);
    
    default_boundary_value=log(default_boundary_value);
    firm_tree_value=zeros(max_node,step+1);
    firm_tree_value(max_node,1)=V;
    for i=2:step+1
        firm_value=exp( default_boundary_value(i)+ ( 0:(max_time_node(i)-1) )*2*sigma*sqrt(t) );
        firm_tree_value(max_node-max_time_node(i)+1:max_node,i)=sort(firm_value,'descend')';
    end
end