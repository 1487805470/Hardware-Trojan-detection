figure
plot(Y,'r+');
hold on
plot(T,'bo');
title(['AES-T1800']);
xlabel('��������');
ylabel('OCSVM����ֵ');
legend('������','ʵ�����')

set(gcf,'Position',[100 100 500 400]);
set(gca,'Position',[.13 .17 .80 .74]);  %���� XLABLE��YLABLE���ᱻ�е�
figure_FontSize=20;
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
