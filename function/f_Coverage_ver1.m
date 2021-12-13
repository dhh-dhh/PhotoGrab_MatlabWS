% % �����������������λ������
function [Coverage]=f_Coverage_ver1(X,edge)
draw=1;
%     lilun_xy=[edge;X];
lilun_xy=[X;edge];
%     lilun_yy=lilun_y(X,1);
Vor_end=[];
Options.plot=0; %����1��ʾ����άŵͼ?
edge1=[7.56128 0.8759 1.552 10.128];
edge_cr=[1.808 7.3396;2.064 6.8962;2.192 6.2311;2.832 5.1225;3.344 4.6791;3.6 4.2357;4.24 3.5706;5.136 2.9055;5.904 2.4621;6.672 2.0187;7.312 1.797;8.208 1.5753;9.36 1.3536;9.5,1.1319];
edge_c=edge_cr-0.128;
%     edge1=[7.56128 1.13190 1.552 10.128];
%     edge_cr=[1.808 7.3396;2.064 6.8962;2.192 6.2311;2.832 5.1225;3.344 4.6791;3.6 4.2357;4.24 3.5706;5.136 2.9055;5.904 2.4621;6.672 2.0187;7.312 1.797;8.208 1.5753;9.36 1.3536;9.872 1.3536];
%     edge_c=edge_cr-0.128;
v=[edge_c;edge1(3) edge1(1);edge1(4) edge1(2);edge1(4) edge1(1);];
% v=v*1000000-1000000;
P = polytope(v); %���ɱ߽�?
Options.pbound=P;
Options.sortcells=1;%�������õ�Voronoi��������������ʹPn��i����Ӧ�����ӵ�i��
%axis square;


x=(lilun_xy(:,1)'+1000000)/100000;
y=(lilun_xy(:,2)'+1000000)/100000;
% figure();plot(x,y,'.b')
N=size(lilun_xy,1);%�ڵ�λ�������ڲ���100����
M=(1000+1)*(1000+1);
r=sqrt((40.7393/N)/pi);
flag = zeros(1,M);%�������ÿ�����񽻲���Ƿ񱻸���

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
    end   %��ͼ
end

for i=1:0.01:11
    for j=0:0.01:10   %�ѵ�λ�����ηֳ�1000*1000�����
        for m=1:N
            %���ڳ˷������ٶ�Ҫ���ڼӷ����㣬�����Ƕ��㷨�����Ż�
            %ͨ����һ��if�ų���һЩ������������������
            if((i-r)<x(m)&&x(m)<(i+r) && (j-r)<y(m)&&y(m)<(j+r))
                if((x(m)-i)^2+(y(m)-j)^2<r*r)
                    flag(int32(i*1000*1001+j*1000)+1) = 1;
                    break;
                end
            end
        end
    end
end
Coverage=sum(flag==1)*51/41/M; %���������



end