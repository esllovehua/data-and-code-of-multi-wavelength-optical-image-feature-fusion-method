function [y] = re_interpolation(x,R)              % 两点之间插几个
[m,n] = size(x);    % 获得图像
row = (m+R)/(1+R);          % 新图像行
col = (n+R)/(1+R);         % 新图像列
y = zeros(row,col); 
%---------------------定原有图像在新图像的位置
for i=1:row
    for j=1:col
        y(i,j) =  x((i-1)*(R+1)+1,(j-1)*(R+1)+1);  
    end
end
