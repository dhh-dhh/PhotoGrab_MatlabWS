%%% 将拍摄到的TXT文件打包整合

%  2015_10_15   start
clear all;clc;clear maplemex; close all;
%%%%%%%%%%%从配置文件载入初始参数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 设置所需处理数据轮数和固定光纤，需要修改重复拍摄次数、读所有光纤数目、有效单元数目、跑合次数%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataDir='..';                         %文件目录
subDir1='210929_191350_cen_6300';
subDir2='210929_192022_ecc_6300';
point_num=46;       %有效单元数目    %  only  P
light_num=46;       %读所有光纤数目  %  P Q
paohe_turns1=1;       %跑合次数
paohe_turns2=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
repeat_times=1;     %重复拍摄次数
if_paohe=1;  %1：跑合定标  0：静态和仿真
image_pixel_h=6004;  %ccd 像素数
image_pixel_w=7920;  %ccd 像素数
fendu_times=11;     %分度次数
fendu_pluse=6300;     %分度脉冲
pixel_um=100;        %每像素相当于大约多少微米！！！！！！

for choice=1:2
    if choice==1;  subDir=subDir1;paohe_turns=paohe_turns1; elseif choice==2; subDir=subDir2;paohe_turns=paohe_turns2; end
    all_x=zeros(repeat_times,fendu_times,paohe_turns,light_num);    %用于保存每点的行列值的矩阵，(拍摄次数，跑合次数，分度次数，光点数）
    all_y=zeros(repeat_times,fendu_times,paohe_turns,light_num);    %用于保存每点的行列值的矩阵
    all_mm = zeros(repeat_times,fendu_times,paohe_turns,light_num); %用于保存每点的最大灰度值，(拍摄次数，跑合次数，分度次数，光点数）
    all_num = zeros(repeat_times,fendu_times,paohe_turns,light_num);%用于保存每点的像素数，(拍摄次数，跑合次数，分度次数，光点数）
    all_cx = zeros(repeat_times,fendu_times,paohe_turns,light_num); %用于保存每点的计算后行列值的矩阵，(拍摄次数，跑合次数，分度次数，光点数）
    all_cy = zeros(repeat_times,fendu_times,paohe_turns,light_num); %用于保存每点的计算后行列值的矩阵，(拍摄次数，跑合次数，分度次数，光点数）
    all_lx = zeros(repeat_times,fendu_times,paohe_turns,light_num); %用于保存每点的计算前行列值的矩阵，(拍摄次数，跑合次数，分度次数，光点数）
    all_ly = zeros(repeat_times,fendu_times,paohe_turns,light_num); %用于保存每点的计算前行列值的矩阵，(拍摄次数，跑合次数，分度次数，光点数）
    
    oth_x=zeros(repeat_times,fendu_times,paohe_turns,light_num);    %用于保存每点的行列值的矩阵，(拍摄次数，跑合次数，分度次数，光点数）
    oth_y=zeros(repeat_times,fendu_times,paohe_turns,light_num);    %用于保存每点的行列值的矩阵
    oth_mm = zeros(repeat_times,fendu_times,paohe_turns,light_num); %用于保存每点的最大灰度值，(拍摄次数，跑合次数，分度次数，光点数）
    oth_num = zeros(repeat_times,fendu_times,paohe_turns,light_num);%用于保存每点的像素数，(拍摄次数，跑合次数，分度次数，光点数）
    oth_cx = zeros(repeat_times,fendu_times,paohe_turns,light_num); %用于保存每点的计算后行列值的矩阵，(拍摄次数，跑合次数，分度次数，光点数）
    oth_cy = zeros(repeat_times,fendu_times,paohe_turns,light_num); %用于保存每点的计算后行列值的矩阵，(拍摄次数，跑合次数，分度次数，光点数）
    other_num=0;
    %%%%%%%读单元名称
    if if_paohe==1
        filename_unit=strcat(dataDir,'\',subDir,'\',subDir,'_00_000_00.txt');
    else
        filename_unit=strcat(dataDir,'\',subDir,'\',subDir,'_00_00.txt');
    end
    fid=fopen(filename_unit,'rt');
    for m=1:light_num
        unit{m}=fscanf(fid,'%s',1);
        fgetl(fid);
    end
    fclose(fid);
    
    kk=0;
    %%%%%%%%%%%%%%%%%从坐标文件读入数据
    for m=1:paohe_turns
        kk=kk+1;
        fprintf('%d/%d\n',kk,paohe_turns);
        for n=1:fendu_times
            for o=1:repeat_times
                if if_paohe==1
                    filename=sprintf('%s\\%s\\%s_%02d_%03d_%02d.txt',dataDir,subDir,subDir,m-1,n-1,o-1);
                else
                    filename=sprintf('%s\\%s\\%s_%02d_00.txt',dataDir,subDir,subDir,n-1);   %%%静态稳定性
                end
                fid=fopen(filename,'r');
                if fid>0
                    for k=1:light_num
                        fscanf(fid,'%s',1);                      %跳过单元名称
                        all_x(o,n,m,k) = fscanf(fid,'%f',1);   %像素x
                        all_y(o,n,m,k) = fscanf(fid,'%f',1);   %像素y
                        all_mm(o,n,m,k) = fscanf(fid,'%f',1);  %最大灰度值
                        all_num(o,n,m,k) = fscanf(fid,'%f',1); %像素点数
                        all_cx(o,n,m,k) = fscanf(fid,'%f',1);  %计算后x
                        all_cy(o,n,m,k) = fscanf(fid,'%f',1);  %计算后y
                        fgetl(fid);
                    end
                    k=0;
                    while  ~feof(fid)
                        k=k+1;
                        fscanf(fid,'%s',1);
                        oth_x(o,n,m,k) = fscanf(fid,'%f',1);  %像素x
                        oth_y(o,n,m,k) = fscanf(fid,'%f',1);  %像素y
                        oth_mm(o,n,m,k) = fscanf(fid,'%f',1); %最大灰度值
                        oth_num(o,n,m,k) = fscanf(fid,'%f',1);%像素点数
                        oth_cx(o,n,m,k) = fscanf(fid,'%f',1); %计算后x
                        oth_cy(o,n,m,k) = fscanf(fid,'%f',1); %计算后y
                        fgetl(fid);
                    end
                    fclose(fid);
                    if k>other_num;other_num=k;end
                else
                    disp(filename);
                end
            end
        end
    end
    oth_x=oth_x(:,:,:,1:other_num);
    oth_y=oth_y(:,:,:,1:other_num);
    oth_mm=oth_mm(:,:,:,1:other_num);
    oth_num=oth_num(:,:,:,1:other_num);
    oth_cx=oth_cx(:,:,:,1:other_num);
    
    %画出各点每走一圈的图
    figure(1)
    for k=1:light_num
        for j=1:paohe_turns
            for i=1:repeat_times
                line(all_x(i,:,j,k),all_y(i,:,j,k));
            end
        end
    end
    set(gcf,'position',[200,200,450,400]);
    figure(2)
    for k=1:other_num
        for j=1:paohe_turns
            for i=1:repeat_times
                line(oth_x(i,:,j,k),oth_y(i,:,j,k));
            end
        end
    end
    set(gcf,'position',[700,200,450,400]);
    
    matfile=strcat(dataDir,'\Data_',subDir,'.mat');
    save(matfile, 'all_x','all_y','all_mm','all_num','all_cx','all_cy','all_lx','all_ly','oth_x','oth_y','oth_mm','oth_num','oth_cx','oth_cy',...
        'unit','fendu_times','paohe_turns','repeat_times','light_num','point_num','image_pixel_h','image_pixel_w','pixel_um','fendu_pluse','other_num');
    ss=sprintf('C:\\WinRAR\\WinRAR.exe a -ag %s\\%s\\rar %s\\%s\\*.txt',dataDir,subDir,dataDir,subDir);
    ss=system(ss);
    if ss>0 %then
        msgbox('没有找到WinRar，没有进行文件打包');
    else
%         buttonname=questdlg('是否删除原始文件？',...
%             '文件处理',...
%             'Yes','   ','No','Yes');
%         switch buttonname,
%             case 'Yes',
                ss=sprintf('del %s\\%s\\*.txt',dataDir,subDir);
                system(ss);
%             case 'No',
%                 msgbox('文件不做处理！');
%             case 'Cancel',
%                 msgbox('文件不做处理！');
%         end
    end
end
msgbox('坐标文件读入完成');
