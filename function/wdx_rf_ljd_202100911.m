% % 通过霍夫算法计算参考光纤稳定性

% % 参考光纤单元稳定性
addpath('function','data');addpath(genpath(pwd));
% load('wdx_rf_2h.mat');
% fpath='G:\20210629晚上加7参考光纤稳定性\';

close all;
Z_D_x1=[];Z_D_y1=[];D_Y=[];;LED4=[];

while 1
    
    %修改文件目录
    bb=char('请选择要进行的操作：','0--提取raw文件像素坐标   11----画两幅图  12----画标定靶的图　 2----选取4个点  3---每一张单独匹配像素坐标和理论坐标 4---每一次减去五次平均的值  5---赋值  61---每一次减去五次平均的值=4  62---每一次减去整体平均的标准差   63---五次平均的标准差  64---十次平均的标准差');
    choice=inputdlg(bb);
    switch lower(choice{1})
        
        case '1'
           load('20210908.mat');
            Point=[5065,2436,5065,2436
                6730,2437,6730,2437
                5840,1660, 5840,1660
                6748,1649,6748,1649
                ];%%
            Z_D_x=Z_D_x1;Z_D_y=Z_D_y1;
            
            positions_now=[];
            positions_now=positions_1_end(:,:,301:1800);% 使用从21到end
            
            figure(1)% 画第一张的像素
            plot(positions_now(:,1,1),positions_now(:,2,1),'.')
            hold on;
            plot(Point(:,1),Point(:,2),'+r')
            Z_D_x=positions_now(:,1,1);Z_D_y=positions_now(:,2,1); %%读第一张xy 作为理论坐标
            for i=size(Z_D_x):-1:1
                if(Z_D_x(i,1)<4500)
                    Z_D_x(i,:)=[];
                    Z_D_y(i,:)=[];
                end
            end
            unit='P1001';
            for i=1:size(Z_D_x,1)
                unit(i,:)=strcat('P',int2str(1000+i));
            end
            
            figure(2)% 画理论像素
            plot(Z_D_x,Z_D_y,'.')
            hold on;
            plot(Point(:,3),Point(:,4),'+r')
            lilun_x=Z_D_x;
            lilun_y=Z_D_y;
            x=Point(:,1);
            y=Point(:,2);
            lilun_x1=Point(:,3);
            lilun_y1=Point(:,4);
            
            biaoding=6;
            
            [canshu_x,canshu_y,dblCoorX,dblCoorY,cha_x,cha_y,cha]=f_NiheParam(biaoding,x,y,lilun_x1,lilun_y1,'');
            param_x1=canshu_x;
            param_y1=canshu_y;
            
            param_y1=canshu_y;
            %         case '3'
            %             close all;
            image_count=size(positions_now,3);
            XY5=[];GGXY8=zeros(500,8);GGXY8_unit=[];
            %                 xx=zeros(size(unit,1),1,image_count);
            %                 yy=zeros(size(unit,1),1,image_count);
            tx=[];ty=[]; x=[];y=[];lilun_x1=[];lilun_y1=[];px=[];py=[];pw=[];pz=[];param_xy=[];cond_a=[];
            xx=[];yy=[];
            for i=1:image_count
                XY5(:,1)=positions_now(:,1,i);
                XY5(:,2)=positions_now(:,2,i);
                XY5(:,3)=positions_now(:,3,i);
                XY5(:,4)=positions_now(:,4,i);
                biaoding=6;
                [XY8,GoodUnit,GoodXY8,num,dx,dy]  =  f_Match(unit,Z_D_x,Z_D_y,XY5,biaoding,param_x1,param_y1,5000);
                px(:,i)=XY8(1:size(unit,1),1); %% 匹配好的x
                py(:,i)=XY8(1:size(unit,1),2); %% 匹配好的y
            end
            
            [pxy_all_unit,pxy_rms_unit]=rms_mean_std(px(:,:),py(:,:)); %% 原图出的稳定性
            txy_all_bd(:,1)=pxy_rms_unit;
            
            
         case 'c'
%             BW = edge(imgn,'canny');
%             if ii==1
%                 %     subplot(1,5,4);
%                 figure(14)
%                 imshow(BW),title('edge');
%             end
            % 步长为1，即每次检测的时候增加的半径长度
            step_r = 0.1;
            %检测的时候每次转过的角度
            step_angle = 0.1;
            % 对检测的圆的大小范围预估，在实际项目中因为产品大小固定，所以可以给定较小范围，提高运行速度
            minr =78;
            maxr = 81;
            % 自动取最优的灰度阈值
            %thresh = graythresh(I);
             thresh =0.58;
            % 调用hough_circle函数进行霍夫变换检测圆
            [hough_space,hough_circle1,para] = hough_circle_dot(px,py,step_r,step_angle,minr,maxr,thresh);
            figure(3)
            plot(px(:,1),py(:,2),'.b')
            hold on;
            plot(para(:,2),para(:,1),'+r');
            circleParaXYR=para;
        case '2'
            circle_center=[para(:,2),para(:,1)];
            PX=px;PY=py;
%             FFs_x=zeros(9,size(PX,2),7);
%             FFs_y=FFs_x;
%             for i = 1:7
%                 eval(['FFs_x_',num2str(i),'=[]']);
%                 eval(['FFs_y_',num2str(i),'=[]']);
%             end
            for i=1:size(circle_center,1)
               dis(:,i)=sqrt((PX(:,1)-circle_center(i,1)).^2+(PY(:,1)-circle_center(i,2)).^2);
            end
            
            for i=1:size(dis,2)
                FF_x=[];FF_y=[];
                [x,y]=find(dis(:,i)<120);
                for j=1:size(x,1)
                   FF_x=[FF_x;PX(x(j,1),:)]; 
                   FF_y=[FF_y;PY(x(j,1),:)]; 
                end
                for k=1:size(FF_x,2)
                    [x0,y0,r0,n1,n2,cha] = f_NiheCircle(FF_x(:,k),FF_y(:,k),0,1);
                    px_c(i,k)=x0;
                    py_c(i,k)=y0;
                end
                
            end
            [rms_circle,~]=rms_mean_std(px_c(:,:),py_c(:,:)); %% 原图出的稳定性
            mean(pxy_all_unit)
            mean(rms_circle)

            
        case'nouse'
            mean(rms_w)
            [rms_r,~]=rms_mean_std(px_r(:,:),py_r(:,:)); %% 原图出的稳定性
            mean(rms_r)
            px_r1=[];py_r1=[];
            for i=1:size(px_r,1)
                if(px_r(i,1)>5000  && px_r(i,1)<6000 && py_r(i,1)>2200 && py_r(i,1)<2600)
                    px_r1=[px_r1;px_r(i,:)];
                    py_r1=[py_r1;py_r(i,:)];
                end
            end
            for i=1:size(py_r1,2)
                [x0,y0,r0,n1,n2,cha] = f_NiheCircle(px_r1(:,i),py_r1(:,i),0,1);
                px_r1_c(1,i)=x0;
                py_r1_c(1,i)=y0;
            end
            [rms_r1,~]=rms_mean_std(px_r1(:,:),py_r1(:,:)); %% 原图出的稳定性
            mean(rms_r1)
            [rms_r1_c,~]=rms_mean_std(px_r1_c(:,:),py_r1_c(:,:)); %% 原图出的稳定性
            
            
        case'rf1' %%像素处理
            unit_num=74;
            
            [pxy_bdb,plilun_rms_bdb]=pixcel_process(px(1:unit_num,:),py(1:unit_num,:));
            [pxy_rf,plilun_rms_rf]=pixcel_process(px(unit_num+1:end,:),py(unit_num+1:end,:));
            px_rf=px(unit_num+1:end,:);py_rf=py(unit_num+1:end,:);
            
            %             figure();plot(px_rf(:,1),py_rf(:,1),'.b');rf_lilun=[5769,4116;6152,4116;6535,4116;5962,3785.75000000000;6345,3785.75000000000;6155,3455.50000000000;6538,3455.50000000000];
            %             hold on;plot(rf_lilun(:,1),rf_lilun(:,2),'.r');
            %             for i=1:size(px_rf,2)
            %                 for j=1:size(rf_lilun,1)
            %                     circle_point=[];
            %                     circle_point=f_find_c(px_rf(:,i),py_rf(:,i),rf_lilun(j,:),300);
            %                     [x0,y0,r0,n1,n2,cha] = f_NiheCircle(circle_point(:,1),circle_point(:,2),0,1);
            %                     Nihe_Circle_x(j,i)=x0;Nihe_Circle_y(j,i)=y0;
            %                 end
            %             end
            
            %             for i=1:size(px_rf,2)
            %              [x0,y0,r0,n1,n2,cha] = f_NiheCircle(px_rf(:,i),py_rf(:,i),0,1);
            %             Nihe_Circle_x(1,i)=x0;Nihe_Circle_y(1,i)=y0;
            %             end
            
            [pxy_all_circle,pxy_rms_circle]=rms_mean_std(Nihe_Circle_x(:,:),Nihe_Circle_y(:,:));
            [pxy_circle,plilun_rms_circle]=pixcel_process(Nihe_Circle_x,Nihe_Circle_y);
        case'rf2' %%整体平移
            unit_num=74;
            lilun_p=[];
            lilun_p(1,:)=mean(px(),1);lilun_p(2,:)=mean(py(),1);
            for i=1:size(px,2)
                PX(:,i)= px(:,i)-lilun_p(1,i);
                PY(:,i)= py(:,i)-lilun_p(2,i);
            end
            [pxy_bdb,plilun_rms_bdb]=rms_mean_std(PX(1:unit_num,:),PY(1:unit_num,:));
            [pxy_rf,plilun_rms_rf]=rms_mean_std(PX(unit_num+1:end,:),PY(unit_num+1:end,:));
            px_rf=PX(unit_num+1:end,:);py_rf=PY(unit_num+1:end,:);
            for i=1:size(px_rf,2)
                [x0,y0,r0,n1,n2,cha] = f_NiheCircle(px_rf(:,i),py_rf(:,i),0,1);
                Nihe_Circle_x(1,i)=x0;Nihe_Circle_y(1,i)=y0;
            end
            [pxy_circle,plilun_rms_circle]=rms_mean_std(Nihe_Circle_x,Nihe_Circle_y);
        case'rf'
            LED4_x=[];unit3=[];LED4_y=[];
            LED4_x=Z_D_x1(end-7:end,1);LED4_y=Z_D_y1(end-7:end,1);unit3=unit1(end-7:end,:);
            %                     param_x_all(:,i)=canshu_x2;
            %                     param_y_all(:,i)=canshu_y2;
            xx=[];yy=[];px4=[];py4=[];
            for i=1:image_count
                XY5(:,1)=positions_now(:,1,i);
                XY5(:,2)=positions_now(:,2,i);
                XY5(:,3)=positions_now(:,3,i);
                XY5(:,4)=positions_now(:,4,i);
                biaoding=30;
                param_x2=param_x_all(:,i);
                param_y2=param_y_all(:,i);
                [XY9,GoodUnit,GoodXY9,num,dx,dy]  =  f_Match(unit3,LED4_x,LED4_y,XY5,biaoding,param_x2,param_y2,5000);
                xx(:,i)=XY9(1:size(unit3,1),5);
                yy(:,i)=XY9(1:size(unit3,1),6);
                px4(:,i)=XY9(1:size(unit3,1),1);
                py4(:,i)=XY9(1:size(unit3,1),2);
                a=i/image_count
            end
            %                 for i1=1:size(xx,1)
            %                     xx2(i1,:)=xx(i1,:)-xx(1,:);
            %                     yy2(i1,:)=yy(i1,:)-yy(1,:);
            %                 end
            [pxy_all_led,pxy_rms_led]=rms_mean_std(px4,py4);
            mean_std_ppxy(:,2)=pxy_rms_led;
            [txy_all_unit,aa]=rms_mean_std(xx,yy);
            x_rf=xx;y_rf=yy;
            %                 [txy_all_led,txy_rms_unit_led(:,2)]=rms_mean_std(xx(end-3:end,:),yy(end-3:end,:));
            mean_std_ttxy1(1:3,2)=aa(1:3,1);
            %                 mean_std_ttxy(1,averi+2)=sqrt(sum(std_ttxy.*std_ttxy/(size(std_ttxy,1))));
            %                 mean_std_ttxy(2,averi+2)=mean(std_ttxy);
            %                 mean_std_ttxy(3,averi+2)=std(std_ttxy);
            mean_std_ttxy1(4,2)=size(px4,1);
            
            %                 [txy_all_unit11,aa11]=rms_mean_std(xx2(2:end,:),yy2(2:end,:));
            %                 mean_std_ttxy11(1:3,2)=aa11(1:3,1);
            %                 mean_std_ttxy11(4,2)=size(xx2,1);
            %             end
            
        case'33'
            
        case '2'
            for i=1:size(x_rf,2)
                [x0,y0,r0,n1,n2,cha] = f_NiheCircle(x_rf(:,i),y_rf(:,i),0,' ') ;
                temp(1,1)=x0(1,1);temp(1,2)=y0(1,1);temp(1,3)=r0(1,1);temp(1,4)=n1(1,1);
                xy_rf(i,:)=temp(1,:);
            end
            xx_rf=xy_rf(:,1)';yy_rf=xy_rf(:,2)';
            [rf_rms_all,rf_rms]=rms_mean_std(xx_rf,yy_rf);
            figure()
            plot(xx_rf(1,:),yy_rf(1,:),'.r')
            
            for i=1:size(px4,2)
                [x0,y0,r0,n1,n2,cha] = f_NiheCircle(px4(:,i),py4(:,i),0,'pixel') ;
                temp(1,1)=x0(1,1);temp(1,2)=y0(1,1);temp(1,3)=r0(1,1);temp(1,4)=n1(1,1);
                pxy_rf(i,:)=temp(1,:);
            end
            pxx_rf=pxy_rf(:,1)';pyy_rf=pxy_rf(:,2)';
            [prf_rms_all,prf_rms]=rms_mean_std(pxx_rf,pyy_rf);
            figure()
            plot(pxx_rf(1,:),pyy_rf(1,:),'.r')
            
            
            rms_nihec=figure_cirlle(pxx_rf,pyy_rf,xx_rf,yy_rf,1)
            
            
            
        case '22'%%所有参与拟合
            %             load('positions','positions','fpath','image_count')
            %             Z_D_x=Z_D_x1(1:end-4,1);Z_D_y=Z_D_y1(1:end-4,1);
            %             LED4(:,1)=Z_D_x1(end-3:end,1);LED4(:,2)=Z_D_y1(end-3:end,1);unit=unit1(1:end-4,:);
            Z_D_x=Z_D_x1;Z_D_y=Z_D_y1;unit=unit1;
            %             LED4(:,1)=Z_D_x1(end-3:end,1);LED4(:,2)=Z_D_y1(end-3:end,1);
            
            for averi=2:2
                positions_now=[];
                if averi==1
                    positions_now=positions_1_end(:,:,:);
                end
                
                if averi==2
                    positions_now=positions_5_end(:,:,:);
                end
                
                figure(1)
                plot(positions_now(:,1,size(positions_now,3)),positions_now(:,2,size(positions_now,3)),'.')
                
                figure(2)
                plot(Z_D_x,Z_D_y,'.')
                hold on;
                plot(Point(:,3)*100000,Point(:,4)*100000,'+r')
                lilun_x=Z_D_x;
                lilun_y=Z_D_y;
                x=Point(:,1);
                y=Point(:,2);
                lilun_x1=Point(:,3)*100000;
                lilun_y1=Point(:,4)*100000;
                
                biaoding=6;
                
                [canshu_x,canshu_y,dblCoorX,dblCoorY,cha_x,cha_y,cha]=f_NiheParam(biaoding,x,y,lilun_x1,lilun_y1,'');
                %             cha_mm=cha/1000;
                %             jiajiao=canshu_x(5)*180*60/pi;
                %             sprintf('xiang_x0=%20.25f\nxiang_y0=%20.25f\nxiang_a0=%20.25f\nbili_x0=%20.25f\nbili_y0=%20.25f',canshu_x(1),canshu_x(2),jiajiao,canshu_x(3),canshu_x(4))
                param_x1=canshu_x;
                param_y1=canshu_y;
                
                param_y1=canshu_y;
                %         case '3'
                %             close all;
                image_count=size(positions_now,3);
                XY5=[];GGXY8=zeros(500,8);GGXY8_unit=[];
                xx=zeros(size(unit,1),1,image_count);
                yy=zeros(size(unit,1),1,image_count);
                tx=[];ty=[]; x=[];y=[];lilun_x1=[];lilun_y1=[];px=[];py=[];pw=[];pz=[];param_xy=[];cond_a=[];
                
                for i=1:image_count
                    XY5(:,1)=positions_now(:,1,i);
                    XY5(:,2)=positions_now(:,2,i);
                    XY5(:,3)=positions_now(:,3,i);
                    XY5(:,4)=positions_now(:,4,i);
                    biaoding=6;
                    [XY8,GoodUnit,GoodXY8,num,dx,dy]  =  f_Match(unit,Z_D_x,Z_D_y,XY5,biaoding,param_x1,param_y1,5000);
                    
                    ifdraw=0;
                    
                    
                    if ifdraw==1
                        figure()
                        plot(GoodXY8(:,7),GoodXY8(:,8),'.g')
                        hold on;
                        plot(GoodXY8(:,5),GoodXY8(:,6),'.r')
                    end
                    
                    
                    for i4=1:1
                        x=[];y=[];lilun_x1=[];lilun_y1=[];
                        for k=1:size(GoodXY8,1)
                            %                     for k=1:30
                            c=k;
                            x(k,1)=GoodXY8(c,1);
                            y(k,1)=GoodXY8(c,2);
                            lilun_x1(k,1)=GoodXY8(c,7);
                            lilun_y1(k,1)=GoodXY8(c,8);
                        end
                        
                        biaoding=30;
                        [canshu_x2,canshu_y2,dblCoorX,dblCoorY,cha_x,cha_y,cha,conda]=f_NiheParam(biaoding,x,y,lilun_x1,lilun_y1,'');
                        %             cha_mm=cha/1000;
                        %             jiajiao=canshu_x(5)*180*60/pi;
                        %             sprintf('xiang_x0=%20.25f\nxiang_y0=%20.25f\nxiang_a0=%20.25f\nbili_x0=%20.25f\nbili_y0=%20.25f',canshu_x(1),canshu_x(2),jiajiao,canshu_x(3),canshu_x(4))
                        
                        cond_a(:,i)=conda;
                        param_x_all(:,i)=canshu_x2;
                        param_y_all(:,i)=canshu_y2;
                        param_x2=canshu_x2;
                        param_y2=canshu_y2;
                        [XY9,GoodUnit,GoodXY9,num,dx,dy]  =  f_Match(unit,Z_D_x,Z_D_y,XY5,biaoding,param_x2,param_y2,5000);
                        
                        [XX1,YY1]=f_NiheTrans(biaoding,param_x2,param_y2,XY5(:,1),XY5(:,2));
                        if ifdraw==1
                            
                            figure()
                            plot(XX1(:,1),YY1(:,1),'.b')
                            hold on;
                            plot(GoodXY9(:,7),GoodXY9(:,8),'.r')
                            hold on;
                            plot(GoodXY9(:,5),GoodXY9(:,6),'.g')
                            axis([-800000 400000 -200000 800000])
                        end
                    end
                    param_xy(:,1,i)=param_x2;
                    param_xy(:,2,i)=param_y2;
                    xx(:,1,i)=XY9(1:size(unit,1),5);
                    yy(:,1,i)=XY9(1:size(unit,1),6);
                    px(:,i)=XY9(1:size(unit,1),1);
                    py(:,i)=XY9(1:size(unit,1),2);
                    pw(:,1,i)=XY9(1:size(unit,1),3);
                    pz(:,1,i)=XY9(1:size(unit,1),4);
                    a=i/image_count
                end
                [pxy_all_unit,pxy_rms_unit]=rms_mean_std(px(1:end-4,:),py(1:end-4,:));
                [txy_all_unit,txy_rms_unit_led(:,1)]=rms_mean_std(xx(1:end-4,:),yy(1:end-4,:));
                [txy_all_led,txy_rms_unit_led(:,2)]=rms_mean_std(xx(end-3:end,:),yy(end-3:end,:));
                % % rr% % % %                 % % % % % % % % % %          % % % % % % % % % % % %             % % % % % % %                 % % % % % % % % % % % % % % % % % %        r
                LED4_x=[];unit3=[];LED4_y=[];
                LED4_x=Z_D_x1(end-3:end,1);LED4_y=Z_D_y1(end-3:end,1);unit3=unit1(end-3:end,:);
                %                     param_x_all(:,i)=canshu_x2;
                %                     param_y_all(:,i)=canshu_y2;
                xx=[];yy=[];px4=[];py4=[];
                for i=1:image_count
                    XY5(:,1)=positions_now(:,1,i);
                    XY5(:,2)=positions_now(:,2,i);
                    XY5(:,3)=positions_now(:,3,i);
                    XY5(:,4)=positions_now(:,4,i);
                    biaoding=30;
                    param_x2=param_x_all(:,i);
                    param_y2=param_y_all(:,i);
                    [XY9,GoodUnit,GoodXY9,num,dx,dy]  =  f_Match(unit3,LED4_x,LED4_y,XY5,biaoding,param_x2,param_y2,5000);
                    [XX1,YY1]=f_NiheTrans(biaoding,param_x2,param_y2,XY5(:,1),XY5(:,2));
                    xx(:,1,i)=XY9(1:size(unit3,1),5);
                    yy(:,1,i)=XY9(1:size(unit3,1),6);
                    px4(:,i)=XY9(1:size(unit3,1),1);
                    py4(:,i)=XY9(1:size(unit3,1),2);
                    a=i/image_count
                end
                [pxy_all_led,pxy_rms_led]=rms_mean_std(px4,py4);
                
                figure(4)
                plot(xx(:,1,1),yy(:,1,1),'.')
                mean_a=mean(cond_a)
                ttxy=[];
                ttxy(:,1,:)=xx(:,1,:);
                ttxy(:,2,:)=yy(:,1,:);
                for j8=1:size(ttxy,1)
                    %                 for jj8=1:size(ppxy,2)
                    for jjj8=1:size(ttxy,3)
                        if or(ttxy(j8,1,jjj8)==0,ttxy(j8,2,jjj8)==0)
                            ttxy(j8,:,jjj8)=0;
                        end
                        %                     end
                    end
                end
                tx=[];ty=[];
                for i=1:size(ttxy,3)
                    tx(:,i)=ttxy(:,1,i);
                    ty(:,i)=ttxy(:,2,i);
                end
                
                ttx=[];tty=[];
                ttx=tx;
                tty=ty;
                
                for j7=1:size(ttx,1)
                    for jj7=1:size(ttx,2)
                        if or(ttx(j7,jj7)==0,tty(j7,jj7)==0)
                            ttx(j7,:)=0;
                            tty(j7,:)=0;
                        end
                    end
                end
                ttx(all(ttx==0,2),:)=[];
                tty(all(tty==0,2),:)=[];
                a=size(ttx,1)
                zhangshu=size(ttx,2);
                cha_ttx=[];cha_tty=[];ave_xx1=[];ave_yy1=[];
                ave_xx1=mean(ttx,2);
                ave_yy1=mean(tty,2);
                for i=1:size(ttx,2)
                    cha_ttx(:,i) = ttx(:,i) - ave_xx1(:,1);
                    cha_tty(:,i) = tty(:,i) - ave_yy1(:,1);
                end
                cha_ttxy=sqrt(cha_ttx(:,:).*cha_ttx(:,:) + cha_tty(:,:).*cha_tty(:,:));
                std_ttxy=[];
                for i=1:size(cha_ttxy,1)
                    std_ttxy(i,1)=sqrt(sum(cha_ttxy(i,:).*cha_ttxy(i,:))/size(cha_ttxy,2));
                end
                mean_std_ttxy(1,averi+2)=sqrt(sum(std_ttxy.*std_ttxy/(size(std_ttxy,1))));
                mean_std_ttxy(2,averi+2)=mean(std_ttxy);
                mean_std_ttxy(3,averi+2)=std(std_ttxy);
                mean_std_ttxy(4,averi+2)=size(ttx,1);
                
            end
        case'7'
            positions_5
            
            
        case '0'  % 读raw图片到矩阵
            p_image=dir(strcat(fpath,'*.raw'));
            image_count=size(p_image,1);      %获取文件夹内所有图片数
            dircell=struct2cell(p_image)';   %将结构体转换为元胞数组
            image_profile=dircell(:,1);
            alldots=zeros(600,4,image_count);
            for i=20:image_count   %% 读图片 20->end
                data_1_all=zeros(6004,7920);
                for j=1:1
                    filename=char(image_profile((i-1)*1+j,1));
                    rawfile = [fpath, filename];
                    f = fopen(rawfile,'r');
                    %           case '10'
                    bits = 12;
                    colcount = 7920;
                    rowcount = 6004;
                    if (bits == 16)
                        rawstyle = 'uint8';
                    else
                        rawstyle = 'uint16';
                    end
                    data_temp=zeros(7920,6004);
                    data_temp= fread(f,[colcount,rowcount],rawstyle);
                    fclose(f);
                    data=data_temp;
                    data=fliplr(data); %延垂直左右反转
                    data = data'; % 长方形CMOS，不需要这句
                    data_1_all=data;
                end
                data_1=data_1_all;
                
                [positions_1] = f_CalFiberPos_pixel(data_1);
                [aa, bb]= size(positions_1);
                for m=1:aa
                    positions_1_end(1:m,:,i)=positions_1(1:m,:);
                end
                i
            end
            save('G:\20210629晚上加7参考光纤稳定性\20210629.mat');
            
    end
end