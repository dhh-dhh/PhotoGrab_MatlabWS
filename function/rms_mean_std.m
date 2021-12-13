% % 新的std_前照文章
function [std_ttxy1,test]=rms_mean_std(XX,YY)
cha_xx1=[];cha_yy1=[];cha_xy_xx_yy_sort_m5=[];cha_xy_xx_yy_m5=[];
            for i=1:size(XX,2)
                cha_xx1(:,i) = XX(:,i) - mean(XX,2);
                cha_yy1(:,i) = YY(:,i) - mean(YY,2);
            end
            cha_xy=sqrt(cha_xx1(:,:).*cha_xx1(:,:) + cha_yy1(:,:).*cha_yy1(:,:));
            
            
            for i=1:size(cha_xy,1)
                std_ttxy1(i,1)=sqrt(sum(cha_xy(i,:).*cha_xy(i,:))/size(cha_xy,2));
            end
            
            
%             figure();
%             for i=1:size(cha_xy,1)
%                 plot(cha_xy(i,:));hold on;
%             end
%             title('xy');
%             hold off;
%             figure();
             mean_std_xy(:,1)=mean(cha_xy,2);
            for i=1:size(cha_xy,1)
                mean_std_xy(i,2)=std(cha_xy(i,:));
            end
            test(2:3,1)=mean(mean_std_xy(:,1:2),1)';
            test(1,1)=mean(std_ttxy1);
%             
            
            
%             for i=1:size(cha_xx1,1)
%                 plot(cha_xx1(i,:));hold on;
%             end
%             title('x');
%             hold off;
%             figure();
%             title('y');
%             for i=1:size(cha_yy1,1)
%                 plot(cha_yy1(i,:));hold on;
%             end
%             title('y');
%             hold off;
            
            
%             test(1,1)=sqrt(sum(std_ttxy1.*std_ttxy1/(size(std_ttxy1,1))));
%             test(2,1)=mean(std_ttxy1);
%             test(3,1)=std(std_ttxy1);
% %             xy=sqrt(cha_xx.^2+cha_yy.^2);

           

%              for i=size(std_ttxy1):-1:1
% %                 if std_ttxy1(i,1)>10 || std_ttxy1(i,1)==0;
%                 if std_ttxy1(i,1)>10*mean(std_ttxy1) || std_ttxy1(i,1)==0;
%                     std_ttxy1(i,:)=[];mean_std_xy(i,:)=[];
%                 end
%             end
           
end



% xy=sqrt(cha_xx.^2+cha_yy.^2);
% mean_std_xy(:,1)=mean(xy,2);
% for i=1:size(xy,1)
%     mean_std_xy(:,2)=std(xy(i,:));
% end
% mean_end1=mean(mean_std_xy(:,1:2),1);
% cha_xy=sqrt(cha_xx(:,:).*cha_xx(:,:) + cha_yy(:,:).*cha_yy(:,:));
% for i=1:size(cha_xy,1)
%     std_xy(i,1)=sqrt(sum(cha_xy(i,:).*cha_xy(i,:))/size(cha_xy,2));
% end
% mean_end1(1,3)=mean(std_xy);
% mean_end1(2,1)=mean(std_xy);
% mean_end1(2,2)=std(std_xy);
% mean_end1(2,3)=sqrt(sum(std_xy.*std_xy/size(std_xy,1)));