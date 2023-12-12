% clear
% clc
% load('test_input.mat');
% load('test_output.mat');
% con_kernels = [1,2,1;2,4,2;1,2,1]/16;


%�������õľ���ǽ�ԭ�еľ�������Ӧ���������ģ����������16*16���൱��3*3�Ŀ���20*20�Ŀ��ϻ�����˳�һ��18*18�ľ���
%��¼ÿ�λ���ʱ20*20���ϵĶ�Ӧϵ������16*16����ÿ��Ԫ�ص���X1,X2....����ÿһ�εĶ�Ӧϵ���и��ƽ�ϲ���һ������
%�Ϳ����þ���*��������ʾ�������A*X = Y������������е�˼��ʱ X = AT*Y��������Ҫͨ��������A
%y = cx   x = CTy  x,y��������������
function [y] = reconv2(x,con_kernels)
[m,n] = size(x);          %������Ǵ�ľ���������16*16-18*18�����Ը���������ȡϵ������
add_ele = length(con_kernels); %�����Ǹ��ݺ˵Ĵ�С����
m = m-(add_ele-1);    %������Ҫ���ĳ���
n = n-(add_ele-1);
Coefficient_matrix_apart = cell((m+add_ele-1),(n+add_ele-1));  %ÿһ�������ϵ������ᱻ��ƽ��1��
Coefficient_matrix_merge = [];   %ϵ����ƽ��һ��ϵ������

for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
        Coefficient_matrix_apart{i,j} = zeros(m+2*(add_ele-1),n+2*(add_ele-1)) ;   %��׼��20*20�ľ���������ž��ϵ��
    end
end


for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
     Coefficient_matrix_apart{i,j}(i:i+add_ele-1,j:j+add_ele-1) =  con_kernels;   %�����ϵ�����и�ֵ
    end
end

for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
     Coefficient_matrix_apart{i,j} = Coefficient_matrix_apart{i,j}(add_ele:m+add_ele-1,add_ele:n+add_ele-1);  %�иֻ������Ҫ�ķ���
    end
end

for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
     Coefficient_matrix_apart{i,j} = reshape(Coefficient_matrix_apart{i,j}',1,m*n);    %��ϵ����ƽ
    end
end

for i = 1:m+add_ele-1
    for j = 1:n+add_ele-1
        Coefficient_matrix_merge =  [Coefficient_matrix_merge;Coefficient_matrix_apart{i,j}(1,:)];  %��ϵ���ϲ��ɾ���
    end
end

Coefficient_matrix_merge = Coefficient_matrix_merge';    %��ϵ���������ת��
[len,wid] = size(Coefficient_matrix_merge);
vector_x = reshape(x',1,(m+add_ele-1)*(n+add_ele-1));  %�������X��ƽ
vector_y = zeros(1,m*n);  %׼�������Y

for i = 1:len
   vector_y(1,i) =  sum(Coefficient_matrix_merge(i,:).* vector_x);  %Y = AT*X
end
y = reshape(vector_y,m,n); %��yת��Ϊ����
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
        