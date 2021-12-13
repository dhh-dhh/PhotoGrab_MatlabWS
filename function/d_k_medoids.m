% %  k中心点聚类
function []=d_k_medoids(PXY,num)
            [idx,C] = kmedoids(PXY,num);
%             k_mean=[idx,(1:size(PXY,1))',PXY];
%             k_sort=sortrows(k_mean,1);
%             j=1;
%             figure()
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
%             plot(C(:,1),C(:,2),'+r');
%             title('k-中心点聚类');
%             hold off;
            
            figure();
            gscatter(PXY(:,1),PXY(:,2),idx);
            title('k中心点聚类')
end