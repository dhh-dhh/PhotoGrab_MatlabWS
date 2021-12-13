%%%%%如果if_CalcParam=1 且axes=cen:通过计算得出相面圆心，读入理论圆心，拟合30参数
%%%%%其他情况,读入30参数

%2017.7.5 lzg start

if if_CalcParam == 2;
    load(param_2_fn);
    circle=zeros(point_num,25);
elseif if_CalcParam == 3;
  param_x=[param_3_x];
  param_y=[param_3_y];
elseif if_CalcParam == 4;
	param_x=[1];
	param_y=[1];
	circle=[]; 
elseif strcmp(axes,'ecc')
    %读取mat文件
     matfile1=strcat(dataDir,'\','nihe_param.mat');
    if exist(matfile1,'file')~=2,msgbox('没找到拟合参数文件');return;end
    load(matfile1);                 
elseif strcmp(axes,'cen')
    %%%%%圆拟和
    %%%%%%%%分单元循环
    s_Pre_mean;               % xx yy(fendu_times,paohe_turns,light_num)  => mean_x mean_y(fendu_times,1,light_num)
    circle=zeros(point_num,25);
    fid=fopen(canshu_fn,'rt');
    fgetl(fid);
    while ~feof(fid);
        unitall=strcat('P',fscanf(fid,'%s',1));
        for i=1:size(unit,2);
            if strcmp(unit{i},unitall);
                circle(i,[1:14])=fscanf(fid,'%f',14);
                break;               
            end;   
        end;
        fgetl(fid);     
    end;
    kkk = 0;
    for p=1:point_num;
        [nihe_x2,nihe_y2,nihe_r2]=f_NiheCircle(mean_x(:,1,p),mean_y(:,1,p));
        circle(p,15)=nihe_x2;
        circle(p,16)=nihe_y2;
        circle(p,17)=nihe_r2;
        if circle(p,17)<r_max && circle(p,17)>r_min;
            circle(p,14)=999;
        else                              %半径不在范围内，不使用此点
            circle(p,14)=0;
            kkk = kkk + 1;
        end;
    end
    msg = strcat('不正常单元所占比例： ',num2str(kkk/point_num));
    disp(msg);   
    
    %%%%% 输入量 chushi_x chushi_y x y lilun_x,lilun_y;
    %%%%%输出量trans_x trans_y trans_z  h f
    circle1=circle;
    for i=size(circle1(:,15),1):-1:1;
        if circle1(i,14)==0;
            circle1(i,:)=[];
        end;
    end;
    [param_x,param_y]=f_NiheParam(biaoding,circle1(:,15),circle1(:,16),circle1(:,3),circle1(:,4));
    [trans_x,trans_y]=f_NiheTrans(biaoding,param_x,param_y,circle(:,15),circle(:,16));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     [trans_x1,trans_y1]=f_NiheTrans(biaoding,param_x,param_y,circle1(:,15),circle1(:,16));
%     k_old=0;
%     while(1)
%         dd=sqrt((trans_x1-circle1(:,3)).^2 + (trans_y1-circle1(:,4)).^2);
%         dd1=sort(dd);
%         k=0;
%         for i=1:size(dd,1)
%             if dd(i)<10
%                 k=k+1;
%                 GdIndex(k)=i;
%             end
%         end
%         
%         if k==k_old
%             break;
%         else
%             k_old=k;
%         end
%         GoodIndex=GdIndex(1:k);
%         [param_x,param_y]=f_NiheParam(biaoding,circle1(GoodIndex,15),circle1(GoodIndex,16),circle1(GoodIndex,3),circle1(GoodIndex,4));
%         [trans_x1,trans_y1]=f_NiheTrans(biaoding,param_x,param_y,circle1(:,15),circle1(:,16));
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    R=19908200;
    circle(:,18)=trans_x;
    circle(:,19)=trans_y;
    circle(:,20)=sqrt(R^2-trans_x.^2-trans_y.^2)-R;     % trans_z
    circle(:,21)=atan(circle(:,18)./(R+circle(:,20)));	% 方位角
    circle(:,22)=asin(circle(:,19)/R);					% 高度角

%     newfile1=strcat(dataDir,'\','canshu_circle.txt');
%     fid=fopen(newfile1,'wt');
%     for i=1:size(trans_x,1);
%         fprintf(fid,'%s   :    ',unit{i});
%         fprintf(fid,'%5d ',circle(i,14));
%         fprintf(fid,'%15.6f ',R*circle(i,21));
%         fprintf(fid,'%15.6f ',R*circle(i,22));
%         fprintf(fid,'%15.6f ',trans_x(i));
%         fprintf(fid,'%15.6f ',trans_y(i));
%         fprintf(fid,'%15.6f ',circle(i,20));
%         fprintf(fid,'\t%28.25f ',circle(i,21));
%         fprintf(fid,'\t%28.25f ',circle(i,22));
%         fprintf(fid,'\n');
%     end;
%     fclose(fid);

    newfile2=strcat(dataDir,'\','nihe_cancha.txt');
    fid=fopen(newfile2,'wt');
    fprintf(fid,'1单元名  2单元好坏  3像面半径  4计算圆心坐标real_x  5计算圆心坐标real_y  6Z-R   7理论圆心坐标lx  8理论圆心坐标ly   9real_x-lx   10real_y-ly  11f  12h  13R*f  14R*h\t\n');
    for i=1:size(circle(:,3),1);
        fprintf(fid,'%s   :    ',unit{i});%单元名
        fprintf(fid,'%5d ',circle(i,14));%  0  or  999
        fprintf(fid,'%15.6f ',circle(i,17));  %像面半径
        fprintf(fid,'%15.6f ',trans_x(i));%计算所得实际圆心坐标x
        fprintf(fid,'%15.6f ',trans_y(i));%计算所得实际圆心坐标y
         fprintf(fid,'%15.6f ',circle(i,20));%Z-R
        fprintf(fid,'%15.6f ',circle(i,3));%理论圆心坐标x
        fprintf(fid,'%15.6f ',circle(i,4));%理论圆心坐标y
        fprintf(fid,'%15.6f ',trans_x(i)-circle(i,3));%实际圆心坐标x-理论圆心坐标x
        fprintf(fid,'%15.6f ',trans_y(i)-circle(i,4));%实际圆心坐标x-理论圆心坐标x
        fprintf(fid,'\t%28.25f ',circle(i,21));%方位角
        fprintf(fid,'\t%28.25f ',circle(i,22));%高度角
        fprintf(fid,'%15.6f ',R*circle(i,21));%R*方位角
        fprintf(fid,'%15.6f ',R*circle(i,22));%R*高度角
        fprintf(fid,'\n');
    end;
    fclose(fid);

    newfile3=strcat(dataDir,'\','nihe_param.txt');
    fid=fopen(newfile3,'wt');
    for i=1:size(param_x,1);
        fprintf(fid,'\t%28.25f    ',param_x(i));
        fprintf(fid,'\t%28.25f    ',param_y(i));
        fprintf(fid,'\n');
    end;
    fclose(fid);
    matfile=strcat(dataDir,'\','nihe_param.mat');
    save(matfile,'unit', 'circle','param_x','param_y');
end
