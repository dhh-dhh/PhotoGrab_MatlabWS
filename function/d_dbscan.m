% %  Density-based spatial clustering of applications with noise (DBSCAN)
% 基于密度聚类
function []=d_dbscan(X,epsilon,minpts)
    figure();
    idx = dbscan(X,epsilon,minpts);
    gscatter(X(:,1),X(:,2),idx);
    title('基于密度的含噪数据空间聚类')
end