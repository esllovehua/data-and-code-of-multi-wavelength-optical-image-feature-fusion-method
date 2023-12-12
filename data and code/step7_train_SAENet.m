clc
clear
close all
load('8-16113-processed-850.mat')
load('randgroup.mat')
an=output_data;
group_num = size(an,1);
sd_num = 64;
mua_num = 16113;

P_train = an(temp_n(1+group_num/4:group_num),1:sd_num); 
T_train = an(temp_n(1+group_num/4:group_num),sd_num+1:sd_num+mua_num);

P_test =an(temp_n(1:group_num/4),1:sd_num);  
T_test =an(temp_n(1:group_num/4),sd_num+1:sd_num+mua_num);

[p_train, ps_input] = mapminmax(P_train',0,1);
p_test = mapminmax('apply',P_test',ps_input);

[t_train,ps_output] = mapminmax(T_train',0,1);
t_test = mapminmax('apply',T_test',ps_output);

p_train = p_train';
t_train = t_train';
p_test = p_test';
t_test = t_test';

ziseH1=403;
ziseH2=2540;

rand('state',0); 
sae = saesetup([sd_num ziseH1 ziseH2]);
sae.ae{1}.activation_function       = 'sigm';
sae.ae{1}.learningRate              = 0.01;
sae.ae{1}.Zuo_DataZeroMaskedFraction   = 0;    

sae.ae{2}.activation_function       = 'sigm';
sae.ae{2}.learningRate              = 0.01;
sae.ae{2}.Zuo_DataZeroMaskedFraction   = 0;
opts.numepochs =30;     
opts.batchsize =3;  
sae = saetrain(sae, p_train, opts);

nn = nnsetup([sd_num ziseH1 ziseH2 mua_num]);
nn.activation_function              = 'sigm';
nn.learningRate                     = 0.01;

nn.W{1} = sae.ae{1}.W{1};
nn.W{2} = sae.ae{2}.W{1};

iteration=20;
iter_count = 1;
mse_chart = zeros(30,iteration);
for d=1:iteration 
    disp(['Iterating:' num2str(iter_count)]);
    nn.learningRate          =0.01;
    opts.batchsize = 3;    
    opts.numepochs = 30;
   [nn, L,show_mse] = nntrain(nn, p_train, t_train, opts);                               
    iter_count = iter_count+1;
    mse_chart(:,d) = show_mse;
end

nntest = nnff(nn, p_test, t_test); 
t_sim = nntest.a{nntest.n}; 
T_sim = mapminmax('reverse',t_sim',ps_output);  
T_sim = T_sim';

mse_chart_1 = reshape(mse_chart,30*iteration,1);
plot(mse_chart_1(:,1))
xlabel('优化次数')
ylabel('mse')
set(gca,'xtick',0:30:30*iteration ,'xticklabel',{0:1:iteration})

save('T_test.mat','T_test');
save('T_sim.mat','T_sim');
save('mse_chart_1.mat','mse_chart_1')

 