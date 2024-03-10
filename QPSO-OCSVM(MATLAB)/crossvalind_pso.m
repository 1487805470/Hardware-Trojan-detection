function[wrong]=crossvalind_pso(pos_label, pos_train,neg_label,neg_train,K,kerneloption,np) %训练样本中的P和T，核函数，核参数，惩罚因子
%通过交叉验证获得适应度函数值

%训练样本进行10折交叉验证，同时还要考虑到一些负样本
datapos=[pos_train,pos_label];
[M,N]=size(datapos);

%
selec=randperm(M);
selec=selec';
data_randn=datapos(selec,:);
indices=crossvalind('Kfold',data_randn(1:M,N),K);

for i=1:K
	test = (indices == i); 
	train = ~test;
	P_train=data_randn(train,1:end-1);
	T_train=data_randn(train,end);
	P_test=data_randn(test,1:end-1);
    T_test=data_randn(test,end);
    %训练样本交叉验证，同时还要加上一部分的负样本一起参与适应度计算
    P_test_all=[P_test;neg_train];
    T_test_all=[T_test;neg_label];
    cmd = ['-n ', num2str(np), ' -g ', num2str(kerneloption) , ' -s 2 '];
    model = svmtrain(double(T_train),double(P_train),cmd);  
    [Y1,Y2,Y3] = svmpredict(double(T_test_all),double(P_test_all),model);
    error(i)=sum(Y1==T_test_all)/length(T_test_all);

     
end
%把平均分类误差作为适应度
     wrong=1-sum(error)/K;

