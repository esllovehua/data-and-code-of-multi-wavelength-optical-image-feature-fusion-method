clear
clc
load('8-16113-feature-850.mat')
w1 = load('haar_img-850.mat');
w1_data = w1.haar_img;
w2 = load('haar_img-808.mat');
w2_data = w2.haar_img;
w3 = load('haar_img-780.mat');
w3_data = w3.haar_img;
group_num = length(w1_data);
w1_w2_fusion_data = cell(group_num,1);
w1_w2_data = cell(group_num,7);
final_fusion_data = cell(group_num,2);
img_fusion_data = cell(group_num,2);
fusion_data = cell(group_num,2);

for i = 1:group_num
    w1_w2_fusion_data{i,1} = mutiwave_fusion(w1_data(i,:),w2_data(i,:)); 
end

for i = 1:group_num
    w1_w2_data(i,:) = w1_w2_fusion_data{i,1};   
end

for i = 1:group_num
    final_fusion_data{i,1} = mutiwave_fusion(w1_w2_data(i,:),w3_data(i,:));  
    final_fusion_data{i,2} = feature_data{i,2};
end

for i = 1:group_num
    img_fusion_data{i,1} = [[final_fusion_data{i,1}{1,1} final_fusion_data{i,1}{1,2};final_fusion_data{i,1}{1,3} final_fusion_data{i,1}{1,4}] final_fusion_data{i,1}{1,5};final_fusion_data{i,1}{1,6} final_fusion_data{i,1}{1,7}] ;  %第二次融合
    img_fusion_data{i,2} = final_fusion_data{i,2};
end

for i = 1:group_num
    fusion_data{i,1} = BN_255(img_fusion_data{i,1});  
    fusion_data{i,2} = img_fusion_data{i,2};
end
save('8-16113-fusion.mat','fusion_data')

