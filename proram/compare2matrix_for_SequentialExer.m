function matrix2_adj = compare2matrix_for_SequentialExer(matrix1,matrix2)

[n1,n2] = size(matrix1);
matrix2_adj = matrix2;
for i =1:n1
    for j =1:n2
        if(matrix1(i,j)==0)
            matrix2_adj(i,j) = 0;
        end
    end
end
end

