function  [XY4,FiberEnergy] =f_CalFiberPos_Energy(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,FlagEnergy,FlagBackGround)
%function  [XYMN] =CalFiberPos(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,mytitle)
%八点连通域收索
%利用光重心法计算光纤位置,处理一张图片上的光纤位置，得到各光纤位置坐标、各位置的的最大灰度值以及像素数,以及各个光斑的能量
%
%Input:
%   data:                       灰度矩阵
%	intImageHeight = 2048;  	照片高度2048
%	intImageWidth  = 2048;      照片长度2048
%	intLightThreshold = 300;	亮点阈值暂定300
% 	intBkThreshold = 100;       背景阈值暂定100
%	nImageType =0;              0:不需要偏转    1：沿X轴方向翻转，例如2K相机
%Output:
%   XY4(:,1) = XX          光纤位置x坐标
%	XY4(:,2) = YY          光纤位置y坐标
%	XY4(:,3) = MM          每个光纤位置的最大灰度值
%	XY4(:,4) = Num         每个光纤位置像素数
%   FiberEnergy

% 2013_06_10   start

% if nargin <5
%     errordlg('缺少输入参数');
%     return
% end
% if nargin < 6                       %输入参数=6时 ，画理论坐标
%     ifdraw = 0;
% else
%     ifdraw = 1;
% end

intCounter = 0;
NumDui=512*512;
m_nDui = zeros(3,NumDui);
for i=1:intImageHeight
    for j=1:intImageWidth
        if data(i,j) > intLightThreshold   %可能存在一个亮点
            sumRow=0;
            sumCol=0;
            SumGray=0;
            m_nTop = 1;
            m_nBottom = 1;
            mm = 0;
            m_nDui(1,m_nBottom) = i;
            m_nDui(2,m_nBottom) = j;
            m_nDui(3,m_nBottom) = data(i,j);
            data(i,j) = 0;
            m_nBottom = m_nBottom + 1;
            if m_nBottom > NumDui
                m_nBottom=1;
            end
            while m_nTop ~= m_nBottom
                p = m_nDui(1,m_nTop);
                q = m_nDui(2,m_nTop);
                g = m_nDui(3,m_nTop);
                if mm < g
                    mm=g;
                end
                sumRow = sumRow + p * g;      %像素加权x坐标和，权值为灰度值
                sumCol = sumCol + q * g;      %像素加权y坐标和，权值为灰度值
                SumGray = SumGray + g;        %像素灰度值和
                m_nTop = m_nTop + 1;          %索引值加1
                if m_nTop > NumDui
                    m_nTop = 1;
                end
                m1 = p-1;
                if m1 < 1
                    m1 = 1;
                end
                m2 = p+1;
                if m2 > intImageHeight
                    m2 =intImageHeight;
                end
                n1 = q-1;
                if n1 < 1
                    n1=1;
                end
                n2 = q+1;
                if n2 > intImageWidth
                    n2=intImageWidth;
                end
                for  m=m1:m2                   %已找到的亮点向四周扩散1个像素
                    for n=n1:n2
                        if data(m,n) > intBkThreshold
                            m_nDui(1,m_nBottom) = m;
                            m_nDui(2,m_nBottom) = n;
                            m_nDui(3,m_nBottom) = data(m,n);
                            data(m,n) = 0;
                            m_nBottom = m_nBottom + 1;
                            if m_nBottom > NumDui
                                m_nBottom = 1;
                            end
                        end
                    end
                end
            end
            intCounter = intCounter + 1;
            YY(intCounter) = sumRow / SumGray;            %加权和除以权和得y->row
            XX(intCounter)= sumCol / SumGray;             %加权和除以权和得x->col
            MM(intCounter) = mm;                          %最大灰度值
            Num(intCounter) = m_nTop-1 ;                  %像素数
            
            if FlagBackGround==1
               Energy = m_nDui(3,1:(m_nTop-1))-intBkThreshold;
            elseif FlagBackGround==0
                Energy = m_nDui(3,1:(m_nTop-1));
            end
            if FlagEnergy==2
                Energy=Energy.^2;
            end
            FiberEnergy(intCounter,1)=sum(Energy); 
            
        end
    end
end

XY4(:,1) = XX(1:intCounter) ;%:col
XY4(:,2) = YY(1:intCounter) ;%:row
XY4(:,3) = MM(1:intCounter) ;
XY4(:,4) = Num(1:intCounter) ;

% if ifdraw == 1
%     plot(XY4(:,1),XY4(:,2),'*');
% end
return



% fn ='..\testdata\Image_2048.raw';
% intImageHeight = 2048;          %照片高度2048
% intImageWidth = 2048;           %照片长度2048
% intLightThreshold = 300;        %亮点阈值暂定300
% intBkThreshold = 100;           %背景阈值暂定100
% nImageType =1;                  %沿X轴方向翻转，例如2K相机
% ifdraw = 1;
% data =f_ReadImage(fn,intImageHeight,intImageWidth,nImageType,ifdraw);
% [XYMN] =f_CalFiberPos(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,ifdraw);



% fn = '..\test\image_xiangxian3.tif';
% intImageHeight = 4096;          %照片高度2048
% intImageWidth = 4096;           %照片长度2048
% intLightThreshold = 500;        %亮点阈值暂定300
% intBkThreshold = 200;           %背景阈值暂定100
% nImageType =3;                  %沿X轴方向翻转，例如2K相机
% ifdraw = 1;
% data =f_ReadImage(fn,intImageHeight,intImageWidth,nImageType,ifdraw);
% [XYMN] =f_CalFiberPos(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,ifdraw);
