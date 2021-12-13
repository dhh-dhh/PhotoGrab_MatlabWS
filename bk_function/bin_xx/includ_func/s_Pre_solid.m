%%%%%%得到所有光点的坐标xx，yy(fendu_times,paohe_turns,light_num)
%%所有坐标与固定光纤做差，得到相对坐标；同时mean掉repeat
% 坐标平移

%2017.7.5 lzg start

if isempty(solid_x)
    origin_x=0; 
    origin_y=0;
else
    origin_x=mean(solid_x,4); 
    origin_y=mean(solid_y,4);
end

figure(100);
subplot(2,1,1);
plot(origin_x(:));
subplot(2,1,2);
plot(origin_y(:));
figurename = strcat(dataDir,'\P_Solid_',subDir,'.jpg');
saveas(gcf,figurename);
 
temp_x=zeros(repeat_times,fendu_times,paohe_turns,light_num);%用于保存每点的行列值的矩阵，(重复次数，分度次数，跑合次数，光点数）
temp_y=zeros(repeat_times,fendu_times,paohe_turns,light_num);%用于保存每点的行列值的矩阵
for u=1:light_num
    temp_x(:,:,:,u)=(all_x(:,:,:,u)-origin_x);
    temp_y(:,:,:,u)=(all_y(:,:,:,u)-origin_y);          %%%%  用于像素
end

%处理repeat
xx1=mean(temp_x,1);
yy1=mean(temp_y,1);
xx=zeros(fendu_times,paohe_turns,light_num);%用于保存每点的行列值的矩阵，(分度次数，跑合次数，光点数）
yy=zeros(fendu_times,paohe_turns,light_num);%用于保存每点的行列值的矩阵
xx(:,:,:)=xx1(1,:,:,:);
yy(:,:,:)=yy1(1,:,:,:);

