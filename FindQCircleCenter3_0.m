%% ͨ������Ѱ�Ҳο�����
clear;close all;
% ���룺��������
% ͨ�����ر���ͬ��Բ���ж�ͬ��Բ�й������>fiberNumThreshold����Ϊ�ο�����
% ��ͨ�������㷨����� FFNum ���ο�����
% ��ȡͬ���ֵ���������
% ���Բ��
% �����FF��ʼ����λ��
addpath('function');
F_N='data/211213_155119_00_000_00_xy.txt';%�����txt�ļ����Ƹ��ƽ�ȥ
sortRows=21; % �������������й��˵�����
FFNum=36; % �ο���������
findStep=5;%ͬ��Բ�������� ����
fiberNumThreshold=5; % ͬ��Բ��������������ֵ
rMax=85;rMin=75; % ͬ��Բ�뾶��Χ

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
plot(G_D_x,G_D_y,'.b');title('\fontname{����} ��ʼ���΢��')
%             for i=size(G_D_x,2):-1:1
%                if  (G_D_x(1,i)>3000 || G_D_x(1,i)<-3000 || G_D_y(1,i)>3000 || G_D_y(1,i)<-3000|| isnan(G_D_y(1,i)) || isnan(G_D_x(1,i)))
%                    G_D_x(:,i)=[];
%                    G_D_y(:,i)=[];
%                end
%             end
allPointX=[px';nux'];allPointY=[py';nuy'];
FFLiLun=load('FFLilun_LL.txt');
figure(2)
plot(allPointX,allPointY,'.b');title('\fontname{����} .��Ϊ����')
% axis([-3000, 3000, -3000, 3000]);
% figure(3)
% plot(FFLiLun(:,1),FFLiLun(:,2),'+r');title('\fontname{����} +Ϊ����')

[annulusList]=f_findAnnulus(allPointX,allPointY,rMin,rMax,findStep,fiberNumThreshold);
idx = kmeans(annulusList,FFNum);
figure(3)
gscatter(annulusList(:,1),annulusList(:,2),idx);
title('\fontname{����}K��ֵ����')
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

%% ����Բ�� 
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
plot(allPointX,allPointY,'.b');title('\fontname{����} .��Ϊ���� oΪ���Բ��')
hold on;plot(pxy_c(:,1),pxy_c(:,2),'og');

chaRawC=FFCircleSort-pxy_c;
std(chaRawC,1)
