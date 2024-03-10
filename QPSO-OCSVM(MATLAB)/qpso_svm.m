function [bestCVmse,bestc,bestg,pso_option,fit_gen] = qpso_svm(pos_label, pos_train,neg_label,neg_train)

%flag �������Ż��ĺ˵�����

pso_option = struct('c1',1.5,'c2',1.7,'maxgen',30,'sizepop',20, ...
                    'k',0.8,'wV',1,'wP',1,'v',8, ...
                     'popcmax',0.5,'popcmin',0.01,'popgmax',0.5,'popgmin',0.01);
xmax=[pso_option.popcmax pso_option.popgmax];            
 
popsize=30; %��Ⱥ����
MAXITER=50; %����������

dimension=2;
sum1=0;
st=0;
% runno=50;
% data1=zeros(runno,MAXITER);
% for run=1:runno
T=cputime;
%��ʼ����Ⱥ ������Ⱥ�Ĵ�Сpopsize �Լ������ķ�Χ ��������ĳ�ʼ��x��ֵ

x(:,1) = (pso_option.popcmax-pso_option.popcmin)*rand(popsize,1)+pso_option.popcmin;  
x(:,2) = (pso_option.popgmax-pso_option.popgmin)*rand(popsize,1)+pso_option.popgmin;


pbest=x; %ÿ�� ��ѵ�x
gbest=zeros(1,dimension); %ȫ����ѵ�x



for i=1:popsize

     %f_x(i)=crossvalind_pso(train_label, train,pso_option.v,x(i,2:end) , x(i,1),flag ); %������ӡ��     
      f_x(i)=crossvalind_pso(pos_label, pos_train,neg_label,neg_train,5,x(i,2:end),x(i,1));  
    f_pbest(i)=f_x(i);  
end
   
   
    g=min(find(f_pbest==min(f_pbest(1:popsize)))); %��ʼ�������ӡ��
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
         %  f_x(i)=crossvalind_pso(train_label, train,pso_option.v,x(i,2) , x(i,1),flag ); %������ӡ��
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
    fit_gen(t)=MINIUM;   % ��Ӧ������
%     data1(run,t)=MINIUM;
end
figure();
plot(fit_gen,'LineWidth',2);
title(['��Ӧ������','��ֹ����=',num2str(MAXITER),',��Ⱥ����pop=',num2str(popsize),')']);
xlabel('��������');ylabel('��Ӧ��');


bestc = gbest(1);
bestg = gbest(2:end);
bestCVmse = fit_gen(end);

% end
% 
% ��������Ⱥ�㷨����Ϊ���ӵ�λ�ú��ٶ������ӿռ��в���һ��ȷ���������ò�������ʾ����λ�ã�ͨ�����ؿ��޷����������λ�á�
% gbest���ͨ��ƽ�����λ��mbest�õ���mbest�����и���ƽ�����ţ�ͨ������������ӳ�������Ե��λ�ã�
% ��L��ʾ�������ӵ��Ʊ�ʾλ�õ�����ֵ����Lֱ����ء�

 