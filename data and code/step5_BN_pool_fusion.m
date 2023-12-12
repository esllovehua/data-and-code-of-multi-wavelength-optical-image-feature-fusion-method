clear
clc
pool_850 = load('pooling_record-850.mat');
pool_850 = pool_850.pooling_record;
BN_1_850 = load('BN_pro_1_input-850.mat');
BN_1_850 = BN_1_850.BN_pro_1_input;
BN_2_850 = load('BN_pro_2_input-850.mat');
BN_2_850 = BN_2_850.BN_pro_2_input;
pool_808 = load('pooling_record-808.mat');
pool_808 = pool_808.pooling_record;
BN_1_808 = load('BN_pro_1_input-808.mat');
BN_1_808 = BN_1_808.BN_pro_1_input;
BN_2_808 = load('BN_pro_2_input-808.mat');
BN_2_808 = BN_2_808.BN_pro_2_input;
pool_780 = load('pooling_record-780.mat');
pool_780 = pool_780.pooling_record;
BN_1_780 = load('BN_pro_1_input-780.mat');
BN_1_780 = BN_1_780.BN_pro_1_input;
BN_2_780 = load('BN_pro_2_input-780.mat');
BN_2_780 = BN_2_780.BN_pro_2_input;
group_num = length(pool_850);
pooling_record = cell(group_num,1);

for i = 1:group_num
    pooling_record{i,1} = D_fusion(D_fusion(pool_850{i,1},pool_808{i,1}),pool_780{i,1});
end
BN_pro_1_input = BN_1_850;
BN_pro_1_input.xmax = D_fusion(D_fusion(BN_1_850.xmax,BN_1_808.xmax),BN_1_780.xmax);
BN_pro_1_input.xmin = D_fusion(D_fusion(BN_1_850.xmin,BN_1_780.xmin),BN_1_760.xmin);
BN_pro_1_input.xrange = D_fusion(D_fusion(BN_1_850.xrange,BN_1_808.xrange),BN_1_780.xrange);
BN_pro_1_input.gain = D_fusion(D_fusion(BN_1_850.gain,BN_1_808.gain),BN_1_780.gain);
BN_pro_1_input.xoffset = D_fusion(D_fusion(BN_1_850.xoffset,BN_1_780.xoffset),BN_1_760.xoffset);

BN_pro_2_input = BN_2_850;
BN_pro_2_input.xmax = D_fusion(D_fusion(BN_2_850.xmax,BN_2_808.xmax),BN_2_780.xmax);
BN_pro_2_input.xrange = D_fusion(D_fusion(BN_2_850.xrange,BN_2_808.xrange),BN_2_780.xrange);
BN_pro_2_input.gain = D_fusion(D_fusion(BN_2_850.gain,BN_2_808.gain),BN_2_780.gain);

save('pooling_record.mat','pooling_record')
save('BN_pro_1_input.mat','BN_pro_1_input')
save('BN_pro_2_input.mat','BN_pro_2_input')