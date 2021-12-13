clear;
lilun_Laser=load('FFLilun_Laser.txt');
[xx,yy]=f_sort_rect(21,lilun_Laser*1000);
lilun_um=[xx,yy];
figure(1)
for i=1:size(lilun_um,1)
    plot(lilun_um(i,1),lilun_um(i,2),'.');hold on;
end