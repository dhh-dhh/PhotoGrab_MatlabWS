%%%%%%%%%%%ƫ����/���������������ʼ�Ǽ���%%%%%%%%%%%%%%

% clear all;clc;clear maplemex;
R=19908200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

matfile = strcat(dataDir,'\','circle_',subDir1,'.mat');
matfile2 = strcat(dataDir,'\','circle_',subDir2,'.mat');
if exist(matfile,'file')~=2,msgbox('û�ҵ������������ļ�');return;end
if exist(matfile2,'file')~=2,msgbox('û�ҵ�ƫ���������ļ�');return;end
load(matfile);
load(matfile2);


point_x1=mean_x_ecc;point_y1=mean_y_ecc;
r0_ecc=sqrt((point_x1-x0_ecc').^2+(point_y1-y0_ecc').^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����������Բ�����ꡢ�뾶
%%%%%%%%%%%%%%�����������۳�
r0_cen=sqrt((x0_ecc-x0_cen).^2+(y0_ecc-y0_cen).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%��ȡcircle
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ʼ�Ƕ�
cen_angle0=zeros(1,point_num);
ecc_angle0=zeros(1,point_num);
newfile= strcat(dataDir,'\','canshu_0.txt');
fid=fopen(newfile,'w');
fprintf(fid,'unit           :    R*��λ��        R*�߶Ƚ�        Բ�����X        Բ�����Y        Բ�����Z           �߶Ƚ�                            ��λ��                        ��תԲ��X       ��תԲ��Y      �����᳤        ƫ���᳤  �������ʼ�� ƫ�����ʼ�� \n');
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
circle00(:,3)=cen_x;% ʵ��Բ��x����(����Բ��ӳ��õ�)
circle00(:,4)=cen_y;% ʵ��Բ��y����(����Բ��ӳ��õ�)
circle00(:,5)=cen_z;% ʵ��Բ��z����
circle00(:,6)=h;%�߶Ƚ�        ''''
circle00(:,7)=f;%��λ��        '''''
circle00(:,8)=x0_cen;% ʵ��������Բ��x����(ʵ�ʷֶȵ��������)
circle00(:,9)=y0_cen;% ʵ��������Բ��y����(ʵ�ʷֶȵ��������)
circle00(:,10)=r0_cen;%ʵ��������뾶
circle00(:,11)=r0_ecc_nihe;%ʵ��ƫ����뾶
circle00(:,12)=cen_angle0;%�������ʼ��
circle00(:,13)=ecc_angle0;%ƫ�����ʼ��
circle00=circle00';
for p=1:point_num
    fprintf(fid,'%s   :      %15.6f %15.6f %15.6f %15.6f %15.6f \t%28.25f \t%28.25f %15.6f %15.6f %15.6f %15.6f %10.6f %10.6f \n',unit{p},circle00(:,p));
end
fclose(fid);
%%%%%%%%%%%д�滻���canshu.txt
newfile=strcat(dataDir,'\','canshu.txt');
fid=fopen(newfile,'w');
fprintf(fid,'unit           :    R*��λ��        R*�߶Ƚ�        Բ�����X        Բ�����Y        Բ�����Z           �߶Ƚ�                            ��λ��                        ��תԲ��X       ��תԲ��Y      �����᳤        ƫ���᳤  �������ʼ�� ƫ�����ʼ�� �滻���� \n');
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
fprintf(fid,'unit %d%d%d_%d%d%d \n',date);%�� �� �� ʱ �� ��
for p=1:j;
    fprintf(fid,'%s  \n',bad_num{p});
end
fclose(fid);
%%%%%%%%%%%%%����ת��x��yΪԲ�ģ���������ᣬƫ���᳤�����Ϊ�뾶��Բ
r00=circle00(:,11)+circle00(:,10);
for p=1:point_num
    sita=0:pi/20:2*pi;
    plot(r00(p)*cos(sita)+circle00(p,3),r00(p)*sin(sita)+circle00(p,4));
    hold on;
end
hold off;

msgbox('��Ԫ�����������');



% lamdir1='U:\Lamost_Data\canshu';
% lamdir2='U:\Lamost_Data\canshu\dataend';
% filelist=dir(lamdir1);
% filename00=filelist.name;
% lamdir3='U:\Lamost_Data\canshu\filelist.name';
% matfile00=strcat(lamdir1,'\',filename00);
% matfile11=strcat(lamdir2,'\',filename00);
% movefile(matfile00,matfile11)

