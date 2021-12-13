%%绘制某个单元的运转过程的各种图，用于查看该单元运转好坏

%  20170705  lzg start

close all;clear all;clc;clear maplemex;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataDir='..\';                         %文件目录
subDir1='210521_230440_cen_300';
subDir2='210522_085323_ecc_300';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cell_name='P175';
Shaft=1;         %  1 or 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (Shaft==1);axes='cen';subDir=subDir1;
elseif (Shaft==2);axes='ecc';subDir=subDir2;
end
matfile = strcat(dataDir,'\Data_',subDir,'.mat');
if exist(matfile,'file')~=2,msgbox('没找到坐标文件');return;end
load(matfile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alarm_unit= {cell_name,[4,5],[1,2:3]};
alarm_unit2 ={};
alarm_unit3 ={cell_name,[]};

%s_Pre_HandleData;
 all_x=all_x(:,:,1:5,:);
 all_y=all_y(:,:,1:5,:);

solid_xx=all_x(:,:,:,[]);
solid_yy=all_y(:,:,:,[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(unit,2)
    if strcmp(cell_name,unit(i))
        cell_code=i;
        break;
    end
end

xx=mean((all_x(:,:,:,cell_code)-mean(solid_xx,4)),1); yy=mean((all_y(:,:,:,cell_code)-mean(solid_yy,4)),1);
xx=reshape(xx,size(xx,2),size(xx,3));yy=reshape(yy,size(yy,2),size(yy,3));
%                 figure(1);f_PlotAll(xx,yy,'mytitle');
load(strcat(dataDir,'\','nihe_param.mat'));
R=19908200;
for p=1:size(xx,2);
    [trans_x(:,p),trans_y(:,p)]=f_NiheTrans(30,param_x,param_y,xx(:,p),yy(:,p));
    trans_z(:,p)= sqrt(R^2-trans_x(:,p).^2-trans_y(:,p).^2);
end
xx(:,:)=trans_x(:,:)*cos(circle(cell_code,21))-trans_z(:,:)*sin(circle(cell_code,21));
yy(:,:)=-trans_x(:,:)*sin(circle(cell_code,22))*sin(circle(cell_code,21))+trans_y(:,:)*cos(circle(cell_code,22))-trans_z(:,:)*sin(circle(cell_code,22))*cos(circle(cell_code,21));
s_Pre_mean;

figure(6);
subplot(2,1,1); plot(mean(xx,2),mean(yy,2));title('DetectBadPoint');
subplot(2,2,3); plot(mean(xx,2));
subplot(2,2,4); plot(mean(yy,2));
set(gcf,'position',[1080,100,350,300]);

figure(1);f_PlotAll(xx,yy,'mytitle');set(gcf,'position',[1080,100,350,300]);
figure(2);
for i=1:size(xx,2)
    subplot(1,size(xx,2),i)
    plot(xx(:,i),yy(:,i));
    title(strcat('第',num2str(i),'轮画圆'));
end
set(gcf,'position',[400,500,900,300]);

  average_x=mean(xx,2);average_y=mean(yy,2);
%  average_x=mean_x;average_y=mean_y;
for i=1:size(xx,2)
    error_x(:,i)=xx(:,i)-average_x;
    error_y(:,i)=yy(:,i)-average_y;
end
error_xy=sqrt((error_x).^2+(error_y).^2);
figure(3);
subplot(2,1,1); plot(error_xy(:,:));title('重复定位精度');
subplot(2,2,3); plot(error_x(:,:));
subplot(2,2,4); plot(error_y(:,:));
set(gcf,'position',[340,100,350,300]);

for q=1:size(xx,2)
    nihe_x=xx(:,q);
    nihe_y=yy(:,q);
    [nihe_x00,nihe_y00,nihe_r00] = f_NiheCircle(nihe_x,nihe_y);
    nihe_x0=nihe_x00;nihe_y0=nihe_y00;nihe_r0=nihe_r00;    %nihe_x0(p),nihe_y0(p),nihe_r0
    for f=1:fendu_times-1
        la=sqrt((nihe_x(f)-nihe_x0)^2+(nihe_y(f)-nihe_y0)^2);
        lb=sqrt((nihe_x(f+1)-nihe_x0)^2+(nihe_y(f+1)-nihe_y0)^2);
        lc=sqrt((nihe_x(f)-nihe_x(f+1))^2+(nihe_y(f)-nihe_y(f+1))^2);
        s=0.5*(la+lb+lc);
        angle22(f,q)=2*asin(sqrt((s-la)*(s-lb)/(la*lb)))*180/pi;
    end
    figure(4);
    subplot(size(xx,2),1,q)
    plot(angle22(:,q),'k-.');title(strcat('第',num2str(q),'轮定标曲线'));
    set(gcf,'position',[20,100,300,700]);
    
    figure(5);
    plot(angle22(:,q),'k-.');
    hold on;
end
mean_angle22=mean(angle22,2);
plot(mean_angle22,'b-d');
hold on;

totel_mean_angle22=0;
for j=1:size(mean_angle22,1)
    totel_mean_angle22=totel_mean_angle22+mean_angle22(j);
end

nihe_x=mean(xx,2);nihe_y=mean(yy,2);
[nihe_x00,nihe_y00,nihe_r00] = f_NiheCircle(nihe_x,nihe_y);
nihe_x0=nihe_x00;nihe_y0=nihe_y00;nihe_r0=nihe_r00;
total_angle12=0;
for f=1:fendu_times-1
    la=sqrt((nihe_x(f)-nihe_x0)^2+(nihe_y(f)-nihe_y0)^2);
    lb=sqrt((nihe_x(f+1)-nihe_x0)^2+(nihe_y(f+1)-nihe_y0)^2);
    lc=sqrt((nihe_x(f)-nihe_x(f+1))^2+(nihe_y(f)-nihe_y(f+1))^2);
    s=0.5*(la+lb+lc);
    angle12(f)=2*asin(sqrt((s-la)*(s-lb)/(la*lb)))*180/pi;
    total_angle12=total_angle12+angle12(f);
end
plot(angle12,'r-s');
set(gcf,'position',[710,100,350,300]);
hold off;
