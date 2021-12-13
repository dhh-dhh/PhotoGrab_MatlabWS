%% 通过像素寻找参考光纤
clear;close all;
% 输入：像素坐标
% 通过像素遍历同心圆来判断同心圆中光斑数量>fiberNumThreshold的作为参考光纤
% 再通过聚类算法聚类出 FFNum 个参考光纤
% 求取同类均值后进行排序
% 拟合圆心
% 输出：FF初始像素位置
addpath('function');
F_N='data/211213_155119_00_000_00_xy.txt';%把相机txt文件名称复制进去
sortRows=21; % 排序行数（所有光纤的行数
FFNum=36; % 参考光纤数量
findStep=5;%同心圆搜索光纤 步长
fiberNumThreshold=5; % 同心圆搜索光纤数量阈值
rMax=85;rMin=75; % 同心圆半径范围

D_Y=[];
fid=fopen(F_N,'r');
UnitName=[];nux=[];nuy=[];
m=0;
while ~feof(fid)
    m=m+1;
    D_Y=fscanf(fid,'%s',1);
    G_D_x(m)=fscanf(fid,'%f',1);
    G_D_y(m)=fscanf(fid,'%f',1);
    if strcmp(D_Y(1),'P')||strcmp(D_Y(1),'Q')
        px(m)=fscanf(fid,'%f',1);
        py(m)=fscanf(fid,'%f',1);
    else
        nux=[nux,fscanf(fid,'%f',1)];
        nuy=[nuy,fscanf(fid,'%f',1)];
    end
    fgetl(fid);
end
fclose(fid);
figure(1)
plot(G_D_x,G_D_y,'.b');title('\fontname{宋体} 初始拟合微米')
%             for i=size(G_D_x,2):-1:1
%                if  (G_D_x(1,i)>3000 || G_D_x(1,i)<-3000 || G_D_y(1,i)>3000 || G_D_y(1,i)<-3000|| isnan(G_D_y(1,i)) || isnan(G_D_x(1,i)))
%                    G_D_x(:,i)=[];
%                    G_D_y(:,i)=[];
%                end
%             end
allPointX=[px';nux'];allPointY=[py';nuy'];
FFLiLun=load('FFLilun_LL.txt');
figure(2)
plot(allPointX,allPointY,'.b');title('\fontname{宋体} .点为像素')
% axis([-3000, 3000, -3000, 3000]);
% figure(3)
% plot(FFLiLun(:,1),FFLiLun(:,2),'+r');title('\fontname{宋体} +为理论')

[annulusList]=f_findAnnulus(allPointX,allPointY,rMin,rMax,findStep,fiberNumThreshold);
idx = kmeans(annulusList,FFNum);
figure(3)
gscatter(annulusList(:,1),annulusList(:,2),idx);
title('\fontname{宋体}K均值聚类')
FFCircleRaw=zeros(FFNum,2);
for i=1:max(idx)
   oneFF=[];
   for j=1:size(idx,1)
       if(idx(j,1)==i)
          oneFF=[oneFF;annulusList(j,:)] ;
       end
   end
   FFCircleRaw(i,:)=mean(oneFF,1);
end
[FFCircleSort(:,1),FFCircleSort(:,2)]=f_sort_rect(sortRows,FFCircleRaw);

%% 计算圆心 
PX=allPointX;PY=allPointY;dis=[];
for i=1:size(FFCircleSort,1)
    dis(:,i)=sqrt((PX(:,1)-FFCircleSort(i,1)).^2+(PY(:,1)-FFCircleSort(i,2)).^2);
end
for i=1:size(dis,2)
    FF_x=[];FF_y=[];
    [x,y]=find(dis(:,i)<rMax & dis(:,i)>rMin);
    for j=1:size(x,1)
        FF_x=[FF_x;PX(x(j,1),:)];
        FF_y=[FF_y;PY(x(j,1),:)];
    end
    
    [x0,y0,r0,n1,n2,cha] = f_NiheCircle(FF_x,FF_y,0,1);
    pxy_c(i,1)=x0;
    pxy_c(i,2)=y0;
    pxy_r(i,1)=r0;
    
end
figure(4)
plot(allPointX,allPointY,'.b');title('\fontname{宋体} .点为像素 o为拟合圆心')
hold on;plot(pxy_c(:,1),pxy_c(:,2),'og');

chaRawC=FFCircleSort-pxy_c;
std(chaRawC,1)
