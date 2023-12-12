clear
clc
load('8-16113-780.mat'); %8-16113-808£¬8-16113-850
paa_mua = output_data;
[m,n]=size(paa_mua);
data_all = {i,2};
paa_1 = paa_mua(:,1:8);
paa_2 = paa_mua(:,9:16);
paa_3 = paa_mua(:,17:24);
paa_4 = paa_mua(:,25:32);
paa_5 = paa_mua(:,33:40);
paa_6 = paa_mua(:,41:48);
paa_7 = paa_mua(:,49:56);
paa_8 = paa_mua(:,57:64);
for i = 1:m
    data_all{i,1} = [paa_8(i,:);paa_7(i,:);paa_6(i,:);paa_5(i,:);paa_4(i,:);paa_3(i,:);paa_2(i,:);paa_1(i,:)];
    data_all{i,2}= paa_mua(i,65:end);
end
imshow(data_all{1,1});
save('8-16113-img-780.mat','data_all') %8-16113-img-808.mat£¬8-16113-img-850.mat
 
