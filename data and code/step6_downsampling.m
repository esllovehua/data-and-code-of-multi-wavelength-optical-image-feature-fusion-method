clear
clc
load('8-16113-fusion.mat');
load('pooling_record.mat');
load('BN_pro_1_input.mat');
load('BN_pro_2_input.mat');
group_num = length(fusion_data);
st_1 = cell(group_num,2);  %anti-interpolation
st_2 = cell(group_num,2);  %anti-maxpooling
st_3 = cell(group_num,2);  %anti-BN
st_4 = cell(group_num,2);  %anti-convolution
st_5 = cell(group_num,2);  %anti-BN
st_6 = cell(group_num,2);  %anti-convolution
st_7 = cell(group_num,2);  
BN_pro_1 = zeros(group_num,144);  % 12*12
BN_pro_3 = zeros(group_num,100);  % 10*10
% BN_pro_1 = zeros(group_num,256);  % 16*16
% BN_pro_3 = zeros(group_num,256);  % 16*16
% con_kernels = [1,2,1;2,4,2;1,2,1]/16; %gaussian
% con_kernels = [1,1,1;1,1,1;1,1,1]/9; %average
% con_kernels = [2,1,0;1,0,-1;0,-1,-2];   %sobel
% con_kernels = [1,1,1;1,-8,1;1,1,1]; %laplacian
con_kernels = [1 1 1;0 0 0;-1 -1 -1];  %prewitt

for i =1:group_num
    fusion_data{i,1} = fusion_data{i,1}/255;   
end

for i =1:group_num
    st_1{i,1} = re_interpolation(fusion_data{i,1},6);
    st_1{i,2} = fusion_data{i,2};
end

for i =1:group_num
    st_2{i,1} = remaxpooling(st_1{i,1},2,2,pooling_record{i,1});
    st_2{i,2} = st_1{i,2};
end


for i = 1:group_num
  BN_pro_1(i,:)= reshape(st_2{i,1}',1,144);       
end
BN_pro_2 = mapminmax('reverse',BN_pro_1,BN_pro_2_input);   

for i =1:group_num
  st_3{i,1} = reshape(BN_pro_2(i,:),12,12);    
    st_3{i,1} = st_3{i,1}';                        
    st_3{i,2} = st_2{i,2};
end


for i =1:group_num
    st_4{i,1} = reconv2(st_3{i,1},con_kernels);    
    st_4{i,2} = st_3{i,2};
end


for i = 1:group_num
  BN_pro_3(i,:)= reshape(st_4{i,1}',1,100);         
end
BN_pro_4 = mapminmax('reverse',BN_pro_3,BN_pro_1_input);   


for i =1:group_num
  st_5{i,1} = reshape(BN_pro_4(i,:),10,10);      
    st_5{i,1} = st_5{i,1}';                        
    st_5{i,2} = st_3{i,2};
end

for i =1:group_num
    st_6{i,1} = reconv2(st_5{i,1},con_kernels);     
    st_6{i,2} = st_5{i,2};
end

for i =1:group_num
    st_7{i,1} = reshape(st_6{i,1}',1,64);       
    st_7{i,2} = st_6{i,2};
end


light_num = length(st_7{1,1});
ele_num = length(st_7{1,2});
output_data = zeros(group_num,light_num+ele_num);

for i = 1:group_num
    output_data(i,:) = [st_7{i,1}(1,:) st_7{i,2}(1,:)];
end
save('8-116113-processed.mat','output_data')