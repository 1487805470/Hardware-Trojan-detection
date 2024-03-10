function [bestCVmse,bestc,bestg,pso_option,fit_gen] = qpso_svm(pos_label, pos_train,neg_label,neg_train)

%flag 代表了优化的核的类型

pso_option = struct('c1',1.5,'c2',1.7,'maxgen',30,'sizepop',20, ...
                    'k',0.8,'wV',1,'wP',1,'v',8, ...
                     'popcmax',0.5,'popcmin',0.01,'popgmax',0.5,'popgmin',0.01);
xmax=[pso_option.popcmax pso_option.popgmax];            
 
popsize=30; %种群数据
MAXITER=50; %最大迭代次数

dimension=2;
sum1=0;
st=0;
% runno=50;
% data1=zeros(runno,MAXITER);
% for run=1:runno
T=cputime;
%初始化种群 根据种群的大小popsize 以及参数的范围 设置随机的初始化x数值

x(:,1) = (pso_option.popcmax-pso_option.popcmin)*rand(popsize,1)+pso_option.popcmin;  
x(:,2) = (pso_option.popgmax-pso_option.popgmin)*rand(popsize,1)+pso_option.popgmin;


pbest=x; %每代 最佳的x
gbest=zeros(1,dimension); %全局最佳的x



for i=1:popsize

     %f_x(i)=crossvalind_pso(train_label, train,pso_option.v,x(i,2:end) , x(i,1),flag ); %计算是印度     
      f_x(i)=crossvalind_pso(pos_label, pos_train,neg_label,neg_train,5,x(i,2:end),x(i,1));  
    f_pbest(i)=f_x(i);  
end
   
   
    g=min(find(f_pbest==min(f_pbest(1:popsize)))); %初始化最佳是印度
    gbest=pbest(g,:);
   
    f_gbest=f_pbest(g);


MINIUM=f_pbest(g);
for t=1:MAXITER
        t
        beta=(0.9-0.55)*(MAXITER-t)/MAXITER+0.55;

        mbest=sum(pbest)/popsize;

              
      for i=1:popsize  
       
        fi=rand(1,dimension);
        p=fi.*pbest(i,:)+(1-fi).*gbest;
        u=rand(1,dimension);
        b=beta*abs(mbest-x(i,:));
        v=-log(u);
        y=p+((-1).^ceil(0.5+rand(1,dimension))).*b.*v;
        x(i,:)=sign(y).*min(abs(y),xmax);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% The above 7 lines of codes use matrix operation, which can be
      %% replaced by the following equivalent codes. The martix operation
      %% accelerates the running of the codes%%%%%%%%%%%%%%%%%%%%%%%%%%

          
            if x(i,1) > pso_option.popcmax
                x(i,1) = pso_option.popcmax;
            end
            if x(i,1) < pso_option.popcmin
                x(i,1) = pso_option.popcmin;
            end

            if x(i,2) > pso_option.popgmax
                x(i,2) = pso_option.popgmax;
            end

            if x(i,2) < pso_option.popgmin
                x(i,2) = pso_option.popgmin;
            end

      f_x(i)=crossvalind_pso(pos_label, pos_train,neg_label,neg_train,5,x(i,2:end),x(i,1));  
%             f_x(i)=crossvalind_pso(train_label, train,pso_option.v,x(i,2) , x(i,1) ,flag);
         %  f_x(i)=crossvalind_pso(train_label, train,pso_option.v,x(i,2) , x(i,1),flag ); %计算是印度
            if f_x(i)<f_pbest(i)
                pbest(i,:)=x(i,:);
                f_pbest(i)=f_x(i);
            end
            if f_pbest(i)<f_gbest
                gbest=pbest(i,:);
                f_gbest=f_pbest(i);
            end
            
            MINIUM=f_gbest;
     
    end
% MINIUM
    fit_gen(t)=MINIUM;   % 适应度曲线
%     data1(run,t)=MINIUM;
end
figure();
plot(fit_gen,'LineWidth',2);
title(['适应度曲线','终止代数=',num2str(MAXITER),',种群数量pop=',num2str(popsize),')']);
xlabel('进化代数');ylabel('适应度');


bestc = gbest(1);
bestg = gbest(2:end);
bestCVmse = fit_gen(end);

% end
% 
% 量子粒子群算法：因为粒子的位置和速度在量子空间中不能一起确定，所以用波函数表示粒子位置，通过蒙特卡罗方法求出粒子位置。
% gbest求解通过平均最好位置mbest得到。mbest是所有个体平均最优，通过它来求解粒子出现在相对点的位置，
% 用L表示。而粒子的势表示位置的最终值，与L直接相关。

 