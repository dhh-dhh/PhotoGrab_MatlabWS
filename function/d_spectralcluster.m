% %  Æ×¾ÛÀà
% %  https://www.cnblogs.com/pinard/p/6221564.html
function []=d_spectralcluster(X,num)
    figure();
    idx = spectralcluster(X,num);
    gscatter(X(:,1),X(:,2),idx);
    title('Æ×¾ÛÀà');
end