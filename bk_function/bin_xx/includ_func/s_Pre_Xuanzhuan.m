%读取circle_canshu.txt中的方位角和高度角
%%将象面坐标转换成实际微米坐标后乘以旋转矩阵，得到小坐标系中坐标数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if if_CalcParam == 2 || if_CalcParam == 3 ;
    [trans_x,trans_y]=f_NiheTrans(biaoding,param_x,param_y,xx,yy);
    xx= trans_x;yy=trans_y;
elseif if_CalcParam == 4;
    xx = reshape(mean(all_cx,1),[size(all_cx,2),size(all_cx,3),size(all_cx,4)]);
    yy = reshape(mean(all_cy,1),[size(all_cx,2),size(all_cx,3),size(all_cx,4)]);
else
    R=19908200;
    temp_x=zeros(fendu_times,paohe_turns,point_num);%用于保存每点的行列值的矩阵，(跑合次数，分度次数，光点数）
    temp_y=zeros(fendu_times,paohe_turns,point_num);%用于保存每点的行列值的矩阵
    temp_x0=[];temp_y0=[];temp_z0=[];
    trans_x=[];trans_y=[];trans_z=[];
    for u=1:point_num
        x=xx(:,:,u);
        y=yy(:,:,u);
              
        [trans_x(:,:),trans_y(:,:)]=f_NiheTrans(biaoding,param_x,param_y,x(:,:),y(:,:));
        trans_z(:,:)= sqrt(R^2-trans_x(:,:).^2-trans_y(:,:).^2);
        
        %%%%%%%%%%%%%%%%%%%%    旋转矩阵先绕Y,再绕X %%%%%%%%%%%%%%
        temp_x(:,:,u)=trans_x(:,:)*cos(circle(u,21))-trans_z(:,:)*sin(circle(u,21));
        temp_y(:,:,u)=-trans_x(:,:)*sin(circle(u,22))*sin(circle(u,21))+trans_y(:,:)*cos(circle(u,22))-trans_z(:,:)*sin(circle(u,22))*cos(circle(u,21));
    %   temp_z(:,:,u)=temp_x0(:,:)*sin(f(u))*cos(h(u))+temp_y0(:,:)*sin(h(u))+temp_z0(:,:)*cos(f(u))*cos(h(u));

    end
    xx= temp_x;yy=temp_y;
 end
