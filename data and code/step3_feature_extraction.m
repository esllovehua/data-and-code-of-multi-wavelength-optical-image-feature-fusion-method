clear
clc
load('8-16113-upsampling-780.mat') %8-16113-upsampling-808,8-16113-upsampling-850
[group_num,n] = size(upsampling_data);
st_1 = cell(group_num,2);   %filtering
st_2 = cell(group_num,9);   %feature extraction
st_3 = cell(group_num,2);   %normalization

for i = 1:group_num
    st_1{i,1} = filter2(fspecial('prewitt'),upsampling_data{i,1}*255);%fspecial('average'),fspecial('gaussian'),fspecial('laplacian'),fspecial('sobel')
%     st_1{i,1} = upsampling_data{i,1}*255; 
    st_1{i,2} = upsampling_data{i,2};
end
for i = 1:group_num
    [st_2{i,1},st_2{i,3},st_2{i,4},st_2{i,5},st_2{i,6},st_2{i,7},st_2{i,8},st_2{i,9}] = haar_2(st_1{i,1});   %二次haar小波提取特征
    st_2{i,2} = st_1{i,2};
end

for i = 1:group_num
    st_3{i,1} = BN_255(st_2{i,1}); 
    st_3{i,2} = st_2{i,2};
end
feature_data = st_3;
haar_img = st_2(:,3:9);
save('8-16113-feature-780.mat','feature_data')%8-16113-feature-808,8-16113-feature-850
save('haar_img-780.mat','haar_img')% haar_img-808,haar_img-850