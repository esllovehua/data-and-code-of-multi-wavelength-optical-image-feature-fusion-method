function [y] = mutiwave_fusion(x1,x2)
num = 7;
x_fusion = {};
x_fusion{1,1} = 0.5*x1{1,1}+0.5*x2{1,1};
for i = 2:num
    x_fusion{1,i} = D_fusion(x1{1,i},x2{1,i});
end
y = x_fusion;
end




