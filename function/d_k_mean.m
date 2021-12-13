% %  K均值聚类
function []=d_k_mean(PXY,num)
    idx = kmeans(PXY,num);
%             k_mean=[idx,(1:size(PXY,1))',PXY];
%             k_sort=sortrows(k_mean,1);
%             j=1;
            figure()
%             
%             map = [0.2 0.1 0.5
%                 0.1 0.5 0.8
%                 0.2 0.7 0.6
%                 0.8 0.7 0.3
%                 0.9 1 0
%                 1 0 1
%                 0 1 1
%                 1 0 0
%                 ];
%             for i=1:k_sort(end,1)
%                 while j<=size(k_sort,1) && k_sort(j,1)==i 
%                     colormap (flag);
%                     plot(k_sort(j,3),k_sort(j,4),'.','color',map(mod(i,size(map,1)),:));
%                     hold on;
%                     j=j+1;
%                 end
%                 
%             end
%             title('k-均值聚类');
%             hold off;
            
            
            gscatter(PXY(:,1),PXY(:,2),idx);
            title('K均值聚类')
end