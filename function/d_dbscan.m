% %  Density-based spatial clustering of applications with noise (DBSCAN)
% �����ܶȾ���
function []=d_dbscan(X,epsilon,minpts)
    figure();
    idx = dbscan(X,epsilon,minpts);
    gscatter(X(:,1),X(:,2),idx);
    title('�����ܶȵĺ������ݿռ����')
end