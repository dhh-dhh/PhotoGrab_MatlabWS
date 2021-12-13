function rms=figure_cirlle(ppx,ppy,ttx,tty,i)

test_xy1(:,1)=ppx(i,:)';
test_xy1(:,2)=ppy(i,:)';
figure()
subplot(2,2,1)
color={'gx','rx','cx','mx','kx'};
test_xy=beone1(test_xy1);
for j=1:size(test_xy,1)
    k=mod(j,5)+1;
    plot(test_xy(j,1),test_xy(j,2),color{k})
    hold on;
end
[rms,allrms]=rms_mean_std1(test_xy);
[std_ppxy1,ptest]=rms_mean_std(ppx,ppy);
circle_c=mean(test_xy,1);
circle_r=rms(3,1);
drawcircle(circle_c,circle_r)
drawcircle(circle_c,circle_r*2)
% drawcircle(circle_c,circle_r*3)
% t=2;
t=0.1;
xlabel('x(pixel)');
ylabel('y(pixel)');
% figure(2)
subplot(2,2,2)
n1=find(allrms>0&allrms<t);
fig2(1,1)=size(n1,1);
n2=find(allrms>t&allrms<2*t);
fig2(1,2)=size(n2,1);
n3=find(allrms>2*t&allrms<3*t);
fig2(1,3)=size(n3,1);
n4=find(allrms>3*t&allrms<4*t);
fig2(1,4)=size(n4,1);
n5=find(allrms>4*t&allrms<5*t);
fig2(1,5)=size(n5,1);
n6=find(allrms>5*t&allrms<6*t);
fig2(1,6)=size(n6,1);
n7=find(allrms>6*t);
fig2(1,7)=size(n7,1);
y=fig2;
b=bar(y);
grid on;
ch = get(b,'children');
set(gca,'XTickLabel',{[t],[2*t],[3*t],[4*t],[5*t],[6*t],strcat('>',num2str(6*t))})
set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
% legend('基于XXX的算法','基于YYY的算法');
xlabel('点的误差（像素）');
ylabel('点的数量');

test_xy1(:,1)=ttx(i,:)';
test_xy1(:,2)=tty(i,:)';
% figure(3)
subplot(2,2,3)
color={'gx','rx','cx','mx','kx'};
test_xy=beone1(test_xy1);
for i=1:size(test_xy,1)
    k=mod(i,5)+1;
    plot(test_xy(i,1),test_xy(i,2),color{k})
    hold on;
end
[rms(:,2),allrms]=rms_mean_std1(test_xy);
[std_ttxy1,test]=rms_mean_std(ttx,tty);
circle_c=mean(test_xy,1);
circle_r=rms(3,2);
drawcircle(circle_c,circle_r)
drawcircle(circle_c,circle_r*2)
% drawcircle(circle_c,circle_r*3)
t=2;
xlabel('x(micron)');
ylabel('y(micron)');
% t=0.1
% figure(4)
subplot(2,2,4)
n1=find(allrms>0&allrms<t);
fig2(1,1)=size(n1,1);
n2=find(allrms>t&allrms<2*t);
fig2(1,2)=size(n2,1);
n3=find(allrms>2*t&allrms<3*t);
fig2(1,3)=size(n3,1);
n4=find(allrms>3*t&allrms<4*t);
fig2(1,4)=size(n4,1);
n5=find(allrms>4*t&allrms<5*t);
fig2(1,5)=size(n5,1);
n6=find(allrms>5*t&allrms<6*t);
fig2(1,6)=size(n6,1);
n7=find(allrms>6*t);
fig2(1,7)=size(n7,1);
y=fig2;
b=bar(y);
grid on;
ch = get(b,'children');
set(gca,'XTickLabel',{[t],[2*t],[3*t],[4*t],[5*t],[6*t],strcat('>',num2str(6*t))})
set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
% legend('基于XXX的算法','基于YYY的算法');
xlabel('点的误差(微米)');
ylabel('点的数量');