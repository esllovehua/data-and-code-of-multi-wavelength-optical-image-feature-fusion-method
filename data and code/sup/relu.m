function [y] = relu(x)
[m,n] = size(x);
y = zeros(m,n);
for i=1:m
    for j=1:n
        y(i,j) = max(x(i,j),0);
    end
end
