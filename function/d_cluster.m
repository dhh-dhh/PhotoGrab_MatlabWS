% %  层次聚类
function []=d_cluster(X)
    figure()
    rng('default'); % For reproducibility
    scatter(X(:,1),X(:,2));
    
    Z = linkage(X,'ward');
    dendrogram(Z)
    T = cluster(Z,'cutoff',3,'Depth',4);
    figure();
    gscatter(X(:,1),X(:,2),T)
    title('层次聚类');
end