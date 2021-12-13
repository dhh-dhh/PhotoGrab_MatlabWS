% % 输入坐标而不是坐标位置行数
function [Coverage]=f_Coverage_ver1(X,edge)
draw=1;
%     lilun_xy=[edge;X];
lilun_xy=[X;edge];
%     lilun_yy=lilun_y(X,1);
Vor_end=[];
Options.plot=0; %设置1表示画出维诺图?
edge1=[7.56128 0.8759 1.552 10.128];
edge_cr=[1.808 7.3396;2.064 6.8962;2.192 6.2311;2.832 5.1225;3.344 4.6791;3.6 4.2357;4.24 3.5706;5.136 2.9055;5.904 2.4621;6.672 2.0187;7.312 1.797;8.208 1.5753;9.36 1.3536;9.5,1.1319];
edge_c=edge_cr-0.128;
%     edge1=[7.56128 1.13190 1.552 10.128];
%     edge_cr=[1.808 7.3396;2.064 6.8962;2.192 6.2311;2.832 5.1225;3.344 4.6791;3.6 4.2357;4.24 3.5706;5.136 2.9055;5.904 2.4621;6.672 2.0187;7.312 1.797;8.208 1.5753;9.36 1.3536;9.872 1.3536];
%     edge_c=edge_cr-0.128;
v=[edge_c;edge1(3) edge1(1);edge1(4) edge1(2);edge1(4) edge1(1);];
% v=v*1000000-1000000;
P = polytope(v); %生成边界?
Options.pbound=P;
Options.sortcells=1;%将对所得的Voronoi分区进行排序，以使Pn（i）对应于种子点i。
%axis square;


x=(lilun_xy(:,1)'+1000000)/100000;
y=(lilun_xy(:,2)'+1000000)/100000;
% figure();plot(x,y,'.b')
N=size(lilun_xy,1);%在单位正方形内部署100个点
M=(1000+1)*(1000+1);
r=sqrt((40.7393/N)/pi);
flag = zeros(1,M);%用来标记每个方格交叉点是否被覆盖

%Increasing COMPOW gradually to approximate the minimum  COMPOW (above)
if draw==1
    angle=0:pi/50:2*pi;
    for k=1:N
%         figure(102);
        plot(r*cos(angle)+x(k),r*sin(angle)+y(k),'-r');
        plot(x(k),y(k),'.b','MarkerSize',20);
        axis([0,10,0,10]);
        axis equal;
        hold on;
%         figure(1002);
%         plot(r*cos(angle)+x(k),r*sin(angle)+y(k));
%         plot(x(k),y(k),'.');
%         fill(r*cos(angle)+x(k),r*sin(angle)+y(k),'b');
%         axis([0,10,0,10]);
%         axis equal;
%         hold on;
    end   %画图
end

for i=1:0.01:11
    for j=0:0.01:10   %把单位正方形分成1000*1000个表格
        for m=1:N
            %鉴于乘法运算速度要慢于加法运算，这里是对算法进行优化
            %通过第一个if排除掉一些传感器，减少运算量
            if((i-r)<x(m)&&x(m)<(i+r) && (j-r)<y(m)&&y(m)<(j+r))
                if((x(m)-i)^2+(y(m)-j)^2<r*r)
                    flag(int32(i*1000*1001+j*1000)+1) = 1;
                    break;
                end
            end
        end
    end
end
Coverage=sum(flag==1)*51/41/M; %求出覆盖率



end