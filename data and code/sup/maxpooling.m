function [y,x_record] = maxpooling(x,size_num,stride)
[m,n] = size(x);
m_new = ceil((m-size_num)/stride)+1;     %计算pooling后的大小
n_new = ceil((n-size_num)/stride)+1;
y = zeros(m_new ,n_new);
x_new = zeros(stride*(m_new-1)+size_num,stride*(n_new-1)+size_num);    %按照计算后的大小计算做pooling的矩阵大小，不够的补零
x_record = zeros(stride*(m_new-1)+size_num,stride*(n_new-1)+size_num);

for i = 1:m
    for j = 1:n
        x_new(i,j) = x(i,j);
    end
end

for i = 1:m_new
    for j = 1:n_new
        y(i,j) = max(max(x_new((i-1)*stride+1:(i-1)*stride+size_num,(j-1)*stride+1:(j-1)*stride+size_num)));
        x_record((i-1)*stride+1:(i-1)*stride+size_num,(j-1)*stride+1:(j-1)*stride+size_num) = x_new((i-1)*stride+1:(i-1)*stride+size_num,(j-1)*stride+1:(j-1)*stride+size_num)/y(i,j);
    end
end
