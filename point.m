function value=point(layer,j,Percentage,Nodes,max_time_node,Utility_value,firm_tree_value,Stock_value,k)
% layer=1¬O²Ä¤@¼h
    layer_node=Percentage-layer+1;
    for i=1:Nodes(layer_node,j) 
        i_node=max(max_time_node)+1-i;
        if Utility_value(layer_node,layer,i_node,j)- max(Utility_value(layer_node,layer:Percentage,i_node,j))<-0.000001
           break;
        end
    end
    %     value=firm_tree_value(i_node,j);
    if k==1
          value=Stock_value(layer_node,layer,i_node,j);
    elseif k==2
          value=firm_tree_value(i_node,j);
    end
end
