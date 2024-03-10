function [bestCVmse,bestc,bestg,pso_option,fit_gen] = psoSVMcgForClass(pos_label, pos_train,neg_label,neg_train,pso_option)

%% 参数初始化
if nargin == 4
    pso_option = struct('c1',1.5,'c2',1.7,'maxgen',20,'sizepop',20, ...
                    'k',0.8,'wV',1,'wP',1,'v',3, ...
                     'popcmax',0.5,'popcmin',0.001,'popgmax',0.5,'popgmin',0.001);
end
%pso_option.sizepop 为种群大小
 
Vcmax = pso_option.k*pso_option.popcmax;
Vcmin = -Vcmax ;
Vgmax = pso_option.k*pso_option.popgmax;
Vgmin = -Vgmax ;
K=3;
%% 产生初始粒子和速度
for i=1:pso_option.sizepop
    
    % 随机产生种群
    pop(i,1) = (pso_option.popcmax-pso_option.popcmin)*rand+pso_option.popcmin;  
    pop(i,2) = (pso_option.popgmax-pso_option.popgmin)*rand+pso_option.popgmin;
    
    % 随机产生速度
    V(i,1)=Vcmax*rands(1);  
    V(i,2)=Vgmax*rands(1);
    
% %     % 计算初始适应度
% %     cmd = ['-v ',num2str(pso_option.v),' -c ',num2str( pop(i,1) ),' -g ',num2str( pop(i,2) ),' -s 3 -p 0.1'];
% %     fitness(i) = svmtrain(train_label, train, cmd);
%     fitness(i)=crossvalind_pso(train_label, train,3, pop(i,2) , pop(i,1) );

     fitness(i)=crossvalind_pso(pos_label, pos_train,neg_label,neg_train,K,pop(i,2),pop(i,1));    
end

% 找极值和极值点
[global_fitness bestindex]=max(fitness); % 全局极值   %bestindex全局极值的位置
local_fitness=fitness;   % 个体极值初始化

global_x=pop(bestindex,:);   % 全局极值点 对应的个体
local_x=pop;    % 个体极值点初始化 20个个体的位置

%% 迭代寻优
for i=1:pso_option.maxgen     %pso_option.maxgen  为代 
        disp(['第' num2str(i) '代']);
    for j=1:pso_option.sizepop  %pso_option.sizepop 为种群大小
        
        %速度更新        
        % pso_option.wV 为惯性因子   rand为[0，1]范围内的均匀随机数 c1 c2为学习因子，也称加速常数(acceleration constant)
        %local_x 为个体极大值位置矩阵 pop为当前体矩阵
        V(j,:) = pso_option.wV*V(j,:) + pso_option.c1*rand*(local_x(j,:) - pop(j,:)) + pso_option.c2*rand*(global_x - pop(j,:)); 
        if V(j,1) > Vcmax
            V(j,1) = Vcmax;
        end
        if V(j,1) < Vcmin
            V(j,1) = Vcmin;
        end
        if V(j,2) > Vgmax
            V(j,2) = Vgmax;
        end
        if V(j,2) < Vgmin
            V(j,2) = Vgmin;
        end
        
        %种群位置更新
        pop(j,:)=pop(j,:) + pso_option.wP*V(j,:);
        if pop(j,1) > pso_option.popcmax
            pop(j,1) = pso_option.popcmax;
        end
        if pop(j,1) < pso_option.popcmin
            pop(j,1) = pso_option.popcmin;
        end
        if pop(j,2) > pso_option.popgmax
            pop(j,2) = pso_option.popgmax;
        end
        if pop(j,2) < pso_option.popgmin
            pop(j,2) = pso_option.popgmin;
        end
        
        % 自适应粒子变异
        if rand>0.5
            k=ceil(2*rand);
            if k == 1
                pop(j,k) = (20-1)*rand+1;
            end
            if k == 2
                pop(j,k) = (pso_option.popgmax-pso_option.popgmin)*rand + pso_option.popgmin;
            end            
        end
        
%         %适应度值
%         cmd = ['-v ',num2str(pso_option.v),' -c ',num2str( pop(j,1) ),' -g ',num2str( pop(j,2) ),' -s 3 -p 0.1'];
%         fitness(j) = svmtrain(train_label, train, cmd);
  pop(j,2)
  pop(j,1)
  disp('齐涛傻逼');
          fitness(j)=crossvalind_pso(pos_label, pos_train,neg_label,neg_train,K,pop(j,2),pop(j,1));
          
    end
    
    %个体最优更新
    if fitness(j) < local_fitness(j)
        local_x(j,:) = pop(j,:);  % 跟新个体极值点位置
        local_fitness(j) = fitness(j);% 跟新个体极值点适应度
    end
    
    %群体最优更新 
    if fitness(j) < global_fitness
        global_x = pop(j,:);         % 跟新全局极值点位置
        global_fitness = fitness(j);% 跟新全局极值点适应度
    end
    
    fit_gen(i)=global_fitness;   % 适应度曲线
    
end



%% 结果分析
figure();
plot(fit_gen);
title(['适应度曲线','(参数c1=',num2str(pso_option.c1),',c2=',num2str(pso_option.c2),',终止代数=',num2str(pso_option.maxgen),',种群数量pop=',num2str(pso_option.sizepop),')']);
xlabel('进化代数');ylabel('适应度');
% 
bestc = global_x(1);
bestg = global_x(2);
bestCVmse = fit_gen(pso_option.maxgen);



