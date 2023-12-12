% clear
% clc
% load('test_input.mat');
% load('test_output.mat');
% con_kernels = [1,2,1;2,4,2;1,2,1]/16;


%我现在用的卷积是将原有的矩阵补零后对应相乘算出来的，如果输入是16*16，相当于3*3的块在20*20的块上滑动相乘出一个18*18的矩阵
%记录每次滑动时20*20块上的对应系数，将16*16矩阵每个元素当成X1,X2....，将每一次的对应系数切割，拉平合并成一个矩阵，
%就可以用矩阵*向量来表示卷积，即A*X = Y，而反卷积现有的思想时 X = AT*Y，所以需要通过正向求A
%y = cx   x = CTy  x,y都被拉成了向量
function [y] = reconv2(x,con_kernels)
[m,n] = size(x);          %输入的是大的矩阵，正向是16*16-18*18，所以根据正向求取系数矩阵
add_ele = length(con_kernels); %补零是根据核的大小补的
m = m-(add_ele-1);    %两边需要补的长度
n = n-(add_ele-1);
Coefficient_matrix_apart = cell((m+add_ele-1),(n+add_ele-1));  %每一步卷积的系数这里会被拉平成1行
Coefficient_matrix_merge = [];   %系数拉平成一个系数矩阵

for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
        Coefficient_matrix_apart{i,j} = zeros(m+2*(add_ele-1),n+2*(add_ele-1)) ;   %先准备20*20的矩阵用来存放卷积系数
    end
end


for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
     Coefficient_matrix_apart{i,j}(i:i+add_ele-1,j:j+add_ele-1) =  con_kernels;   %将卷积系数进行赋值
    end
end

for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
     Coefficient_matrix_apart{i,j} = Coefficient_matrix_apart{i,j}(add_ele:m+add_ele-1,add_ele:n+add_ele-1);  %切割，只留下需要的方块
    end
end

for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
     Coefficient_matrix_apart{i,j} = reshape(Coefficient_matrix_apart{i,j}',1,m*n);    %将系数拉平
    end
end

for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
        Coefficient_matrix_merge =  [Coefficient_matrix_merge;Coefficient_matrix_apart{i,j}(1,:)];  %将系数合并成矩阵
    end
end

Coefficient_matrix_merge = Coefficient_matrix_merge';    %将系数矩阵进行转置
[len,wid] = size(Coefficient_matrix_merge);
vector_x = reshape(x',1,(m+add_ele-1)*(n+add_ele-1));  %将输入的X拉平
vector_y = zeros(1,m*n);  %准备输出的Y

for i = 1:len
   vector_y(1,i) =  sum(Coefficient_matrix_merge(i,:).* vector_x);  %Y = AT*X
end
y = reshape(vector_y,m,n); %将y转化为矩阵
y = y';
end




%________________________________________________________test
% test_y = reshape(y',1,256);
% sim_x = zeros(1,324);
% for i = 1:324
%    sim_x(1,i) =  sum(Coefficient_matrix_merge(i,:).* test_y);
% end
% sim_x = reshape(sim_x,18,18);
% sim_x = sim_x';
        