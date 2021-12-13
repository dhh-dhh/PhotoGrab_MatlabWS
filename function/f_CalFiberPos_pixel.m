function  [positions] =f_CalFiberPos_pixel(data)
positioner_number=0;
FlagEnergy=1;                     %  1灰度;2灰度平方
FlagBackGround=0;                 %  0不减背景值；1减背景值
intImageHeight =6004;            %照片高度4096
intImageWidth = 7920;            %照片长度4096
% intImageHeight =2048;            %照片高度4096
% intImageWidth = 2048;            %照片长度4096

%                  intImageHeight =7920;            %照片高度4096
%                 intImageWidth = 6004;            %照片长度4096

% intLightThreshold =mean(mean(data(:,:),1))+30*std(std(data(:,:),1));  %           %亮点阈值暂定600
% intBkThreshold =mean(mean(data(:,:),1))+10*std(std(data(:,:),1)); %               %背景阈值暂定250


intLightThreshold =500;  %           %亮点阈值暂定600
intBkThreshold =400; %               %背景阈值暂定250
% nImageType =3 ;                   %沿X轴方向翻转，例如焦面前活动测量支架上4K相机
% nihe_FN='3.tif';
Percent=0.8;
AllowError=1;
% data=imread(nihe_FN,'tif');
[XY4,FiberEnergy]  =  f_CalFiberPos_Energy(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,FlagEnergy,FlagBackGround);



[a , b ]=size(XY4);

k=1;
%%%%%%%%% 将光斑小于5个像元的光点删除；
while k <= a
    
    if XY4(k,4) < 5
        
        XY4(k,:)=[];
        
        k=k-1;
        a=a-1;
    end
    
    k=k+1;
    
    
end

[a, b]=size(XY4);

% for j=1:a
%     
%     alldots(1:a,:,i)=XY4;
%     
% end

tempXY4 = XY4(positioner_number+1:a,:);  %% 将所有含零的数据清除
positioner_number=0;   % 以上两项是计算所有参考光纤点，下面 则是计算定位单元的光斑的稳定。
SortXX=tempXY4(:,1);
SortYY=tempXY4(:,2);
SortWW=tempXY4(:,3);
SortZZ=tempXY4(:,4);
[aa, bb]= size(SortXX);
%                 SortXX = imrotate(SortXX,90);
%                 SortYY = imrotate(SortYY,90);
%                 SortXX = imrotate(SortXX,90);
%                 SortXX = imrotate(SortXX,90);

for m=1:aa
    positions(1:m,1)=SortXX(1:m,1);
    positions(1:m,2)=SortYY(1:m,1);
    positions(1:m,3)=SortWW(1:m,1);
    positions(1:m,4)=SortZZ(1:m,1);
end
end