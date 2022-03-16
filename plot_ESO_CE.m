xlsFile = '畫圖資料1.xlsx';
[number, text, rawData] = xlsread(xlsFile);
a2=[10	9	8	7	6	5	4	3	2	1	0];
CE1=number(:,8);
% i=[1 4 7 11];
% CE1=CE1(length(a2)*(i-1)+1:length(a2)*i*3);
% a1=[149434.8155	158826.2835	167818.9748	176382.6218	184779.0402	192679.699	200353.1036	207598.2949	214328.5365	220204.2472	223834.1806	245208.926	259419.3804	273382.3598	286836.6937	299614.8297	311964.563	323714.5668	334961.081	345500.7369	354545.9202	360823.8482	310960.2481	322711.9938	334283.1629	345414.7493	355885.6505	365914.687	375458.8409	384822.7737	393271.1971	401116.8483	406571.9763];

Total_cost=[500000 1000000 2000000  2500000];
g1=5;
% list_1=3;
for list_1=1:length(Total_cost)   
    a=33*list_1-32;
    CE1=number(a:a+32,21);
    for i=1:3
            CE=CE1(length(a2)*(i-1)+1:length(a2)*i);
            plot(a2,CE,'--o');
            xlabel('ESO張數'),ylabel('總CE')
%             ylabel('ESO cost')
%             ylabel('Salary')
%             ylabel('平均單張ESO cost')
            title('Totol cost='+string(Total_cost(list_1))+'  Sigma=0.6')
            hold on
    end
    legend('gamma1=0.2','gamma2=0.5','gamma3=0.8');
    print(gcf,'C:\Users\hijac\OneDrive\桌面\交大\image\mu=0.04\合併\'+string(g1),'-dpng')   %儲存為png格式的圖片到當前路徑</font>
    hold off
    g1=g1+1;
end

        
