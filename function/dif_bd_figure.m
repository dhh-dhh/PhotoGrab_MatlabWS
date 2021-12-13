function [txy_rms_unit]=dif_bd_figure(positions_now,biaoding,dataDir,param_x1,param_y1);
% dataDir='lilun_rf.txt';
fid=fopen(dataDir,'r');Z_D_x1=[];Z_D_y1=[];D_Y=[];unit=[];LED4=[];unit1=[];
while ~feof(fid)
    D_Y=fscanf(fid,'%s',1);  %¶ÁÈ¡µ¥ÔªºÅ
    Z_D_x1=[Z_D_x1;fscanf(fid,'%f',1)];
    Z_D_y1=[Z_D_y1;fscanf(fid,'%f',1)];
    unit1=[unit1;D_Y];
    fgetl(fid);
end
fclose(fid);  
Z_D_x=Z_D_x1;Z_D_y=Z_D_y1;unit=unit1;
tx=[];ty=[]; x=[];y=[];lilun_x1=[];lilun_y1=[];px=[];py=[];pw=[];pz=[];param_xy=[];cond_a=[];
xx=[];yy=[];image_count=size(positions_now,3);
for i=1:image_count
    XY5(:,1)=positions_now(:,1,i);
    XY5(:,2)=positions_now(:,2,i);
    XY5(:,3)=positions_now(:,3,i);
    XY5(:,4)=positions_now(:,4,i);
    biaoding1=6;
    [XY8,GoodUnit,GoodXY8,num,dx,dy]  =  f_Match(unit,Z_D_x,Z_D_y,XY5,biaoding1,param_x1,param_y1,5000);
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
        
        %                         biaoding=30;
        [canshu_x2,canshu_y2,dblCoorX,dblCoorY,cha_x,cha_y,cha,conda]=f_NiheParam(biaoding,x,y,lilun_x1,lilun_y1,'');
        cond_a(:,i)=conda;
        param_x_all(:,i)=canshu_x2;
        param_y_all(:,i)=canshu_y2;
        param_x2=canshu_x2;
        param_y2=canshu_y2;
        %**********************************************************************************************
        
        [XY9,GoodUnit,GoodXY9,num,dx,dy]  =  f_Match(unit,Z_D_x,Z_D_y,XY5,biaoding,param_x2,param_y2,5000);
        
        [XX1,YY1]=f_NiheTrans(biaoding,param_x2,param_y2,XY5(:,1),XY5(:,2));
    end
    param_xy(:,1,i)=param_x2;
    param_xy(:,2,i)=param_y2;
    xx(:,i)=XY9(1:size(unit,1),5);
    yy(:,i)=XY9(1:size(unit,1),6);
    px(:,i)=XY9(1:size(unit,1),1);
    py(:,i)=XY9(1:size(unit,1),2);
    a=i/image_count
end
                for i=size(xx,2):-1:1
                    for j=size(xx,1):-1:1
                        if xx(j,i)==0 || yy(j,i)==0
                            xx(:,i)=[];yy(:,i)=[];px(:,i)=[];py(:,i)=[];
                        end
                    end
                end
[txy_all_unit1,txy_rms_unit]=rms_mean_std(xx(:,:),yy(:,:));
txy_rms_unit=roundn(txy_rms_unit,-2);
%                 [txy_all_unit1,aa1]=rms_mean_std(xx,yy);
% figure()
scatterbar3(xx(:,1),yy(:,1),txy_all_unit1,15000)
colorbar;