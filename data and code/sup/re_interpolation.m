function [y] = re_interpolation(x,R)              % ����֮��弸��
[m,n] = size(x);    % ���ͼ��
row = (m+R)/(1+R);          % ��ͼ����
col = (n+R)/(1+R);         % ��ͼ����
y = zeros(row,col); 
%---------------------��ԭ��ͼ������ͼ���λ��
for i=1:row
    for j=1:col
        y(i,j) =  x((i-1)*(R+1)+1,(j-1)*(R+1)+1);  
    end
end
