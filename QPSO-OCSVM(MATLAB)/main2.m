clc
clear
close all

%载入aes1800样本
load aes1800.mat
%注意由于我观察你的样本都在0-1之间，所以我没有进行额外的归一化处理，你有兴趣可以先归一化再做试试


%训练样本 就是dbn_aes1800_off_4000
pos_label=ones(size(dbn_aes1800_off_4000,1),1);
%我们生成训练样本的标签：全是1
pos_train=dbn_aes1800_off_4000;
%我们获得on中的前2000个作为验证集来帮助计算适应度
neg_train=dbn_aes1800_on(1:2000,:);
neg_label=-ones(size(neg_train,1),1);

%把训练集(交叉验证来用) 和验证集一起放入到qpso的适应度函数中，并采用qpso进行优化
 [bestCVmse,bestc,bestg,pso_option,fit_gen] = qpso_svm(pos_label, pos_train,neg_label,neg_train);%采用量子粒子群算法寻找最佳的PSO参数
 %bestc 和 bestg 就是OCSVM最佳的 参数n 和参数 g
 
 
 %获取测试样本，测试样本是dbn_aes1800_on剩下的那部分，和全部的dbn_aes1800_off_2000
P_test=[dbn_aes1800_on(2001:end,:);dbn_aes1800_off_2000];
T_test=[-ones(size(dbn_aes1800_on(2001:end,:),1),1);ones(size(dbn_aes1800_off_2000,1),1)];
%把上面pso优化获得的最佳参数放入到svm的参数集合cmd内
 cmd = ['-n ', num2str(bestc), ' -g ', num2str(bestg) , ' -s 2 '];
 %采用最佳参数对训练样本进行训练
model = svmtrain(double(pos_label),double(pos_train),cmd);  
[Y1,Y2,Y3] = svmpredict(double(T_test),double(P_test),model);
error=sum(Y1==T_test)/length(T_test);
fprintf('预测准确率%4f\n',error);
figure
plot(Y1,'ro');
hold on
plot(T_test,'b*');
legend('检测类别','实际类别')