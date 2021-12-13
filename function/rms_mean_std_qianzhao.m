% % 新的std_前照文章
function [std_ttxy1_bdb,test1]=rms_mean_std_qianzhao(XX,YY)
cha_xx1=[];cha_yy1=[];cha_xy_xx_yy_sort_m5=[];cha_xy_xx_yy_m5=[];
%             五张叠加
for i=1:size(XX,2)/5
    XX_m(:,i)=mean(XX(:,i*5-4:i*5),2);
    YY_m(:,i)=mean(YY(:,i*5-4:i*5),2);
end

for i=1:size(XX_m,2)
    cha_xx1(:,i) = XX_m(:,i) - mean(XX_m,2);
    cha_yy1(:,i) = YY_m(:,i) - mean(YY_m,2);
end
%             for i=1:size(XX,2)
%                 cha_xx1(:,i) = XX(:,i) - XX(:,1);
%                 cha_yy1(:,i) = YY(:,i) - YY(:,1);
%             end

cha_xy=sqrt(cha_xx1(:,:).*cha_xx1(:,:) + cha_yy1(:,:).*cha_yy1(:,:));


%             mean_mean_cha_xy=mean(mean(cha_xy,2));std_cha_xy=std(cha_xy,0,2);mean_cha_xy=mean(cha_xy,2);std_std_cha_xy=std(std_cha_xy);


%             排序筛选
mean_mean_cha_xy=mean(mean(cha_xy,2));std_cha_xy=std(cha_xy,0,2);mean_cha_xy=mean(cha_xy,2);std_std_cha_xy=std(cha_xy);
cha_xy_xx_yy=[mean_cha_xy,cha_xy];XX_m=[mean_cha_xy,XX_m];YY_m=[mean_cha_xy,YY_m];
cha_xy_xx_yy_sort=sortrows(cha_xy_xx_yy,1);XX_m=sortrows(XX_m,1);YY_m=sortrows(YY_m,1);
tt=1;
if tt==1
%                 cha_xy_xx_yy_sort(:,1)=[];cha_xy_xx_yy_sort(7:end,:)=[];  
                XX_m(:,1)=[];YY_m(:,1)=[];
%                 XX_m(7:end,:)=[];YY_m(7:end,:)=[]; %%danyuan筛好
elseif tt==2
%                  cha_xy_xx_yy_sort(:,1)=[];cha_xy_xx_yy_sort=cha_xy_xx_yy_sort(end-5:end,:);
                 XX_m(:,1)=[];YY_m(:,1)=[];
%                  XX_m(1:end-28,:)=[];YY_m(:,1)=[];YY_m(1:end-28,:)=[];
elseif tt==3
    cha_xy_xx_yy_sort(:,1)=[];cha_xy_xx_yy_sort(29:end,:)=[]; XX_m(:,1)=[];XX_m(29:end,:)=[];YY_m(:,1)=[];YY_m(29:end,:)=[]; %%bdb%%筛好
elseif tt==4
    cha_xy_xx_yy_sort(:,1)=[];cha_xy_xx_yy_sort=cha_xy_xx_yy_sort(end-27:end,:);XX_m(:,1)=[];XX_m(1:end-28,:)=[];YY_m(:,1)=[];YY_m(1:end-28,:)=[];
end

cha_xy_xx_yy_sort_mean=mean(cha_xy_xx_yy_sort);
cha_xy_xx_yy_sort_m5=[cha_xy_xx_yy_sort_mean;cha_xy_xx_yy_sort];
cha_xy_xx_yy_sort_m5_sort=sortrows(cha_xy_xx_yy_sort_m5');cha_xy_xx_yy_sort_m5_sort=cha_xy_xx_yy_sort_m5_sort';
%
if tt==1||tt==3
    cha_xy_xx_yy_sort_m5_sort(1,:)=[];cha_xy_xx_yy_sort_m5_sort=cha_xy_xx_yy_sort_m5_sort(:,1:20); %%筛好
else
    cha_xy_xx_yy_sort_m5_sort(1,:)=[];cha_xy_xx_yy_sort_m5_sort=cha_xy_xx_yy_sort_m5_sort(:,end-19:end);
end

%             cha_xy_xx_yy_sort_m5_sort=abs(cha_xy_xx_yy_sort_m5_sort-0.3);%%-0.2
figure(); %%二维分布
XX_m(:,21:end)=[]; YY_m(:,21:end)=[];
for i=1:size(XX_m,1)
    XX_m(i,:)=XX_m(i,:)-mean(XX_m(i,:));
    YY_m(i,:)=YY_m(i,:)-mean(YY_m(i,:));
end

if tt==3||tt==4
    t=3;
    for i=1:size(XX_m,1) %%标准靶28个点
        tx=mod(i-1,7);ty=fix((i-1)/7)
        XX_m(i,:)= XX_m(i,:)+tx*t;
        YY_m(i,:)= YY_m(i,:)+ty*t;
    end
    plot(XX_m(),YY_m(),'.');axis equal;
else
    for i=1:size(XX_m,1) %%单元7个点
        
        if i==1
            XX_m(i,:)= XX_m(i,:)-2;
            YY_m(i,:)= YY_m(i,:)+3;
        elseif i==2
            XX_m(i,:)= XX_m(i,:)+2;
            YY_m(i,:)= YY_m(i,:)+3;
        elseif i==3
            XX_m(i,:)= XX_m(i,:)-3.5;
            YY_m(i,:)= YY_m(i,:);
        elseif i==4
            XX_m(i,:)= XX_m(i,:);
            YY_m(i,:)= YY_m(i,:);
        elseif i==5
            XX_m(i,:)= XX_m(i,:)+3.5;
            YY_m(i,:)= YY_m(i,:);
        elseif i==6
            XX_m(i,:)= XX_m(i,:)-2;
            YY_m(i,:)= YY_m(i,:)-3;
        elseif i==7
            XX_m(i,:)= XX_m(i,:)+2;
            YY_m(i,:)= YY_m(i,:)-3;
        end
    end
    plot(XX_m(),YY_m(),'.');axis equal;set(gca,'XLim',[-5 5]);set(gca,'YLim',[-5 5]);
end





if tt==1||tt==3
    title('front-illumination');xlabel('x axis(um)');ylabel('y axis(um)'); %%set(gca,'XLim',[1 20]);set(gca,'YLim',[0 3.5]);
else
    title('back-illumination');xlabel('x axis(um)');ylabel('y axis(um)'); %%set(gca,'XLim',[1 20]);set(gca,'YLim',[0 3.5]);
end
figure(); %% 概率线条
for i=1:size(cha_xy_xx_yy_sort_m5_sort,1)
    [a(i), b(i)] = normfit(cha_xy_xx_yy_sort_m5_sort(i,:));%求出你bai给的服从du正态分布的数据的均值zhi和标准差，并dao赋给a,b
    
    d = normpdf(cha_xy_xx_yy_sort_m5_sort(i,:),a(i),b(i));
    nor_xy=[cha_xy_xx_yy_sort_m5_sort(i,:)',d'];
    %                 sort(nor_xy,'row')
    %     nor_xy(:,2)=nor_xy(:,2)/sum(nor_xy(:,2))*100;
    nor_xy(:,2)=nor_xy(:,2);
    nor_xy=sortrows(nor_xy,1);
    plot(nor_xy(:,1),nor_xy(:,2),'-');%以data为横坐标，d为纵坐标画出图形，‘.’为 图形各点的样式
    hold on
end
if tt==2||tt==4
    title('back-illumination');xlabel('Deviation from mean position (um)');ylabel('Probability'); %%set(gca,'XLim',[1 20]);set(gca,'YLim',[0 3.5]);
else
    title('front-illumination');xlabel('Deviation from mean position (um)');ylabel('Probability'); %%set(gca,'XLim',[1 20]);set(gca,'YLim',[0 3.5]);
end

hold off


figure();%%时间分布
for i=1:size(cha_xy_xx_yy_sort_m5_sort,1)
    plot(cha_xy_xx_yy_sort_m5_sort(i,:));hold on;
end
if tt==2||tt==4
    title('back-illumination');set(gca,'XLim',[1 20]);set(gca,'YLim',[0 3.5]);xlabel('time (minutes)');ylabel('distance(microns)');
else
    title('front-illumination');set(gca,'XLim',[1 20]);set(gca,'YLim',[0 3.5]);xlabel('time (minutes)');ylabel('distance(microns)');
end
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
    mean_std_xy(i,2)=std(cha_xy_xx_yy_sort_m5_sort(i,:));
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