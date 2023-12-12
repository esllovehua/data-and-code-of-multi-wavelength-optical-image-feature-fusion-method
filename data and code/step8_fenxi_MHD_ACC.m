
clc
clear
close all
clc
load('T_sim.mat')
load('T_test.mat')
load('element_area.mat')
node=load('anomaly.rpt.node');
V=sum(element_area);      
threshold_num = 0.22;
ele_num=length(node);  
group_num=size(T_test,1);
Error_matrix = zeros(group_num,ele_num);
Manhattan_distance = zeros(group_num,1);
classifi_ture = zeros(group_num,ele_num);
classifi_re = zeros(group_num,ele_num);
right_num = zeros(group_num,1);
accuracy = zeros(group_num,1);


an_test=cell(1,group_num);
bn_test=cell(1,group_num);
v1=zeros();
v=zeros();
Vce_relative_error=zeros();
for k=1:group_num
    j=1;
    for i=1:ele_num
        an_test{1,k}.a(i,1:3)=node(i,2:4);
        an_test{1,k}.a(i,4)=T_test(k,i);
        if  an_test{1,k}.a(i,4)>= threshold_num         
            bn_test{1,k}.a(j,1:4)= an_test{1,k}.a(i,1:4);
            j=j+1;
        end
    end
    clear j;
    v1(k,1)=(length(bn_test{1,k}.a)/ele_num)*V;
end

an_sim=cell(1,group_num);
bn_sim=cell(1,group_num);
v2=zeros();
for k=1:group_num
    h=1; 
    for i=1:ele_num
        an_sim{1,k}.a(i,1:3)=node(i,2:4);
        an_sim{1,k}.a(i,4)=T_sim(k,i);
        if  an_sim{1,k}.a(i,4)>= threshold_num         
            bn_sim{1,k}.a(h,1:4)= an_sim{1,k}.a(i,1:4);
            h=h+1;
        end
    end
    clear h;
    if isempty(bn_sim{1,k})
    v2(k,1)=0;
    else
  v2(k,1)=(length(bn_sim{1,k}.a)/ele_num)*V;
    end
end

radius_r=1:1:group_num;
c=length(v1);
for i=1:c
v(i,1)=radius_r(1,i);    
v(i,2)=v1(i,1)/1000;         
v(i,3)=v2(i,1)/1000;         
v(i,4)=abs(v(i,2)-v(i,3));  
end

for i=1:c
 Vce_relative_error(i,1)=(v(i,4)/v(i,2))*100;   
 v(i,5)=Vce_relative_error(i,1);         
end
VE = v(:,4);
VRE = v(:,5);

for i=1:group_num     
   for j = 1:ele_num 
       Error_matrix(i,j) = abs(T_sim(i,j)-T_test(i,j));
   end
end

for i=1:group_num 
    Manhattan_distance(i,1) = sum(Error_matrix(i,:))/ele_num;
end
        
for i=1:group_num      
   for j = 1:ele_num 
       if T_sim(i,j) >= threshold_num
           classifi_re(i,j) = 1;
       end
       
       if T_test(i,j) >= threshold_num
           classifi_ture(i,j) = 1;
       end
   end
end



for i=1:group_num      
   for j = 1:ele_num 
       if classifi_re(i,j) == classifi_ture(i,j)
          right_num(i,1) = right_num(i,1)+1;
       end
   end
end

for i=1:group_num 
    accuracy(i,1) = 100*right_num(i,1)/ele_num;
end

show_value = [v() Manhattan_distance accuracy];
show_value=sortrows(show_value,2);     
show_value = [show_value(1:14,:);show_value(18:27,:)];
group_num = group_num-3;
for i=1:group_num
show_value(i,1)=radius_r(1,i);    
end
show_table = cell(group_num+2,7);
show_table{1,1} = '编码';
show_table{1,2} = '真实体积';
show_table{1,3} = '重建体积';
show_table{1,4} = 'VE';
show_table{1,5} = 'VRE';
show_table{1,6} = '曼哈顿距离';
show_table{1,7} = '准确度';
for i = 1:group_num
    for j = 1:7
        show_table{i+2,j} = show_value(i,j);
    end
end
show_table{2,1} = 'mean';
for i =2:7
    show_table{2,i} = mean(show_value(1:group_num,i));
end

figure
plot(show_value(:,1),show_value(:,2),'-^r',show_value(:,1),show_value(:,3),'-*b','LineWidth',1);
legend_FontSize = legend('True','Reconstruction','Location','northwest');
set(legend_FontSize,'FontSize',16,'FontName','Times New Roman');
ylabel('V/mm^3','FontSize',16,'FontName','Times New Roman');
xlabel('sample','FontSize',16,'FontName','Times New Roman');
set(gca,'FontSize',16,'FontName','Times New Roman');
saveas(gcf,'VE.tif');

figure
plot(show_value(:,1),show_value(:,5),'-*r','LineWidth',1);
ylabel('VRE/%','FontSize',16,'FontName','Times New Roman');
set(gca,'FontSize',16,'FontName','Times New Roman');
set(gca,'yLim',[0 200]);
saveas(gcf,'VRE.tif');


figure
plot(show_value(:,1),show_value(:,6),'-*r','LineWidth',1);
legend_FontSize = legend('Manhattan_distance','Location','northwest');
set(legend_FontSize,'FontSize',16,'FontName','Times New Roman');
ylabel('MHD','FontSize',16,'FontName','Times New Roman');
set(gca,'FontSize',16,'FontName','Times New Roman');
set(gca,'yLim',[0 0.1]);
saveas(gcf,'Manhattan_distance.tif');

figure
plot(show_value(:,1),100-show_value(:,7),'-*r','LineWidth',1);
legend_FontSize = legend('1-accuracy','Location','northwest');
set(legend_FontSize,'FontSize',16,'FontName','Times New Roman');
ylabel('1-accuracy/%','FontSize',16,'FontName','Times New Roman');
set(gca,'FontSize',16,'FontName','Times New Roman');
set(gca,'yLim',[0 100]);
saveas(gcf,'1-accuracy.tif');


save('show_value.mat','show_value');
save('show_table.mat','show_table');

ture_inf = show_value(:,2);
reconstruction_inf = show_value(:,3);

