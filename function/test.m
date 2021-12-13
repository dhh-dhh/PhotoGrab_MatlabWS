rng('default'); % For reproducibility
X = [(randn(20,2)*0.75)+1;
    (randn(20,2)*0.25)-1];
scatter(X(:,1),X(:,2));
title('Randomly Generated Data');
Z = linkage(X,'ward');
dendrogram(Z)
T = cluster(Z,'cutoff',3,'Depth',4);
gscatter(X(:,1),X(:,2),T)