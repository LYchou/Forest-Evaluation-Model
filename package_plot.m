

clc 
clear
% num=xlsread('ESO_��s���G.xlsx',6);
num=xlsread('QSO_�R�A���R.xlsx',3);
num=xlsread('ESO��s���G0819.xlsx',10);
x=num(1:14,:);
% w=0.4;tax_firm=0.21;%w�OBC tax_firm�O���q�|�v
% type_default=1;type_tax_employee=1;%type_tax_employee=1�OProgressive tax =2�Ocapital gain tax
% 
% V=[9.91e9 ];%���q�겣����
% F=V*0.18;c=0.075;r=0.06;
% mu=0.125;
% X=7e6;%�i����
% O=1000; %��l�Ѳ��i��
% T=[5,10];
% T=10;%�����
% Div=0 ;
% T_exercise=3;
% % wage=670000;%�~�~
% method=1;
% tax_employee=0; 
% percent=[0.5];%�i�����Z
% Beta=0.125;
% 
% 
% % Total_CE=[500000 1000000 2000000  2500000]; %ESO �� CE �`�X
% Total_CE=[2000000]; %ESO �� CE �`�X
% Total_CE=[28200713.5437342];
% 
% % Total_cost=2000000;
% range=10000;
% sigma=[0.3];
% gamma=[0.2 0.5 0.8];
% gamma=0.5;
% additional_wealth=0;
% % gamma=0.2;
% N=linspace(0,6,7);%�i���i�� �q0~7
% % N=[4,5];
% result=[];
% result1=[];
% step_unit=4;
% step=T*step_unit;
% t=1/step_unit;
% total_step=step;
% %gamma=0.2-----------------------
% gamma=1;
% Total_CE=[18000000]; %ESO �� CE �`�X
% lb=6000000;ub=10000000;%gamma=0.2�~�����W�U�� 
% threshold=3000;
% %gamma=0.5-----------------------
% gamma=0.5;
% Total_CE=[18000000]; %ESO �� CE �`�X
% lb=5000000;ub=10000000;%gamma=0.5�~�����W�U�� 
% threshold=5000;
% % gamma=0.8------------------------
% gamma=0.8;
% Total_CE=[900000000]; %ESO �� CE �`�X
% lb=100000000;ub=1000000000;
% threshold=8000;
% % gamma=1------------------------
% gamma=[0.2 0.5 0.8 1];
% % gamma=1;
% % Total_CE=[900000000]; %ESO �� CE �`�X
% % Total_CE=[28200713.5437342];
% % Total_CE=[6755803.36953571];
% Total_CE=[47013444.7144339];
% lb=0;ub=10000000;
% threshold=30000;
% % gamma=1.2------------------------
% % gamma=1.2;
% % Total_CE=[900000000]; %ESO �� CE �`�X
% % lb=60000000;ub=1000000000;
% % threshold=10000;
% % x=num;
% % g1=1;
% % for list_4=1:length(gamma)
% % for i=1:2
% % plot(x(4,(list_4-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*list_4+(i-1)*length(gamma)*length(N)),x(7,(list_4-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*list_4+(i-1)*length(gamma)*length(N)),'--o');
% % % xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('�~���[ESO�`����','FontWeight','bold','fontsize',14)
% % xlabel('the Ratio of ESO(�L�`��M�}���ĪG) to Equity(?)','FontWeight','bold','fontsize',14),ylabel('Total Cost of Salary and ESO','FontWeight','bold','fontsize',14)
% % title('Total CE='+string(Total_CE)+'  '+'sigma='+string(sigma)+'  '+'gamma='+string(gamma(list_4)))
% % hold on
% % end
% % legend('NQSO','QSO','Location','northeast');
% % %�e�ϸ��|
% % hold off
% % print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\��s���G\no injection\fixed CE\���s\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
% % 
% % g1=g1+1;
% % end
% % for list_4=1:length(gamma)
% % for i=1:2
% % plot(x(4,(list_4-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*list_4+(i-1)*length(gamma)*length(N)),x(10,(list_4-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*list_4+(i-1)*length(gamma)*length(N)),'--o');
% % % xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
% % xlabel('the Ratio of ESO(�L�`��M�}���ĪG) to Equity(?)','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
% % title('Total CE='+string(Total_CE)+'  '+'sigma='+string(sigma)+'  '+'gamma='+string(gamma(list_4)))
% % hold on
% % end
% % legend('NQSO','QSO','Location','northeast');
% % 
% % hold off
% % %�e�ϸ��|
% % print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\��s���G\no injection\fixed CE\���s\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
% % g1=g1+1;
% % end
% fixed CE------------------------------------------------------
w=0.4296;tax_firm=0.21;%w�OBC tax_firm�O���q�|�v
type_default=1;type_tax_employee=1;%type_tax_employee=1�OProgressive tax =2�Ocapital gain tax

V=[9.91e9 ];%���q�겣����
F=V*0.18;c=0.078;r=0.06;
mu=0.125;
X=8e6;%�i����
O=1000; %��l�Ѳ��i��
T=[5,10];
T=10;%�����
Div=0 ;
T_exercise=3;
% wage=670000;%�~�~
method=1;
tax_employee=0; 
percent=[0.5];%�i�����Z
Beta=0.125;


% Total_CE=[500000 1000000 2000000  2500000]; %ESO �� CE �`�X
Total_CE=[2000000]; %ESO �� CE �`�X
Total_CE=[28200713.5437342];

% Total_cost=2000000;
range=10000;
sigma=[0.3];
gamma=[0.2 0.5 0.8];
gamma=0.5;
% additional_wealth=0;
% % gamma=0.2;
% N=linspace(0,6,7);%�i���i�� �q0~7
% % N=[4,5];
% result=[];
% result1=[];
% step_unit=4;
% step=T*step_unit;
% t=1/step_unit;
% total_step=step;
% %gamma=0.2-----------------------
% gamma=1;
% Total_CE=[18000000]; %ESO �� CE �`�X
% lb=6000000;ub=10000000;%gamma=0.2�~�����W�U�� 
% threshold=3000;
% %gamma=0.5-----------------------
% gamma=0.5;
% Total_CE=[18000000]; %ESO �� CE �`�X
% lb=5000000;ub=10000000;%gamma=0.5�~�����W�U�� 
% threshold=5000;
% % gamma=0.8------------------------
% gamma=0.8;
% Total_CE=[900000000]; %ESO �� CE �`�X
% lb=100000000;ub=1000000000;
% threshold=8000;
% % gamma=1------------------------
% gamma=[0.2 0.5 0.8 1];
% % gamma=1;
% % Total_CE=[900000000]; %ESO �� CE �`�X
% % Total_CE=[28200713.5437342];
% % Total_CE=[6755803.36953571];
% Total_CE=[47013444.7144339];
% lb=0;ub=10000000;
% threshold=30000;
% gamma=1.2------------------------
% gamma=1.2;
% Total_CE=[900000000]; %ESO �� CE �`�X
% lb=60000000;ub=1000000000;
% threshold=10000;

% x=num(17:30,:);
gamma=[0.2 0.5 0.7 0.9];
sigma=[0.3];
% gamma=0.7;
% sigma=[0.1 0.3 0.5 0.7];
N=linspace(0,7,8);%�i���i�� �q0~7
Total_CE=[52421244.4442340];
g1=1;
%�e��
for j=1:length(gamma)
% for j=1:length(sigma)
for i=1:2
if i==1
plot(x(4,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),x(7,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),'--o');
% plot(x(4,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),x(7,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),'--o');% xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
elseif i==2
plot(x(4,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),x(7,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),'--+');
% plot(x(4,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),x(7,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),'--+');% xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
end
% xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('�~���[ESO�`����','FontWeight','bold','fontsize',14)
xlabel('the Ratio of ESO(���`��M�}���ĪG) to Equity(?)','FontWeight','bold','fontsize',14),ylabel('Total Cost of Salary and ESO','FontWeight','bold','fontsize',14)

title('Total CE='+string(Total_CE)+'  '+'sigma='+string(sigma)+'  '+'gamma='+string(gamma(j)))
% title('Total CE='+string(Total_CE)+'  '+'sigma='+string(sigma(j))+'  '+'gamma='+string(gamma))
hold on
end
legend('NQSO','QSO','Location','northeast');
%�e�ϸ��|
hold off
print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\0819\fixed CE\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>

g1=g1+1;
end
for j=1:length(gamma)
% for j=1:length(sigma)
for i=1:2
if i==1
plot(x(4,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),x(10,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),'--o');
% plot(x(4,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),x(10,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),'--o');% xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
elseif i==2
plot(x(4,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),x(10,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),'--+');
% plot(x(4,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),x(10,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),'--+');% xlabel('ESO�i��','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
end
xlabel('the Ratio of ESO(���`��M�}���ĪG) to Equity(?)','FontWeight','bold','fontsize',14),ylabel('Equity+Debt','FontWeight','bold','fontsize',14)
title('Total CE='+string(Total_CE)+'  '+'sigma='+string(sigma)+'  '+'gamma='+string(gamma(j)))
% title('Total CE='+string(Total_CE)+'  '+'sigma='+string(sigma(j))+'  '+'gamma='+string(gamma))
hold on
end
legend('NQSO','QSO','Location','southwest');

hold off
%�e�ϸ��|
print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\0819\fixed CE\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
g1=g1+1;
end
% fixed cost------------------------------------------------------------------

% V=[9.91e9 ];
% F=V*0.18;c=0.075;r=0.06;
% mu=0.125;
% % mu=linspace(0.02,0.1,11);
% % X=50;N=1000;O=16000; 
% X=7e6;N=4;O=1000; 
% % N=[1];
% % N=linspace(0,10,11);
% T=[5,10];
% T=10;
% % Div=[0 0.25 0.5 0.75 ] ;
% Div=0 ;
% T_exercise=3;
% wage=[0 70000 140000];
% wage=670000;
% additional_wealth=[0 ];
% 
% % gamma=[0.25,0.5,0.75,1];
% w=0.4;tax_firm=0.21;
% % w=0;tax_firm=0;
% %step_unit=[1,2,4,12,24,36,52];
% type_default=1;type_tax_employee=1;
% result=[];
% step_unit=[4];%wage=0;
% % T_exercise=T-2;
% method=1;
% tax_employee=0.05; 
% percent=[0.5];
% Beta=0.125;
% 
% 
% 
% Total_cost=[500000 1000000 2000000  2500000];
% Total_cost=600000000;
% Total_cost=V*0.012021;
% % Total_cost=[29140000 56640000 V*0.012021];
% % Total_cost=29140000;
% % Total_cost=[56640000 V*0.012021];
% % Total_cost=100000000;
% threshold=50000;
% range=40000;
% sigma=[0.3 ];
% sigma=[0.1 0.2 0.3 0.4 0.5 0.7 0.8 0.9 1];
% % sigma=0.6;
% % sigma=[0.7 0.8 0.9 1];
% gamma=[0.2  0.5 0.8 1];
% % gamma=[0.8 1];
% gamma=0.8;
% additional_wealth=0;
% % gamma=0.2;
% NN=10;
% N=linspace(0,NN,NN+1);
% 
% g1=1;
% k=25;
% x=num';
% x=x(k:k+10,:);
% for j=1:length(sigma)
% % for j=1:length(Total_cost)
% % for j=1:length(gamma)
% for i=1:2
% % plot(x(2,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),x(8,(j-1)*length(N)+(i-1)*length(gamma)*length(N)+1:length(N)*j+(i-1)*length(gamma)*length(N)),'--o');
% plot(x(2,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),x(8,(j-1)*length(N)+(i-1)*length(sigma)*length(N)+1:length(N)*j+(i-1)*length(sigma)*length(N)),'--o');
% 
% xlabel('the Ratio of ESO(���`��M�}���ĪG) to Equity(?)'),ylabel('Total CE of Salary and ESO')
% % title('Total cost='+string(Total_cost(list_5))+' sigma='+string(sigma(list_3))+'  T exe='+string(T_exercise))
% % title('Total cost='+string(Total_cost(list_5))+' sigma='+string(sigma(list_3))+' gamma='+string(gamma(list_4)))
% title('Total cost='+string(Total_cost)+' sigma='+string(sigma(j))+' gamma='+string(gamma))
% % title('Total cost='+string(Total_cost(list_5))+' sigma='+string(sigma(list_3))+' gamma='+string(gamma(j)))
% % title('Total cost='+string(Total_cost(list_5))+'  '+'sigma='+string(sigma(list_3))+'  '+'gamma='+string(gamma(list_4))+'  T exe='+string(T_exercise))
% hold on
% end
% hold off
% % legend('gamma=0.2','gamma=0.5','gamma=0.8','gamma=1','location','Southwest')
% % legend('sigma=0.2','sigma=0.6','sigma=1')
% legend('NQSO','QSO','Location','southwest');
% print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\��s���G\fixed cost\sigma\���s\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
% g1=g1+1;
% end


% �R�A���R------------------------------------------------------------------

% sigma=0.3;
% % sigma=[0.2 0.5 0.8 1];
% % sigma=[0.2 0.25 0.3 0.35];
% % F=V*0.18;c=0.075;r=0.06;
% mu=0.125;
% % mu=linspace(0.02,0.1,11);
% % X=50;N=1000;O=16000; 
% X=7e6;N=linspace(0,10,11);O=1000; 
% T=10;
% Div=[0 50000 100000] ;
% % Div=0 ;
% T_exercise=3;
% 
% wage=[0 670000  5807000 500000000];
% % wage=670000;
% additional_wealth=[670000 50000000 500000000];
% additional_wealth=0;
% % wage=[0 0.2,0.4,0.6,0.8 1];
% % wage=2;
% gamma=[0.2 0.5 0.8 1];
% gamma=0.5;
% a2=N;
% T=[5 8 10];
% g1=1;
% % for i=1:length(sigma)
% % for i=1:length(gamma)
% for i=1:length(wage)   
% % for i=1:length(additional_wealth)  
% % for i=1:length(Div)      
% % for i=1:length(T)
%     %     a=33*list_1-32;
%     % %      a=1;
%         CE1=num(19,:);
%     %     for i=1:3
% %     i=list_4;
%     CE=CE1(length(a2)*(i-1)+1:length(a2)*i);
%     plot(a2,CE,'--o');
% %     xlabel('ESO�i��'),ylabel('�`CE')
% %     xlabel('the Ratio of NQSO(���`��M�}���ĪG) to Equity(?)'),ylabel('Total Cost of Salary and ESO')
% xlabel('the Ratio of QSO(���`��M�}���ĪG) to Equity(?)'),ylabel('Total Cost of Salary and ESO')
% 
%     ylabel('ESO cost')
% %     title('�~�~='+string(wage)+'  Sigma=0.3')
% %     title('�~�~='+string(wage)+'  Gamma=0.5')
% %     title('�~�~='+string(wage)+'  Gamma=0.5'+'  Sigma=0.3')
%     title('Gamma=0.5  Sigma=0.3')
%     % Gamma='+string(gamma))%+' T exercise=3')
%     %             title('�B�~�C�~�]�I='+string(additional_wealth(list_4))+'  Sigma=0.2 Gamma=0.8 T exercise=T-2')
%     %             title(  'Sigma=0.2 gamma='+string(gamma(list_2)))
%     %             title('�~�~=100000  gamma='+string(gamma(list_2)))
%     hold on
% end
%                
% %     legend('gamma=0.2','gamma=0.5','gamma=0.8','gamma=1','Location','NorthWest');
% %     legend('wage=0(min)','wage=670000(mean)','wage=5807000(max)','wage=500000000(irrational)','Location','NorthWest');
% %      legend('wage=0(min)','wage=200000000(irratiional)','Location','NorthWest');
% %     legend('additional wealth=670000','additional wealth=50000000','additional wealth=500000000','Location','NorthWest');
% %         legend('sigma=0.2','sigma=0.5','sigma=0.8','sigma=1','Location','NorthWest');
% %  legend('T=5','T=8','T=10');
% % legend('percent=0.25','percent=0.5','percent=1');
% legend('annual Div=0','annual Div=50000','annual Div=100000','Location','NorthWest');
% print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\��s���G\�R�A���R\QSO\wage\'+string(g1),'-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
% hold off

% a=[10	9	8	7	6	5	4	3	2	1	0];
% b=[2077316.684	2078377.36	2079323.721	2080126.81	2080768.816	2081226.579	2081468.797	2081450.946	2081104.91	2080313.825	2078833.744
% ];
% 
% x=-pi:2*pi/300:pi;
% y=sin(x);
% % plot(x,y,'b--o');
% plot(a,b,'b--o');
% %Matlab�ھڰ��ɦW�A�۰��x�s�������榡�Ϥ��A�t�~���|�i�H�O����]�i�H�O�۹�
% i=2;
% legend('x='+string(i)+'  '+'y=6')
% % set(gcf,'color','b');
% % print(gcf,'C:\Users\hijac\OneDrive\�ୱ\��j\image\abc'+string(i)+'sigma','-dpng')   %�x�s��png�榡���Ϥ����e���|</font>
