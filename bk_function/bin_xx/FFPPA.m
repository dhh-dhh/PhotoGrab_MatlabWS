%% 计算每一步Q的参数 ，通过 原始像素文件拟合微米坐标 拟合圆心与半径
clear;close all;
addpath(pwd);
dataDir='..';
subDir1='211208_143928_cen_6300';
subDir2='211208_143340_ecc_5000';
biaoding=20;
%% 读取FF理论坐标
FFLilun=load('data/FFLilun_LL.txt');
%% 读取单元数量与名称
subDir=subDir1;
filename_unit=strcat(dataDir,'\',subDir,'\',subDir,'_00_000_00.txt');
fid=fopen(filename_unit,'rt');
Qnum=0;Pnum=0;unit=[];
while ~feof(fid)
    D_Y=fscanf(fid,'%s',1);
    if  ~isempty(D_Y) && strcmp(D_Y(1),'Q')
        unit=[unit;D_Y];
        Qnum=Qnum+1;
    elseif ~isempty(D_Y) && strcmp(D_Y(1),'P')
        unit=[unit;D_Y];
        Pnum=Pnum+1;
    end
end
fclose(fid);

%% 读取中心轴文件中Q 与P单元像素坐标
subDir=subDir1;
for n=1:11
    filename=sprintf('%s\\%s\\%s_00_%03d_00.txt',dataDir,subDir,subDir,n-1);
    fid=fopen(filename,'r');
    for k=1:Pnum
        fscanf(fid,'%s',1);               %跳过单元名称
        P_pxy(k,1,n) = fscanf(fid,'%f',1);   %像素x
        P_pxy(k,2,n) = fscanf(fid,'%f',1);   %像素y
        fgetl(fid);
    end
    for k=1:Qnum
        fscanf(fid,'%s',1);               %跳过单元名称
        Q_pxy(k,1,n) = fscanf(fid,'%f',1);   %像素x
        Q_pxy(k,2,n) = fscanf(fid,'%f',1);   %像素y
        fgetl(fid);
    end
    fclose(fid);
end
%% 查看Q值位置
figure()
for i=1:size(Q_pxy,3)
    plot(Q_pxy(:,1,i),Q_pxy(:,2,i),'+');
    hold on;
    plot(P_pxy(:,1,i),P_pxy(:,2,i),'+');
end
%% 计算每一步param xy 对P进行拟合圆心
param_x=[];param_y=[];
for n=1:11
    [param_x(:,n),param_y(:,n)]=f_NiheParam(biaoding, Q_pxy(:,1,n),Q_pxy(:,2,n),FFLilun(:,1),FFLilun(:,2));
	[cen_x(:,n),cen_y(:,n)]=f_NiheTrans(biaoding,param_x(:,n),param_y(:,n),P_pxy(:,1,n),P_pxy(:,2,n));
end
cen_center_xyr=[];
for i=1:Pnum
    [cen_center_xyr(i,1),cen_center_xyr(i,2),cen_center_xyr(i,3)] = f_NiheCircle(cen_x(i,:)',cen_y(i,:)',0,'1');
end

%% 读取偏心轴文件中Q 与P单元像素坐标
step=11;P_pxy=[];
subDir=subDir2;
for n=1:step
    filename=sprintf('%s\\%s\\%s_00_%03d_00.txt',dataDir,subDir,subDir,n-1);
    fid=fopen(filename,'r');
    for k=1:Pnum
        fscanf(fid,'%s',1);               %跳过单元名称
        P_pxy(k,1,n) = fscanf(fid,'%f',1);   %像素x
        P_pxy(k,2,n) = fscanf(fid,'%f',1);   %像素y
        fgetl(fid);
    end
    for k=1:Qnum
        fscanf(fid,'%s',1);               %跳过单元名称
        Q_pxy(k,1,n) = fscanf(fid,'%f',1);   %像素x
        Q_pxy(k,2,n) = fscanf(fid,'%f',1);   %像素y
        fgetl(fid);
    end
    fclose(fid);
end
figure()
for i=1:step
    plot(Q_pxy(:,1,i),Q_pxy(:,2,i),'.');
    hold on;
    plot(P_pxy(:,1,i),P_pxy(:,2,i),'+');
end
%% 计算每一步param xy 对P计算中心偏心长度，初始角度
param_x=[];param_y=[];
for n=1:step
    [param_x(:,n),param_y(:,n)]=f_NiheParam(biaoding, Q_pxy(:,1,n),Q_pxy(:,2,n),FFLilun(:,1),FFLilun(:,2));
	[ecc_x(:,n),ecc_y(:,n)]=f_NiheTrans(biaoding,param_x(:,n),param_y(:,n),P_pxy(:,1,n),P_pxy(:,2,n));
end
ecc_center_xyr=[];
for i=1:Pnum
    [ecc_center_xyr(i,1),ecc_center_xyr(i,2),ecc_center_xyr(i,3)] = f_NiheCircle(ecc_x(i,:)',ecc_y(i,:)',0,'1');
end

%% 计算中心偏心轴臂长
cen_l=sqrt((cen_center_xyr(:,1)-ecc_center_xyr(:,1)).^2+(cen_center_xyr(:,2)-ecc_center_xyr(:,2)).^2);
ecc_l=ecc_center_xyr(:,3);

%% 计算中心偏心初始角
% 中心
% cen_angle0=atan((ecc_center_xyr(:,2)-cen_center_xyr(:,2))./(ecc_center_xyr(:,1)-cen_center_xyr(:,1)));
cen_angle=asin((ecc_center_xyr(:,2)-cen_center_xyr(:,2))./cen_l);
% 偏心
% mean_x_ecc=mean(ecc_x,2);
% mean_y_ecc=mean(ecc_y,2);
% mean_x_ecc=ecc_x(:,1);
% mean_y_ecc=ecc_y(:,1);
% point_x1(:,:)=mean_x_ecc;point_y1(:,:)=mean_y_ecc;
% dist=sqrt((point_x1-cen_center_xyr(:,1)).^2+(point_y1-cen_center_xyr(:,2)).^2);
% s=(dist+ecc_l+cen_l)./2;
% ecc_angle=2.*asin(sqrt((s-cen_l).*(s-ecc_l)./(cen_l.*ecc_l)));

% ecc_angle=atan((ecc_x(:,1)-ecc_center_xyr(:,1))./(ecc_y(:,1)-ecc_center_xyr(:,2)));
ecc_angle_gama=atan((ecc_y(:,1)-ecc_center_xyr(:,2))./(ecc_x(:,1)-ecc_center_xyr(:,1)));
for i=1:size(ecc_angle_gama,1)
   if cen_angle(i,1)>=0 && ecc_angle_gama(i,1)>=0
       ecc_angle(i,1)=ecc_angle_gama(i,1)+cen_angle(i,1);
   elseif cen_angle(i,1)>=0 && ecc_angle_gama(i,1)<0
       ecc_angle(i,1)=-ecc_angle_gama(i,1)+cen_angle(i,1);
   else
       ecc_angle(i,1)=ecc_angle_gama(i,1)-cen_angle(i,1);
   end
end
ecc_angle=-abs(ecc_angle);
%% 写canshu文件
canshu_data=[cen_center_xyr(:,1),cen_center_xyr(:,2),cen_l,ecc_l,cen_angle,ecc_angle];
unitP=unit(1:Pnum,:);
badUnit=[];
for i=Pnum:-1:1
    if canshu_data(i,3)<6250 || canshu_data(i,4)<6250 || canshu_data(i,3)>8500 || canshu_data(i,4)>8500
        badUnit=[badUnit;unitP(i,:)];
        canshu_data(i,:)=[];unitP(i,:)=[];
%         canshu_data(i,3:6)=[8000,8000,0,0];
    end
end
canshu_data(:,5)=canshu_data(:,5)+0.0524;

newfile= strcat(dataDir,'\','canshu.txt');
fid=fopen(newfile,'w');
fprintf(fid,'unit           :    旋转圆心X       旋转圆心Y      中心轴长        偏心轴长  中心轴初始角 偏心轴初始角 \n');
for p=1:size(canshu_data,1)
    fprintf(fid,'%s \t:%28.6f %28.6f %15.6f %15.6f %15.6f %15.6f\n',unitP(p,:),canshu_data(p,:));
end
fclose(fid);
newfile= strcat(dataDir,'\','badUnit.txt');
fid=fopen(newfile,'w');
fprintf(fid,'unit \n');
for p=1:size(badUnit,1)
    fprintf(fid,'%s \n',badUnit(p,:));
end
fclose(fid);