clear
clc
load('8-16113-img-780.mat'); %8-16113-808£¬8-16113-850
group_num = 108;
st_1 = cell(group_num,2);   %convolution
st_2 = cell(group_num,2);   %BN
st_3 = cell(group_num,2);   %relu
st_4 = cell(group_num,2);   %convolution
st_5 = cell(group_num,2);   %BN
st_6 = cell(group_num,2);   %relu
st_7 = cell(group_num,2);   %maxpooling
pooling_record = cell(group_num,1);  %pooling_record
st_8 = cell(group_num,2);   %interpolation
BN_pro_1 = zeros(group_num,100);  % 10*10
BN_pro_3 = zeros(group_num,144);  % 12*12
% con_kernels = [1,2,1;2,4,2;1,2,1]/16;  % gaussian
% con_kernels = [1,1,1;1,1,1;1,1,1]/9;  % average 
% con_kernels = [2,1,0;1,0,-1;0,-1,-2];   %sobel
% con_kernels = [1,1,1;1,-8,1;1,1,1]; %laplacian
con_kernels = [1 1 1;0 0 0;-1 -1 -1];  %prewitt

for i =1:group_num         
    st_1{i,1} = conv2(data_all{i,1},con_kernels);  
    BN_pro_1(i,:)= reshape(st_1{i,1}',1,100);     
    st_1{i,2} = data_all{i,2};
end


[BN_pro_2, BN_pro_1_input] = mapminmax(BN_pro_1,0,1);

for i =1:group_num 
    st_2{i,1} = reshape(BN_pro_2(i,:),10,10);         
    st_2{i,1} = st_2{i,1}';
    st_2{i,2} = st_1{i,2};
end

for i =1:group_num                                
    st_3{i,1} = relu(st_2{i,1});
    st_3{i,2} = st_2{i,2};
end

for i =1:group_num
    st_4{i,1} = conv2(st_3{i,1},con_kernels);
    BN_pro_3(i,:)= reshape(st_4{i,1}',1,144);
    st_4{i,2} = st_3{i,2};
end

[BN_pro_4, BN_pro_2_input] = mapminmax(BN_pro_3,0,1);

for i =1:group_num
  st_5{i,1} = reshape(BN_pro_4(i,:),12,12);
    st_5{i,1} = st_5{i,1}';
    st_5{i,2} = st_4{i,2};
end


for i =1:group_num
    st_6{i,1} = relu(st_5{i,1});
    st_6{i,2} = st_5{i,2};
end

for i = 1:group_num                     
    [st_7{i,1},pooling_record{i,1}] = maxpooling(st_6{i,1},2,2);
    st_7(i,2) = st_6(i,2);
end

for i = 1:group_num                      
    st_8{i,1} = bicubic_interpolation(st_7{i,1},6);
    st_8(i,2) = st_7(i,2);
end
upsampling_data = st_8;
save('pooling_record-780.mat','pooling_record') %pooling_record-808£¬pooling_record-850
save('8-16113-upsampling-780.mat','upsampling_data')%8-16113-upsampling-808,8-16113-upsampling-850
save('BN_pro_1_input-780.mat','BN_pro_1_input')%BN_pro_1_input-808,BN_pro_1_input-850
save('BN_pro_2_input-780.mat','BN_pro_2_input')%BN_pro_2_input-808,BN_pro_2_input-850
