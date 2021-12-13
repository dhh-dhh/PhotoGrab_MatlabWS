% %  ×î½üÁÚ
function []=d_KNN(X)
load fisheriris
Y = species;     % Response

MdlES = ExhaustiveSearcher(X);
MdlKDT  = KDTreeSearcher(X);
IdxKDT = knnsearch(MdlKDT,Y);
IdxES = knnsearch(MdlES,Y);
[IdxKDT IdxES]

load fisheriris
X = meas(:,3:4); % Predictors
Y = species;     % Response
KDTreeMdl = KDTreeSearcher(X,'Distance','minkowski','P',5);
newpoint = [5 1.45];
[IdxMk,DMk] = knnsearch(KDTreeMdl,newpoint,'k',10);
[IdxCb,DCb] = knnsearch(KDTreeMdl,newpoint,'k',10,'Distance','chebychev');
figure;
gscatter(X(:,1),X(:,2),Y);
title('Fisher''s Iris Data -- Nearest Neighbors');
xlabel('Petal length (cm)');
ylabel('Petal width (cm)');
hold on
plot(newpoint(1),newpoint(2),'kx','MarkerSize',10,'LineWidth',2);   % Query point 
plot(X(IdxMk,1),X(IdxMk,2),'o','Color',[.5 .5 .5],'MarkerSize',10); % Minkowski nearest neighbors
plot(X(IdxCb,1),X(IdxCb,2),'p','Color',[.5 .5 .5],'MarkerSize',10); % Chebychev nearest neighbors
legend('setosa','versicolor','virginica','query point',...
   'minkowski','chebychev','Location','Best');
% h = gca; % Get current axis handle.
% h.XLim = [4.5 5.5];
% h.YLim = [1 2];
% axis square;

end