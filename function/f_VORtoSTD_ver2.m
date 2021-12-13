% % 输入坐标而不是坐标位置行数
function [Vor_end]=f_VORtoSTD_ver2(X,edge)
%     lilun_xy=[edge;X];
    lilun_xy=[X;edge];
%     lilun_yy=lilun_y(X,1);
    Vor_end=[];
    Options.plot=1; %设置1表示画出维诺图?
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
    X1=(lilun_xy(:,1)'+1000000)/100000;
    Y1=(lilun_xy(:,2)'+1000000)/100000;
%     figure();plot(X1,Y1,'.r')
    Pn=mpt_voronoi([X1' Y1'],Options);
    for vor_i=1:size(X1,2)
        V = extreme(Pn(vor_i)); %这里的V就是第一个多边形的顶点序列?
        S(vor_i) = mypolyarea(V);
%         [circle_coord,r]=f_duobianxing_circle(V);
%         all_r(vor_i)=r;
    end
%     Vor_end(1,1)=mean(S);
    Vor_end=std(S);
end