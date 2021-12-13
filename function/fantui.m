%% 由相机5参数反推出单元理论坐标
clear;clc;close all;

xiang_x0=230.9705804387035925628879340
xiang_y0=371.0253658389219140190107282
xiang_a0=0.1527477534781328805113532
bili_x0=100.0000000000000284217094304
bili_y0=100.0000000000000284217094304

% xiang_a0=canshu_5*180*60/pi
canshu_5=xiang_a0*pi/180/60
canshu_x=[xiang_x0;xiang_y0;bili_x0;bili_y0;canshu_5]';
canshu_y=0;
Pixcel=load('FFCircle.txt');
figure();
plot(Pixcel(:,1),Pixcel(:,2),'.b')
[LilunX,LilunY]=f_NiheTrans(5,canshu_x,canshu_y,Pixcel(:,1),Pixcel(:,2)); %实际微米坐标
LilunFF=[LilunX,LilunY];
figure();
plot(LilunFF(:,1),LilunFF(:,2),'.r')