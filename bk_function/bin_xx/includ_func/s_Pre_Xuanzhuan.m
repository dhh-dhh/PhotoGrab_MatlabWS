%��ȡcircle_canshu.txt�еķ�λ�Ǻ͸߶Ƚ�
%%����������ת����ʵ��΢������������ת���󣬵õ�С����ϵ����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if if_CalcParam == 2 || if_CalcParam == 3 ;
    [trans_x,trans_y]=f_NiheTrans(biaoding,param_x,param_y,xx,yy);
    xx= trans_x;yy=trans_y;
elseif if_CalcParam == 4;
    xx = reshape(mean(all_cx,1),[size(all_cx,2),size(all_cx,3),size(all_cx,4)]);
    yy = reshape(mean(all_cy,1),[size(all_cx,2),size(all_cx,3),size(all_cx,4)]);
else
    R=19908200;
    temp_x=zeros(fendu_times,paohe_turns,point_num);%���ڱ���ÿ�������ֵ�ľ���(�ܺϴ������ֶȴ������������
    temp_y=zeros(fendu_times,paohe_turns,point_num);%���ڱ���ÿ�������ֵ�ľ���
    temp_x0=[];temp_y0=[];temp_z0=[];
    trans_x=[];trans_y=[];trans_z=[];
    for u=1:point_num
        x=xx(:,:,u);
        y=yy(:,:,u);
              
        [trans_x(:,:),trans_y(:,:)]=f_NiheTrans(biaoding,param_x,param_y,x(:,:),y(:,:));
        trans_z(:,:)= sqrt(R^2-trans_x(:,:).^2-trans_y(:,:).^2);
        
        %%%%%%%%%%%%%%%%%%%%    ��ת��������Y,����X %%%%%%%%%%%%%%
        temp_x(:,:,u)=trans_x(:,:)*cos(circle(u,21))-trans_z(:,:)*sin(circle(u,21));
        temp_y(:,:,u)=-trans_x(:,:)*sin(circle(u,22))*sin(circle(u,21))+trans_y(:,:)*cos(circle(u,22))-trans_z(:,:)*sin(circle(u,22))*cos(circle(u,21));
    %   temp_z(:,:,u)=temp_x0(:,:)*sin(f(u))*cos(h(u))+temp_y0(:,:)*sin(h(u))+temp_z0(:,:)*cos(f(u))*cos(h(u));

    end
    xx= temp_x;yy=temp_y;
 end
