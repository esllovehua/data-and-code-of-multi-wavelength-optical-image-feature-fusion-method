function [y] = bicubic_interpolation(x,R)              % R两点之间插几个
% clear
% clc
% load('test.mat')
% R = 10;
[m,n] = size(x);    % 获得图像
row = m+(m-1)*R;          % 新图像行
col = n+(n-1)*R;          % 新图像列
dx = zeros(m,n);
dy = zeros(m,n);
dxy = zeros(m,n);
Chunking = cell(m-1,n-1);
Chunking_dx = cell(m-1,n-1);
Chunking_dy = cell(m-1,n-1);
Chunking_dxy = cell(m-1,n-1);
coefficient_k = cell(m-1,n-1);
coefficient_c = cell(m-1,n-1);
coefficient_xy = cell(row,col);
y = zeros(row,col); 
%_____________________偏x
for i =1:m
    dx(i,1) = x(i,1)-(2*x(i,1)-x(i,2));
    dx(i,n) = 2*x(i,n)-x(i,n-1)-x(i,n);
end

 for i = 1:m
     for j = 2:n-1
         dx(i,j) = x(i,j+1)-x(i,j);
     end
 end
%_____________________偏y
 for i =1:n
    dy(1,i) = x(1,i)-(2*x(1,i)-x(2,i));
    dy(m,i) = 2*x(m,i)-x(m-1,i)-x(m,i);
end

 for i = 2:m-1
     for j = 1:n
         dy(i,j) = x(i+1,j)-x(i,j);
     end
 end
%_________________________全导
 for i =1:n
    dxy(1,i) = dx(1,i)-(2*dx(1,i)-dx(2,i));
    dxy(m,i) = 2*dx(m,i)-dx(m-1,i)-dx(m,i);
end

 for i = 2:m-1
     for j = 1:n
         dxy(i,j) = dx(i+1,j)-dx(i,j);
     end
 end
%___________________________________________记录 dx,dy,dxy
for i = 1:m-1
    for j = 1:n-1
        Chunking{i,j} =  x(i:i+1,j:j+1);
    end
end       

for i = 1:m-1
    for j = 1:n-1
        Chunking_dx{i,j} =  dx(i:i+1,j:j+1);
    end
end 

for i = 1:m-1
    for j = 1:n-1
        Chunking_dy{i,j} =  dy(i:i+1,j:j+1);
    end
end   

for i = 1:m-1
    for j = 1:n-1
        Chunking_dxy{i,j} =  dxy(i:i+1,j:j+1);
    end
end   

for i = 1:m-1
    for j = 1:n-1
        Chunking{i,j} =  reshape(Chunking{i,j}',1,4);  %拉平k1----k16
        Chunking_dx{i,j} =  reshape(Chunking_dx{i,j}',1,4);
        Chunking_dy{i,j} =  reshape(Chunking_dy{i,j}',1,4);
        Chunking_dxy{i,j} =  reshape(Chunking_dxy{i,j}',1,4);
    end
end 
for i = 1:m-1
    for j = 1:n-1
        coefficient_k{i,j} = [Chunking{i,j} Chunking_dx{i,j} Chunking_dy{i,j} Chunking_dxy{i,j}]';
    end
end 
%___________________________________________________算系数
coe1  = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
coe2  = [0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0];
coe3  = [-3,0,3,0,-2,0,-1,0,0,0,0,0,0,0,0,0];
coe4  = [2,0,-2,0,1,0,1,0,0,0,0,0,0,0,0,0];
coe5  = [0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0];
coe6  = [0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0];
coe7  = [0,0,0,0,0,0,0,0,-3,0,3,0,-2,0,-1,0];
coe8  = [0,0,0,0,0,0,0,0,2,0,-2,0,1,0,1,0];
coe9  = [-3,3,0,0,0,0,0,0,-2,-1,0,0,0,0,0,0];
coe10 = [0,0,0,0,-3,3,0,0,0,0,0,0,-2,-1,0,0];
coe11 = [9,-9,-9,9,6,-6,3,-3,6,3,-6,-3,4,2,2,1];
coe12 = [-6,6,6,-6,-3,3,-3,3,-4,-2,4,2,-2,-1,-2,-1];
coe13 = [2,-2,0,0,0,0,0,0,1,1,0,0,0,0,0,0];
coe14 = [0,0,0,0,2,-2,0,0,0,0,0,0,1,1,0,0];
coe15 = [-6,6,6,-6,-4,4,-2,2,-3,-3,3,3,-2,-2,-1,-1];
coe16 = [4,-4,-4,4,2,-2,2,-2,2,2,-2,-2,1,1,1,1];
coe_all = [coe1;coe2;coe3;coe4;coe5;coe6;coe7;coe8;coe9;coe10;coe11;coe12;coe13;coe14;coe15;coe16];
for i = 1:m-1
    for j = 1:n-1
        coefficient_c{i,j} =coe_all*coefficient_k{i,j} ;
    end
end 
%---------------------定原有图像在新图像的位置
for i=1:m
    for j=1:n
        y((i-1)*(R+1)+1,(j-1)*(R+1)+1) = x(i,j);  
    end
end

for i = 1:row           %y
    for j = 1:col           %x
        if i < row
            row_num_block = fix((i-1)/(R+1))+1;
            row_num_dot = rem(i-1,R+1)/(R+1);
        else
            row_num_block = fix((i-1)/(R+1));
            row_num_dot = rem(i-1,R+1)+1;
        end
        
        if j < col     
            col_num_block = fix((j-1)/(R+1))+1;
            col_num_dot = rem(j-1,R+1)/(R+1);
        else
            col_num_block = fix((j-1)/(R+1));
            col_num_dot = rem(j-1,R+1)+1; 
        end
        p1 = [1,col_num_dot,col_num_dot^(2),col_num_dot^(3)];
        p2 =  row_num_dot*p1;
        p3 =  row_num_dot^(2)*p1;
        p4 =  row_num_dot^(3)*p1;
        coefficient_xy{i,j} = [p1 p2 p3 p4];
     y(i,j) =  coefficient_xy{i,j}*coefficient_c{row_num_block,col_num_block};  
    end
end
end
        
        