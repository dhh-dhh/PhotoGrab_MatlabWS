%%%%%%%%%%%偏心轴/中心轴与坐标轴初始角计算%%%%%%%%%%%%%%

% clear all;clc;clear maplemex;
R=19908200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

matfile = strcat(dataDir,'\','circle_',subDir1,'.mat');
matfile2 = strcat(dataDir,'\','circle_',subDir2,'.mat');
if exist(matfile,'file')~=2,msgbox('没找到中心轴坐标文件');return;end
if exist(matfile2,'file')~=2,msgbox('没找到偏心轴坐标文件');return;end
load(matfile);
load(matfile2);


point_x1=mean_x_ecc;point_y1=mean_y_ecc;
r0_ecc=sqrt((point_x1-x0_ecc').^2+(point_y1-y0_ecc').^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%读入中心轴圆心坐标、半径
%%%%%%%%%%%%%%计算出中心轴臂长
r0_cen=sqrt((x0_ecc-x0_cen).^2+(y0_ecc-y0_cen).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%读取circle
rf=R*circle(:,21);
rh=R*circle(:,22);
if if_CalcParam==1;
    cen_x=circle(:,18);
    cen_y=circle(:,19);
else
    cen_x=x0_cen;
    cen_y=y0_cen;
end
cen_z=circle(:,20);
f=circle(:,21);
h=circle(:,22);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%计算初始角度
cen_angle0=zeros(1,point_num);
ecc_angle0=zeros(1,point_num);
newfile= strcat(dataDir,'\','canshu_0.txt');
fid=fopen(newfile,'w');
fprintf(fid,'unit           :    R*方位角        R*高度角        圆心拟合X        圆心拟合Y        圆心拟合Z           高度角                            方位角                        旋转圆心X       旋转圆心Y      中心轴长        偏心轴长  中心轴初始角 偏心轴初始角 \n');
y2=zeros(1,point_num);
cen_angle0=asin((y0_ecc-y0_cen)./r0_cen);
dist=sqrt((point_x1'-x0_cen).^2+(point_y1'-y0_cen).^2);
s=(dist+r0_ecc'+r0_cen)./2;
ecc_angle0=2.*asin(sqrt((s-r0_cen).*(s-r0_ecc')./(r0_cen.*r0_ecc')));
y2=((point_x1'-x0_cen)./(x0_ecc-x0_cen)).*(y0_ecc-y0_cen)+y0_cen;
for p=1:point_num
    if y2(1,p)>=point_y1(p,1)
        ecc_angle0(1,p)=-ecc_angle0(1,p);
    else
        ecc_angle0(1,p)=ecc_angle0(1,p);
    end
end
circle00(:,1)=rf;% r*f
circle00(:,2)=rh;% r*h
circle00(:,3)=cen_x;% 实际圆心x坐标(相面圆心映射得到)
circle00(:,4)=cen_y;% 实际圆心y坐标(相面圆心映射得到)
circle00(:,5)=cen_z;% 实际圆心z坐标
circle00(:,6)=h;%高度角        ''''
circle00(:,7)=f;%方位角        '''''
circle00(:,8)=x0_cen;% 实际中心轴圆心x坐标(实际分度点拟合所得)
circle00(:,9)=y0_cen;% 实际中心轴圆心y坐标(实际分度点拟合所得)
circle00(:,10)=r0_cen;%实际中心轴半径
circle00(:,11)=r0_ecc_nihe;%实际偏心轴半径
circle00(:,12)=cen_angle0;%中心轴初始角
circle00(:,13)=ecc_angle0;%偏心轴初始角
circle00=circle00';
for p=1:point_num
    fprintf(fid,'%s   :      %15.6f %15.6f %15.6f %15.6f %15.6f \t%28.25f \t%28.25f %15.6f %15.6f %15.6f %15.6f %10.6f %10.6f \n',unit{p},circle00(:,p));
end
fclose(fid);
%%%%%%%%%%%写替换后的canshu.txt
newfile=strcat(dataDir,'\','canshu.txt');
fid=fopen(newfile,'w');
fprintf(fid,'unit           :    R*方位角        R*高度角        圆心拟合X        圆心拟合Y        圆心拟合Z           高度角                            方位角                        旋转圆心X       旋转圆心Y      中心轴长        偏心轴长  中心轴初始角 偏心轴初始角 替换参数 \n');
circle00=circle00';
j=0;
for p=1:point_num
    if r0_cen(p)<6500 || r0_cen(p)>9600 || r0_ecc_nihe(p) < 6500 || r0_ecc_nihe(p) > 9600
        j=j+1;
        circle00(p,:)=circle(p,[1:13]);
        bad{p}='0';
        bad_num{j}=unit{p};
    else
        bad{p}='999';
    end
end
circle00=circle00';
for p=1:point_num
    fprintf(fid,'%s   :      %15.6f %15.6f %15.6f %15.6f %15.6f \t%28.25f \t%28.25f %15.6f %15.6f %15.6f %15.6f %10.6f %10.6f    %s \n',unit{p},circle00(:,p),bad{p});
end
fclose(fid);
circle00=circle00';
date=fix(clock);
newfile=strcat(dataDir,'\BadUnit_ChuShi.txt');
fid=fopen(newfile,'w');
fprintf(fid,'unit %d%d%d_%d%d%d \n',date);%年 月 日 时 分 秒
for p=1:j;
    fprintf(fid,'%s  \n',bad_num{p});
end
fclose(fid);
%%%%%%%%%%%%%以旋转后x，y为圆心，拟合中心轴，偏心轴长度相加为半径画圆
r00=circle00(:,11)+circle00(:,10);
for p=1:point_num
    sita=0:pi/20:2*pi;
    plot(r00(p)*cos(sita)+circle00(p,3),r00(p)*sin(sita)+circle00(p,4));
    hold on;
end
hold off;

msgbox('单元参数计算完成');



% lamdir1='U:\Lamost_Data\canshu';
% lamdir2='U:\Lamost_Data\canshu\dataend';
% filelist=dir(lamdir1);
% filename00=filelist.name;
% lamdir3='U:\Lamost_Data\canshu\filelist.name';
% matfile00=strcat(lamdir1,'\',filename00);
% matfile11=strcat(lamdir2,'\',filename00);
% movefile(matfile00,matfile11)

