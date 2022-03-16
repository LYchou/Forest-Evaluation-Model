load NQSO_ISO_fixed_CE_sorting_binary_calibrateGamma_0407_gamma0.9.mat

x = sigma;		% 在 x 軸 [-2,2] 之間取 25 點  
y = gamma;		% 在 y 軸 [-2,2] 之間取 25 點  
[xx,yy] = meshgrid(x, y);		% xx 和 yy 都是 25×25 的矩陣  
zz = result_prefer_NQSO_maxAsset_A;		% zz 也是 25×2 的矩陣  
mesh(xx, yy, zz);		% 畫出立體網狀圖 
xlabel('X 軸 = sigma');	% X 軸的說明文字
ylabel('Y 軸 = gamma');	% Y 軸的說明文字
title('極大化資產之資產')
% surf(xx, yy, zz);				% 畫出立體曲面圖  
% colormap('default')				% 顏色改回預設值 
saveas(gcf, 'result_prefer_NQSO_maxAsset_A.png', 'png');

plot_list = [result_prefer_NQSO_maxAsset_A;result_prefer_NQSO_maxEquity_E;result_prefer_NQSO_minCost_C;result_prefer_QSO_maxAsset_A;result_prefer_QSO_maxEquity_E;result_prefer_QSO_minCost_C];
plot_name_list = ['(NQSO)MaxA';'(NQSO)MaxE';'(NQSO)MinC';'(_QSO)MaxA';'(_QSO)MaxE';'(_QSO)MinC'];
%file_name_list = ['result_prefer_NQSO_maxAsset_A.png','result_prefer_NQSO_maxEquity_E.png','result_prefer_NQSO_minCost_C.png','result_prefer_QSO_maxAsset_A.png','result_prefer_QSO_maxEquity_E.png','result_prefer_QSO_minCost_C.png'];

for i=1:6
    figure(i)
    x = sigma;		
    y = flip(gamma);		
    [xx,yy] = meshgrid(x, y);		
    index = 1+8*(i-1);
    zz = plot_list(index:index+7,:);		
    mesh(xx, yy, zz);		% 畫出立體網狀圖 
    xlabel('X 軸 = sigma');	% X 軸的說明文字
    ylabel('Y 軸 = gamma');	% Y 軸的說明文字
    title(plot_name_list(i,:))
    name = [plot_name_list(i,:),'_2.png'];
    saveas(gcf,name, 'png');
end


% % NQSO calibrate sigma
% calibrateSigma_NQSO_maxA_N=zeros(1,length(gamma));
% calibrateSigma_NQSO_maxA_sigma=zeros(1,length(gamma));
% for j=1:length(gamma)
%     max_A=0;
%     for i=1:length(sigma)
%         if(result_prefer_NQSO_maxAsset_A(i,j)>=max_A)
%             max_A = result_prefer_NQSO_maxAsset_A(i,j);
%             calibrateSigma_NQSO_maxA_N(j)=result_prefer_NQSO_maxAsset(i,j);
%             calibrateSigma_NQSO_maxA_sigma(j)=sigma(i);
%         end
%     end
% end
% 
% calibrateSigma_NQSO_maxE_N=zeros(1,length(gamma));
% calibrateSigma_NQSO_maxE_sigma=zeros(1,length(gamma));
% for j=1:length(gamma)
%     max_E=0;
%     for i=1:length(sigma)
%         if(result_prefer_NQSO_maxEquity_E(i,j)>=max_E)
%             max_E = result_prefer_NQSO_maxEquity_E(i,j);
%             calibrateSigma_NQSO_maxE_N(j)=result_prefer_NQSO_maxEquity(i,j);
%             calibrateSigma_NQSO_maxE_sigma(j)=sigma(i);
%         end
%     end
% end
% 
% calibrateSigma_NQSO_minC_N=zeros(1,length(gamma));
% calibrateSigma_NQSO_minC_sigma=zeros(1,length(gamma));
% for j=1:length(gamma)
%     min_C=result_prefer_NQSO_minCost_C(1,j);
%     for i=1:length(sigma)
%         if(result_prefer_NQSO_minCost_C(i,j)<=min_C)
%             min_C = result_prefer_NQSO_minCost_C(i,j);
%             calibrateSigma_NQSO_minC_N(j)=result_prefer_NQSO_minCost(i,j);
%             calibrateSigma_NQSO_minC_sigma(j)=sigma(i);
%         end
%     end
% end
% 
% % QSO calibrate sigma
% calibrateSigma_QSO_maxA_N=zeros(1,length(gamma));
% calibrateSigma_QSO_maxA_sigma=zeros(1,length(gamma));
% for j=1:length(gamma)
%     max_A=0;
%     for i=1:length(sigma)
%         if(result_prefer_QSO_maxAsset_A(i,j)>=max_A)
%             max_A = result_prefer_QSO_maxAsset_A(i,j);
%             calibrateSigma_QSO_maxA_N(j)=result_prefer_QSO_maxAsset(i,j);
%             calibrateSigma_QSO_maxA_sigma(j)=sigma(i);
%         end
%     end
% end
% 
% calibrateSigma_QSO_maxE_N=zeros(1,length(gamma));
% calibrateSigma_QSO_maxE_sigma=zeros(1,length(gamma));
% for j=1:length(gamma)
%     max_E=0;
%     for i=1:length(sigma)
%         if(result_prefer_QSO_maxEquity_E(i,j)>=max_E)
%             max_E = result_prefer_QSO_maxEquity_E(i,j);
%             calibrateSigma_QSO_maxE_N(j)=result_prefer_QSO_maxEquity(i,j);
%             calibrateSigma_QSO_maxE_sigma(j)=sigma(i);
%         end
%     end
% end
% 
% calibrateSigma_QSO_minC_N=zeros(1,length(gamma));
% calibrateSigma_QSO_minC_sigma=zeros(1,length(gamma));
% for j=1:length(gamma)
%     min_C=result_prefer_QSO_minCost_C(1,j);
%     for i=1:length(sigma)
%         if(result_prefer_QSO_minCost_C(i,j)<=max_C)
%             min_C = result_prefer_QSO_minCost_C(i,j);
%             calibrateSigma_QSO_minC_N(j)=result_prefer_QSO_minCost(i,j);
%             calibrateSigma_QSO_minC_sigma(j)=sigma(i);
%         end
%     end
% end
%         
% 
