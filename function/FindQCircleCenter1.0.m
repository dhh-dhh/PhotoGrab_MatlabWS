% 通过霍夫算法计算参考光纤稳定性

% % 参考光纤单元稳定性
addpath('function');addpath(genpath(pwd));

% close all;
Z_D_x1=[];Z_D_y1=[];D_Y=[];

while 1
    
    %修改文件目录
    bb=char('请选择要进行的操作：','0--提取raw文件像素坐标   11----画两幅图  12----画标定靶的图　 2----选取4个点  3---每一张单独匹配像素坐标和理论坐标 4---每一次减去五次平均的值  5---赋值  61---每一次减去五次平均的值=4  62---每一次减去整体平均的标准差   63---五次平均的标准差  64---十次平均的标准差');
    choice=inputdlg(bb);
    switch lower(choice{1})
            %% 可以改成已经匹配上的Q附近找点
        case '1'
%             clear;s
            Flag=0;         %%0：只处理PQ单元；1：全读。
            F_N='211208_141829_00_000_00.txt';%把相机txt文件名称复制进去
            fid=fopen(F_N,'r');
            UnitName=[];
            m=0;
            while ~feof(fid)
                m=m+1;
                D_Y=fscanf(fid,'%s',1);
                G_D_x(m)=fscanf(fid,'%f',1);
                G_D_y(m)=fscanf(fid,'%f',1);
                if strcmp(D_Y(1),'P')||strcmp(D_Y(1),'Q')||Flag
                    fscanf(fid,'%f',2);
                    Nihe_x(m)=fscanf(fid,'%f',1);
                    Nihe_y(m)=fscanf(fid,'%f',1);
                    Z_D_x(m)=fscanf(fid,'%f',1);
                    Z_D_y(m)=fscanf(fid,'%f',1);
                    UnitName{m}=D_Y;
                else
                    fscanf(fid,'%f',2);
                    Nihe_x(m)=fscanf(fid,'%f',1);
                    Nihe_y(m)=fscanf(fid,'%f',1);
                end
                
                fgetl(fid);
            end
            fclose(fid);
            for i=size(G_D_x,2):-1:1
               if  (G_D_x(1,i)>3000 || G_D_x(1,i)<-3000 || G_D_y(1,i)>3000 || G_D_y(1,i)<-3000|| isnan(G_D_y(1,i)) || isnan(G_D_x(1,i)))
                   G_D_x(:,i)=[];
                   G_D_y(:,i)=[];
               end
            end
            figure(1)
            plot(G_D_x,G_D_y,'.b');
            px=G_D_x';
            py=G_D_y';
            Flag=0;         %%0：只处理PQ单元；1：全读。
            %             F_N='211007_195410_00_000_00.txt';%把相机txt文件名称复制进去
            fid=fopen(F_N,'r');
            UnitName=[];
            m=0;
            Qpx=[];Qpy=[];Qlx=[];Qly=[];
            while ~feof(fid)
                m=m+1;
                D_Y=fscanf(fid,'%s',1);
                if strcmp(D_Y(1),'Q')||Flag
                    Qpx=[Qpx;fscanf(fid,'%f',1)];
                    Qpy=[Qpy;fscanf(fid,'%f',1)];
                    fscanf(fid,'%f',4);
                    Qlx=[Qlx;fscanf(fid,'%f',1)];
                    Qly=[Qly;fscanf(fid,'%f',1)];
                end
                fgetl(fid);
            end
            fclose(fid);
            FF_C_bk=load('FFCircle.txt');
            hold on;
            plot(Qpx,Qpy,'+r');
            hold on;
            plot(FF_C_bk(:,1),FF_C_bk(:,2),'+g');
            
            figure()
            plot(Qlx,Qly,'.b');
           
        case '2'
%             load('20211027_FF.mat');
%             circle_center=circle_center_raw_s;
            circle_center=[Qpx,Qpy];
            PX=px;PY=py;dis=[];
            for i=1:size(circle_center,1)
                dis(:,i)=sqrt((PX(:,1)-circle_center(i,1)).^2+(PY(:,1)-circle_center(i,2)).^2);
            end
            for i=1:size(dis,2)
                FF_x=[];FF_y=[];
                [x,y]=find(dis(:,i)<160);
%                 [x,y]=find(dis(:,i)<85 & dis(:,i)>75);
                
                for j=1:size(x,1)
                    FF_x=[FF_x;PX(x(j,1),:)];
                    FF_y=[FF_y;PY(x(j,1),:)];
                end
                
                [x0,y0,r0,n1,n2,cha] = f_NiheCircle(FF_x,FF_y,0,1);
                pxy_c(i,1)=x0;
                pxy_c(i,2)=y0;
                pxy_r(i,1)=r0;
                
            end
            figure(3)
            plot(px(:,1),py(:,1),'.b')
            hold on;
            for i=1:size(pxy_c,1)
               drawcircle(pxy_c(i,1:2),pxy_r(i,1)) 
            end
            plot(pxy_c(:,1),pxy_c(:,2),'+r');
           
            
            %% 将pxy_c 坐标复制到FFCircle.txt 中 并将txt文件拷贝到F:\Paohe\bin 中替换
             case '21' %%匹配好的情况下再次筛选
%             load('20211027_FF.mat');
%             circle_center=circle_center_raw_s;
            circle_center=[Qpx,Qpy];
            PX=px;PY=py;dis=[];
            for i=1:size(circle_center,1)
                dis(:,i)=sqrt((PX(:,1)-circle_center(i,1)).^2+(PY(:,1)-circle_center(i,2)).^2);
            end
            for i=1:size(dis,2)
                FF_x=[];FF_y=[];
                [x,y]=find(dis(:,i)<85 & dis(:,i)>75);
                for j=1:size(x,1)
                    FF_x=[FF_x;PX(x(j,1),:)];
                    FF_y=[FF_y;PY(x(j,1),:)];
                end
                
                [x0,y0,r0,n1,n2,cha] = f_NiheCircle(FF_x,FF_y,0,1);
                pxy_c(i,1)=x0;
                pxy_c(i,2)=y0;
                pxy_r(i,1)=r0;
                
            end
            figure(3)
            plot(px(:,1),py(:,1),'.b')
            hold on;
            for i=1:size(pxy_c,1)
               drawcircle(pxy_c(i,1:2),pxy_r(i,1)) 
            end
            plot(pxy_c(:,1),pxy_c(:,2),'+r');
           
            
            %% 将pxy_c 坐标复制到FFCircle.txt 中 并将txt文件拷贝到F:\Paohe\bin 中替换
       case '3'
%             bad_point=[802,-61.69];
            bad_point=[1766,-1536];
%             load('20211027_FF.mat');
%             circle_center=circle_center_raw_s;
            circle_center=pxy_c;
            PX=px;PY=py;dis=[];
            for i=size(PX,1):-1:1
                if(PX(i,1)<bad_point(1,1)+5 && PX(i,1)>bad_point(1,1)-5 && PY(i,1)<bad_point(1,2)+5 && PY(i,1)>bad_point(1,2)-5)
                    PX(i,:)=[];PY(i,:)=[];
                end
            end
            for i=1:size(circle_center,1)
                dis(:,i)=sqrt((PX(:,1)-circle_center(i,1)).^2+(PY(:,1)-circle_center(i,2)).^2);
            end
            for i=1:size(dis,2)
                FF_x=[];FF_y=[];
                [x,y]=find(dis(:,i)<80);
                for j=1:size(x,1)
                    FF_x=[FF_x;PX(x(j,1),:)];
                    FF_y=[FF_y;PY(x(j,1),:)];
                end
                
                [x0,y0,r0,n1,n2,cha] = f_NiheCircle(FF_x,FF_y,0,1);
                pxy_c(i,1)=x0;
                pxy_c(i,2)=y0;
                pxy_r(i,1)=r0;
                
            end
            figure(4)
            plot(px(:,1),py(:,1),'.b')
            hold on;
            plot(pxy_c(:,1),pxy_c(:,2),'+r');
           
            
            %% 将pxy_c 坐标复制到FFCircle.txt 中 并将txt文件拷贝到F:\Paohe\bin 中替换
        case '5'
            FFCircle=load('FFCircle.txt');
            FFLilun=load('FFLilun_LL.txt');
            [canshu_x,canshu_y,dblCoorX,dblCoorY,cha_x,cha_y,cha]=f_NiheParam(5,FFCircle(:,1),FFCircle(:,2),FFLilun(:,1),FFLilun(:,2),'');
            cha_mm=cha/1000;
            jiajiao=canshu_x(5)*180*60/pi;    % 角度参数使用‘分’，不用弧度。
            sprintf('xiang_x0=%20.25f\nxiang_y0=%20.25f\nxiang_a0=%20.25f\nbili_x0=%20.25f\nbili_y0=%20.25f',canshu_x(1),canshu_x(2),jiajiao,canshu_x(3),canshu_x(4))
        case '3'
            %% 由相机5参数反推出单元理论坐标
            
            canshu_y=0;
            %             Pixcel=FFCircle;
            Pixcel=pxy_c;
            figure(4);
            plot(Pixcel(:,1),Pixcel(:,2),'.b')
            
            
            
            [LilunX,LilunY]=f_NiheTrans(5,canshu_x,canshu_y,circle_center_raw_s(:,1),circle_center_raw_s(:,2)); %实际微米坐标
            LilunFF=[LilunX,LilunY];
            figure();
            plot(LilunFF(:,1),LilunFF(:,2),'.r')
            hold on;
            plot(Q_lilun(:,1),Q_lilun(:,2),'+b')
            %             save('FFLilun.txt','FFCircle');
            %%
            %
            
            %                  case '3' %% 读txt
            %             Flag=0;         %%0：只处理PQ单元；1：全读。
            %             F_N='211007_195410_00_000_00.txt';%把相机txt文件名称复制进去
            %             fid=fopen(F_N,'r');
            %             UnitName=[];
            %             m=0;
            %             while ~feof(fid)
            %                 m=m+1;
            %                 D_Y=fscanf(fid,'%s',1);
            %                 G_D_x(m)=fscanf(fid,'%f',1);
            %                 G_D_y(m)=fscanf(fid,'%f',1);
            %                 if strcmp(D_Y(1),'P')||strcmp(D_Y(1),'Q')||Flag
            %                     fscanf(fid,'%f',2);
            %                     Nihe_x(m)=fscanf(fid,'%f',1);
            %                      Nihe_y(m)=fscanf(fid,'%f',1);
            %                     Z_D_x(m)=fscanf(fid,'%f',1);
            %                     Z_D_y(m)=fscanf(fid,'%f',1);
            %                     UnitName{m}=D_Y;
            %                 else
            %                     fscanf(fid,'%f',2);
            %                      Nihe_x(m)=fscanf(fid,'%f',1);
            %                      Nihe_y(m)=fscanf(fid,'%f',1);
            %                 end
            %
            %                 fgetl(fid);
            %             end
            %             fclose(fid);
            %
            %             figure(1)
            %             plot(G_D_x,G_D_y,'.b');
            %             px=G_D_x';
            %             py=G_D_y';
            %          case '4'
            %             for i=size(px,1):-1:1
            %                 if px(i,1)==0 || py(i,1)==0
            %                     px(i,:)=[];
            %                     py(i,:)=[];
            %                 end
            %             end
            %             t=-min(min(px),min(py))+1000;
            %
            %             % 步长为1，即每次检测的时候增加的半径长度
            %             step_r = 0.3;
            %             %检测的时候每次转过的角度
            %             step_angle = 0.2;
            %             % 对检测的圆的大小范围预估，在实际项目中因为产品大小固定，所以可以给定较小范围，提高运行速度
            %             minr =77;
            %             maxr = 85;
            %             % 自动取最优的灰度阈值
            %             %thresh = graythresh(I);
            %              thresh =0.58;
            %             % 调用hough_circle函数进行霍夫变换检测圆
            %             [hough_space,hough_circle1,para] = hough_circle_dot(px+t,py+t,step_r,step_angle,minr,maxr,thresh);
            %
            %           %% 这一步需要手动删para中的点
            %             figure(3)
            %             plot(px(:,1)+t,py(:,1)+t,'.b')
            %             hold on;
            %             plot(para(:,2),para(:,1),'+r');
            %             circleParaXYR=para;
        case 'rms'
            circle_center=[para(:,2),para(:,1)];
            PX=px;PY=py;
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
            
            
    end
end