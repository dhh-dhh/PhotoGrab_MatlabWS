% % 新的std_前照文章  
function [std_ttxy1_bdb,test1]=rms_mean_std_shaixuan(XX,YY)
cha_xx1=[];cha_yy1=[];cha_xy_xx_yy_sort_m5=[];cha_xy_xx_yy_m5=[];
            for i=1:size(XX,2)
                cha_xx1(:,i) = XX(:,i) - mean(XX,2);
                cha_yy1(:,i) = YY(:,i) - mean(YY,2);
            end
            cha_xy=sqrt(cha_xx1(:,:).*cha_xx1(:,:) + cha_yy1(:,:).*cha_yy1(:,:));
            
            
            mean_mean_cha_xy=mean(mean(cha_xy,2));std_cha_xy=std(cha_xy,0,2);mean_cha_xy=mean(cha_xy,2);std_std_cha_xy=std(std_cha_xy);
            
%             五张叠加
            for i=1:size(cha_xy,2)/5
                cha_xy_xx_yy_m5(:,i)=mean(cha_xy(:,i*5-4:i*5),2);
            end
%             排序筛选
            mean_mean_cha_xy=mean(mean(cha_xy_xx_yy_m5,2));std_cha_xy=std(cha_xy_xx_yy_m5,0,2);mean_cha_xy=mean(cha_xy_xx_yy_m5,2);std_std_cha_xy=std(cha_xy_xx_yy_m5);
            cha_xy_xx_yy=[mean_cha_xy,cha_xy_xx_yy_m5];
            cha_xy_xx_yy_sort=sortrows(cha_xy_xx_yy,1);
            cha_xy_xx_yy_sort(:,1)=[];cha_xy_xx_yy_sort(7:end,:)=[];  %%筛好
%             cha_xy_xx_yy_sort(:,1)=[];cha_xy_xx_yy_sort=cha_xy_xx_yy_sort(end-5:end,:);
            
            
            
            cha_xy_xx_yy_sort_mean=mean(cha_xy_xx_yy_sort);
            cha_xy_xx_yy_sort_m5=[cha_xy_xx_yy_sort_mean;cha_xy_xx_yy_sort];
            cha_xy_xx_yy_sort_m5_sort=sortrows(cha_xy_xx_yy_sort_m5');cha_xy_xx_yy_sort_m5_sort=cha_xy_xx_yy_sort_m5_sort';
%             
            cha_xy_xx_yy_sort_m5_sort(1,:)=[];cha_xy_xx_yy_sort_m5_sort=cha_xy_xx_yy_sort_m5_sort(:,1:20); %%筛好
%             cha_xy_xx_yy_sort_m5_sort(1,:)=[];cha_xy_xx_yy_sort_m5_sort=cha_xy_xx_yy_sort_m5_sort(:,end-19:end);
            
            cha_xy_xx_yy_sort_m5_sort=abs(cha_xy_xx_yy_sort_m5_sort-0.3);%%-0.2
            figure();
            
            for i=1:size(cha_xy_xx_yy_sort_m5_sort,1)
                plot(cha_xy_xx_yy_sort_m5_sort(i,:));hold on;
            end
%             title('back-illumination');set(gca,'XLim',[1 20]);set(gca,'YLim',[0 0.5]);xlabel('time (minutes)');ylabel('position(microns)');
            title('front-illumination');set(gca,'XLim',[1 20]);set(gca,'YLim',[0 1]);xlabel('time (minutes)');ylabel('position(microns)');
            hold off;
%             D:\段仕鹏\NOW\前照法\图片\前照文章最终图片\大修1
%             for i=size(cha_xy,1):-1:1
%                 for j=size(cha_xy,2):-1:1
%                     if mean_cha_xy(i,1)>5
%                         cha_xy(i,:)=[];cha_xx1(i,:)=[];cha_yy1(i,:)=[];
%                         break;
%                     end
%                 end
%             end
            cha_xy_xx_yy_sort_m5_sort=floor(cha_xy_xx_yy_sort_m5_sort*100)/100;
            for i=1:size(cha_xy_xx_yy_sort_m5_sort,1)
                std_ttxy1_bdb(i,1)=sqrt(sum(cha_xy_xx_yy_sort_m5_sort(i,:).*cha_xy_xx_yy_sort_m5_sort(i,:))/size(cha_xy_xx_yy_sort_m5_sort,2));
            end
             mean_std_xy(:,1)=mean(cha_xy_xx_yy_sort_m5_sort,2);
            for i=1:size(cha_xy_xx_yy_sort_m5_sort,1)
                mean_std_xy(:,2)=std(cha_xy_xx_yy_sort_m5_sort(i,:));
            end
            test1(2:3,1)=mean(mean_std_xy(:,1:2),1)';
            test1(1,1)=mean(std_ttxy1_bdb);
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
%             for i=1:size(cha_xy,1)
%                 std_ttxy1(i,1)=sqrt(sum(cha_xy(i,:).*cha_xy(i,:))/size(cha_xy,2));
%             end
%             
%             
%             figure();
%             for i=1:size(cha_xy,1)
%                 plot(cha_xy(i,:));hold on;
%             end
%             title('xy');
%             hold off;
%             figure();
%              mean_std_xy(:,1)=mean(cha_xy,2);
%             for i=1:size(cha_xy,1)
%                 mean_std_xy(:,2)=std(cha_xy(i,:));
%             end
%              test(2:3,1)=mean(mean_std_xy(:,1:2),1)';
%             test(1,1)=mean(std_ttxy1);
            
            
            
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