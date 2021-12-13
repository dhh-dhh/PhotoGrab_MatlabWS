%% 反推 查看匹配形况
xiang_x0=229.2499999639708221366163343
xiang_y0=378.0000000385176690542721190
xiang_a0=-24.8964195810469064440439979
bili_x0=100.0000000000000284217094304
bili_y0=100.0000000000000284217094304
% xiang_a0=canshu_5*180*60/pi
canshu_5=xiang_a0*pi/180/60
canshu_x=[xiang_x0;xiang_y0;bili_x0;bili_y0;canshu_5]';
canshu_y=0;
Pixcel=load('FFCircle.txt');

[PX,PY]=f_NiheTrans(5,canshu_x,canshu_y,G_D_x',G_D_y'); %实际微米坐标


figure();
plot(PX,PY,'.b')
hold on;
plot(Z_D_x,Z_D_y,'.r')