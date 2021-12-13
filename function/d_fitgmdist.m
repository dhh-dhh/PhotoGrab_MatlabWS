% %  高斯混合模型
function []=d_fitgmdist(X,num)
GMModel = fitgmdist(X,num);
figure();
plot(GMModel.mu(:,1),GMModel.mu(:,2),'+r');hold on;
y = zeros(size(X,1),1);
h = gscatter(X(:,1),X(:,2),y);
hold on
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(GMModel,[x0 y0]),x,y);
g = gca;
fcontour(gmPDF,[g.XLim g.YLim])
title('高斯混合模型')
legend(h,'Model 0','Model1')
hold off

end