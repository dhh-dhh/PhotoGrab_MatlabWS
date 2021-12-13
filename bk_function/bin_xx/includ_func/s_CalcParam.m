%%%%%���if_CalcParam=1 ��axes=cen:ͨ������ó�����Բ�ģ���������Բ�ģ����30����
%%%%%�������,����30����

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
    %��ȡmat�ļ�
     matfile1=strcat(dataDir,'\','nihe_param.mat');
    if exist(matfile1,'file')~=2,msgbox('û�ҵ���ϲ����ļ�');return;end
    load(matfile1);                 
elseif strcmp(axes,'cen')
    %%%%%Բ���
    %%%%%%%%�ֵ�Ԫѭ��
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
        else                              %�뾶���ڷ�Χ�ڣ���ʹ�ô˵�
            circle(p,14)=0;
            kkk = kkk + 1;
        end;
    end
    msg = strcat('��������Ԫ��ռ������ ',num2str(kkk/point_num));
    disp(msg);   
    
    %%%%% ������ chushi_x chushi_y x y lilun_x,lilun_y;
    %%%%%�����trans_x trans_y trans_z  h f
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
    circle(:,21)=atan(circle(:,18)./(R+circle(:,20)));	% ��λ��
    circle(:,22)=asin(circle(:,19)/R);					% �߶Ƚ�

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
    fprintf(fid,'1��Ԫ��  2��Ԫ�û�  3����뾶  4����Բ������real_x  5����Բ������real_y  6Z-R   7����Բ������lx  8����Բ������ly   9real_x-lx   10real_y-ly  11f  12h  13R*f  14R*h\t\n');
    for i=1:size(circle(:,3),1);
        fprintf(fid,'%s   :    ',unit{i});%��Ԫ��
        fprintf(fid,'%5d ',circle(i,14));%  0  or  999
        fprintf(fid,'%15.6f ',circle(i,17));  %����뾶
        fprintf(fid,'%15.6f ',trans_x(i));%��������ʵ��Բ������x
        fprintf(fid,'%15.6f ',trans_y(i));%��������ʵ��Բ������y
         fprintf(fid,'%15.6f ',circle(i,20));%Z-R
        fprintf(fid,'%15.6f ',circle(i,3));%����Բ������x
        fprintf(fid,'%15.6f ',circle(i,4));%����Բ������y
        fprintf(fid,'%15.6f ',trans_x(i)-circle(i,3));%ʵ��Բ������x-����Բ������x
        fprintf(fid,'%15.6f ',trans_y(i)-circle(i,4));%ʵ��Բ������x-����Բ������x
        fprintf(fid,'\t%28.25f ',circle(i,21));%��λ��
        fprintf(fid,'\t%28.25f ',circle(i,22));%�߶Ƚ�
        fprintf(fid,'%15.6f ',R*circle(i,21));%R*��λ��
        fprintf(fid,'%15.6f ',R*circle(i,22));%R*�߶Ƚ�
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
