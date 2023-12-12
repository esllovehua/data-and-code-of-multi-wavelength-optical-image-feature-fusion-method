function [y] = BN_255(x)
[m,n] = size(x);
y = zeros(m,n);
max_num = max(max(x));
for i=1:m
    for j=1:n
        if x(i,j)>0
            y(i,j) = x(i,j)*255/max_num;
        else
            y(i,j) = 0;
        end
    end
end
        
