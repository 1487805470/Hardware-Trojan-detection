function [bestCVmse,bestc,bestg,pso_option,fit_gen] = psoSVMcgForClass(pos_label, pos_train,neg_label,neg_train,pso_option)

%% ������ʼ��
if nargin == 4
    pso_option = struct('c1',1.5,'c2',1.7,'maxgen',20,'sizepop',20, ...
                    'k',0.8,'wV',1,'wP',1,'v',3, ...
                     'popcmax',0.5,'popcmin',0.001,'popgmax',0.5,'popgmin',0.001);
end
%pso_option.sizepop Ϊ��Ⱥ��С
 
Vcmax = pso_option.k*pso_option.popcmax;
Vcmin = -Vcmax ;
Vgmax = pso_option.k*pso_option.popgmax;
Vgmin = -Vgmax ;
K=3;
%% ������ʼ���Ӻ��ٶ�
for i=1:pso_option.sizepop
    
    % ���������Ⱥ
    pop(i,1) = (pso_option.popcmax-pso_option.popcmin)*rand+pso_option.popcmin;  
    pop(i,2) = (pso_option.popgmax-pso_option.popgmin)*rand+pso_option.popgmin;
    
    % ��������ٶ�
    V(i,1)=Vcmax*rands(1);  
    V(i,2)=Vgmax*rands(1);
    
% %     % �����ʼ��Ӧ��
% %     cmd = ['-v ',num2str(pso_option.v),' -c ',num2str( pop(i,1) ),' -g ',num2str( pop(i,2) ),' -s 3 -p 0.1'];
% %     fitness(i) = svmtrain(train_label, train, cmd);
%     fitness(i)=crossvalind_pso(train_label, train,3, pop(i,2) , pop(i,1) );

     fitness(i)=crossvalind_pso(pos_label, pos_train,neg_label,neg_train,K,pop(i,2),pop(i,1));    
end

% �Ҽ�ֵ�ͼ�ֵ��
[global_fitness bestindex]=max(fitness); % ȫ�ּ�ֵ   %bestindexȫ�ּ�ֵ��λ��
local_fitness=fitness;   % ���弫ֵ��ʼ��

global_x=pop(bestindex,:);   % ȫ�ּ�ֵ�� ��Ӧ�ĸ���
local_x=pop;    % ���弫ֵ���ʼ�� 20�������λ��

%% ����Ѱ��
for i=1:pso_option.maxgen     %pso_option.maxgen  Ϊ�� 
        disp(['��' num2str(i) '��']);
    for j=1:pso_option.sizepop  %pso_option.sizepop Ϊ��Ⱥ��С
        
        %�ٶȸ���        
        % pso_option.wV Ϊ��������   randΪ[0��1]��Χ�ڵľ�������� c1 c2Ϊѧϰ���ӣ�Ҳ�Ƽ��ٳ���(acceleration constant)
        %local_x Ϊ���弫��ֵλ�þ��� popΪ��ǰ�����
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
        
        %��Ⱥλ�ø���
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
        
        % ����Ӧ���ӱ���
        if rand>0.5
            k=ceil(2*rand);
            if k == 1
                pop(j,k) = (20-1)*rand+1;
            end
            if k == 2
                pop(j,k) = (pso_option.popgmax-pso_option.popgmin)*rand + pso_option.popgmin;
            end            
        end
        
%         %��Ӧ��ֵ
%         cmd = ['-v ',num2str(pso_option.v),' -c ',num2str( pop(j,1) ),' -g ',num2str( pop(j,2) ),' -s 3 -p 0.1'];
%         fitness(j) = svmtrain(train_label, train, cmd);
  pop(j,2)
  pop(j,1)
  disp('����ɵ��');
          fitness(j)=crossvalind_pso(pos_label, pos_train,neg_label,neg_train,K,pop(j,2),pop(j,1));
          
    end
    
    %�������Ÿ���
    if fitness(j) < local_fitness(j)
        local_x(j,:) = pop(j,:);  % ���¸��弫ֵ��λ��
        local_fitness(j) = fitness(j);% ���¸��弫ֵ����Ӧ��
    end
    
    %Ⱥ�����Ÿ��� 
    if fitness(j) < global_fitness
        global_x = pop(j,:);         % ����ȫ�ּ�ֵ��λ��
        global_fitness = fitness(j);% ����ȫ�ּ�ֵ����Ӧ��
    end
    
    fit_gen(i)=global_fitness;   % ��Ӧ������
    
end



%% �������
figure();
plot(fit_gen);
title(['��Ӧ������','(����c1=',num2str(pso_option.c1),',c2=',num2str(pso_option.c2),',��ֹ����=',num2str(pso_option.maxgen),',��Ⱥ����pop=',num2str(pso_option.sizepop),')']);
xlabel('��������');ylabel('��Ӧ��');
% 
bestc = global_x(1);
bestg = global_x(2);
bestCVmse = fit_gen(pso_option.maxgen);



