%% 通过初值寻找参考光纤
clear;close all;
initOnePoint=[-572.735551408278	2130.76815761261];
addpath('function');addpath(genpath(pwd));
F_N='211212_111713_00_000_00_xy.txt';%把相机txt文件名称复制进去
% % 参考光纤单元稳定性
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
figure(99)
plot(G_D_x,G_D_y,'.b')
%             for i=size(G_D_x,2):-1:1
%                if  (G_D_x(1,i)>3000 || G_D_x(1,i)<-3000 || G_D_y(1,i)>3000 || G_D_y(1,i)<-3000|| isnan(G_D_y(1,i)) || isnan(G_D_x(1,i)))
%                    G_D_x(:,i)=[];
%                    G_D_y(:,i)=[];
%                end
%             end
FFCircle=load('FFCircle.txt');
figure(1)
plot(px,py,'.b');hold on;plot(nux,nuy,'.r');axis([-3000, 3000, -3000, 3000]);
hold on;plot(FFCircle(:,1),FFCircle(:,2),'+g');
drawcircle(initOnePoint,80);hold on;plot(initOnePoint(1),initOnePoint(2),'ob');
title('\fontname{宋体}.点为像素，ob为自己选的一个点，绿色+为FFCircle')
%% 修改初值
allPointX=[px';nux'];allPointY=[py';nuy'];
disInit=initOnePoint-FFCircle(1,:);
FFCircleOffSet=FFCircle+disInit;
figure(2)
plot(allPointX(:,1),allPointY(:,1),'.');
hold on;plot(FFCircleOffSet(:,1),FFCircleOffSet(:,2),'ob');
for i=1:size(FFCircleOffSet,1)
    drawcircle(FFCircleOffSet(i,:),80);
end
title('\fontname{宋体}.点为像素，ob初次偏移之后的点')
%% 拟合圆心
circle_center=FFCircleOffSet;
PX=allPointX;PY=allPointY;dis=[];
for i=1:size(circle_center,1)
    dis(:,i)=sqrt((PX(:,1)-circle_center(i,1)).^2+(PY(:,1)-circle_center(i,2)).^2);
end
for i=1:size(dis,2)
    FF_x=[];FF_y=[];
    [x,y]=find(dis(:,i)<95 & dis(:,i)>65);
    for j=1:size(x,1)
        FF_x=[FF_x;PX(x(j,1),:)];
        FF_y=[FF_y;PY(x(j,1),:)];
    end
    
    [x0,y0,r0,n1,n2,cha] = f_NiheCircle(FF_x,FF_y,0,1);
    pxy_c(i,1)=x0;
    pxy_c(i,2)=y0;
    pxy_r(i,1)=r0;
    
end
figure(3)
plot(allPointX(:,1),allPointY(:,1),'.');
hold on;plot(pxy_c(:,1),pxy_c(:,2),'ob');
for i=1:size(FFCircleOffSet,1)
    drawcircle(pxy_c(i,:),pxy_r(i,1));
end
title('\fontname{宋体}.点为像素，ob拟合圆心')
offSetAll=pxy_c-FFCircle;
sigma=std(offSetAll);
offSet=mean(offSetAll,1)
