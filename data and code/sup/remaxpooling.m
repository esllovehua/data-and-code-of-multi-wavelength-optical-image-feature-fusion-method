function [y] = remaxpooling(x,size_num,stride,record_data)
[m,n] = size(x);
for i = 1:m
    for j = 1:n
        record_data((i-1)*stride+1:(i-1)*stride+size_num,(j-1)*stride+1:(j-1)*stride+size_num)=record_data((i-1)*stride+1:(i-1)*stride+size_num,(j-1)*stride+1:(j-1)*stride+size_num)*x(i,j);
    end
end
y = record_data;

