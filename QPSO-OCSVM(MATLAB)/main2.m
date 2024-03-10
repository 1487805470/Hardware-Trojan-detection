clc
clear
close all

%����aes1800����
load aes1800.mat
%ע�������ҹ۲������������0-1֮�䣬������û�н��ж���Ĺ�һ������������Ȥ�����ȹ�һ����������


%ѵ������ ����dbn_aes1800_off_4000
pos_label=ones(size(dbn_aes1800_off_4000,1),1);
%��������ѵ�������ı�ǩ��ȫ��1
pos_train=dbn_aes1800_off_4000;
%���ǻ��on�е�ǰ2000����Ϊ��֤��������������Ӧ��
neg_train=dbn_aes1800_on(1:2000,:);
neg_label=-ones(size(neg_train,1),1);

%��ѵ����(������֤����) ����֤��һ����뵽qpso����Ӧ�Ⱥ����У�������qpso�����Ż�
 [bestCVmse,bestc,bestg,pso_option,fit_gen] = qpso_svm(pos_label, pos_train,neg_label,neg_train);%������������Ⱥ�㷨Ѱ����ѵ�PSO����
 %bestc �� bestg ����OCSVM��ѵ� ����n �Ͳ��� g
 
 
 %��ȡ��������������������dbn_aes1800_onʣ�µ��ǲ��֣���ȫ����dbn_aes1800_off_2000
P_test=[dbn_aes1800_on(2001:end,:);dbn_aes1800_off_2000];
T_test=[-ones(size(dbn_aes1800_on(2001:end,:),1),1);ones(size(dbn_aes1800_off_2000,1),1)];
%������pso�Ż���õ���Ѳ������뵽svm�Ĳ�������cmd��
 cmd = ['-n ', num2str(bestc), ' -g ', num2str(bestg) , ' -s 2 '];
 %������Ѳ�����ѵ����������ѵ��
model = svmtrain(double(pos_label),double(pos_train),cmd);  
[Y1,Y2,Y3] = svmpredict(double(T_test),double(P_test),model);
error=sum(Y1==T_test)/length(T_test);
fprintf('Ԥ��׼ȷ��%4f\n',error);
figure
plot(Y1,'ro');
hold on
plot(T_test,'b*');
legend('������','ʵ�����')