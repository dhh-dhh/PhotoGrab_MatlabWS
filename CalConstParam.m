%% ͨ���������˼���̶�����
clear;close all;
% ���룺��������
% ͨ�����ر���ͬ��Բ���ж�ͬ��Բ�й������>fiberNumThreshold����Ϊ�ο�����
% ��ͨ�������㷨����� FFNum ���ο�����
% ��ȡͬ���ֵ���������
% ���Բ��
% �����FF��ʼ����λ��
addpath('function');
F_N='data/220114_122559_00_000_00_xy.txt';%�����txt�ļ����Ƹ��ƽ�ȥ
F_plane='data/m_plane_lilun.txt';
sortRows=21; % �������������й��˵�����
FFNum=40; % �ο���������
findStep=5;%ͬ��Բ�������� ����
fiberNumThreshold=5; % ͬ��Բ��������������ֵ
rMax=85;rMin=75; % ͬ��Բ�뾶��Χ

%% ��ȡ��Ԫ��λ��������
D_Y=[];
fid=fopen(F_N,'r');
UnitName=[];nux=[];nuy=[];
m=0;
while ~feof(fid)
    m=m+1;
    D_Y=fscanf(fid,'%s',1);
    G_D_x(m)=fscanf(fid,'%f',1);
    G_D_y(m)=fscanf(fid,'%f',1);
    if strcmp(D_Y(1),'P')
        px(m)=fscanf(fid,'%f',1);
        py(m)=fscanf(fid,'%f',1);
        UnitName=[UnitName;D_Y];
    else
        nux=[nux,fscanf(fid,'%f',1)];
        nuy=[nuy,fscanf(fid,'%f',1)];
    end
    fgetl(fid);
end
fclose(fid);
PXY=[px',py'];

%% ��ȡ���������
fid=fopen(F_plane,'r');
LilunX=[];LilunY=[];
m=0;
while ~feof(fid)
    LilunX=[LilunX;fscanf(fid,'%f',1)];
    LilunY=[LilunY;fscanf(fid,'%f',1)];
    fgetl(fid);
end
fclose(fid);
Lilun=[LilunX,LilunY]*1000;


%% ƥ��6����
Point=[-1173,1650,-1.28,1.774
    1403,1629,1.28,1.774
    -1200,-1910,-1.28,-1.774
    1376,-1938,1.28,-1.774];
figure(1)
plot(PXY(:,1),PXY(:,2),'.');hold on; plot(Point(:,1),Point(:,2),'+r')
figure(2)
plot(Lilun(:,1),Lilun(:,2),'.');hold on; plot(Point(:,3)*100000,Point(:,4)*100000,'+r')
biaoding=6;
[canshu_x,canshu_y,~]=f_NiheParam(biaoding,Point(:,1),Point(:,2),Point(:,3)*100000,Point(:,4)*100000,'');
XY5(:,1)=PXY(:,1);
XY5(:,2)=PXY(:,2);
XY5(:,3)=ones(size(XY5,1),1)*35;
XY5(:,4)=ones(size(XY5,1),1)*3500;
for i=1:size(LilunX,1)
    unit_nonuse(i,:)=['NB',num2str(i+10000)];
end
[XY8,GoodUnit,GoodXY8,num,dx,dy]  =  f_Match(unit_nonuse,Lilun(:,1),Lilun(:,2),XY5,6,canshu_x,canshu_y,5000);
biaoding=20;
[canshu_x20,canshu_y20,~]=f_NiheParam(biaoding,GoodXY8(:,1),GoodXY8(:,2),GoodXY8(:,7),GoodXY8(:,8),'');
canshu20=[canshu_x20,canshu_y20];


newfile= strcat('F:\Paohe\bin','\','config_constparamer.ini');
fid=fopen(newfile,'w');
% fprintf(fid,'unit           :    ��תԲ��X       ��תԲ��Y      �����᳤        ƫ���᳤  �������ʼ�� ƫ�����ʼ�� \n');
for p=1:size(canshu20,1)
    if p~=size(canshu20,1)
        fprintf(fid,'%28.15f%28.15f\n',canshu20(p,1),canshu20(p,2));
    else
        fprintf(fid,'%28.15f%28.15f',canshu20(p,1),canshu20(p,2));
    end
end
fclose(fid);

