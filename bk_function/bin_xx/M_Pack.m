%%% �����㵽��TXT�ļ��������

%  2015_10_15   start
clear all;clc;clear maplemex; close all;
%%%%%%%%%%%�������ļ������ʼ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �������账�����������͹̶����ˣ���Ҫ�޸��ظ���������������й�����Ŀ����Ч��Ԫ��Ŀ���ܺϴ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataDir='..';                         %�ļ�Ŀ¼
subDir1='210929_191350_cen_6300';
subDir2='210929_192022_ecc_6300';
point_num=46;       %��Ч��Ԫ��Ŀ    %  only  P
light_num=46;       %�����й�����Ŀ  %  P Q
paohe_turns1=1;       %�ܺϴ���
paohe_turns2=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
repeat_times=1;     %�ظ��������
if_paohe=1;  %1���ܺ϶���  0����̬�ͷ���
image_pixel_h=6004;  %ccd ������
image_pixel_w=7920;  %ccd ������
fendu_times=11;     %�ֶȴ���
fendu_pluse=6300;     %�ֶ�����
pixel_um=100;        %ÿ�����൱�ڴ�Լ����΢�ף�����������

for choice=1:2
    if choice==1;  subDir=subDir1;paohe_turns=paohe_turns1; elseif choice==2; subDir=subDir2;paohe_turns=paohe_turns2; end
    all_x=zeros(repeat_times,fendu_times,paohe_turns,light_num);    %���ڱ���ÿ�������ֵ�ľ���(����������ܺϴ������ֶȴ������������
    all_y=zeros(repeat_times,fendu_times,paohe_turns,light_num);    %���ڱ���ÿ�������ֵ�ľ���
    all_mm = zeros(repeat_times,fendu_times,paohe_turns,light_num); %���ڱ���ÿ������Ҷ�ֵ��(����������ܺϴ������ֶȴ������������
    all_num = zeros(repeat_times,fendu_times,paohe_turns,light_num);%���ڱ���ÿ�����������(����������ܺϴ������ֶȴ������������
    all_cx = zeros(repeat_times,fendu_times,paohe_turns,light_num); %���ڱ���ÿ��ļ��������ֵ�ľ���(����������ܺϴ������ֶȴ������������
    all_cy = zeros(repeat_times,fendu_times,paohe_turns,light_num); %���ڱ���ÿ��ļ��������ֵ�ľ���(����������ܺϴ������ֶȴ������������
    all_lx = zeros(repeat_times,fendu_times,paohe_turns,light_num); %���ڱ���ÿ��ļ���ǰ����ֵ�ľ���(����������ܺϴ������ֶȴ������������
    all_ly = zeros(repeat_times,fendu_times,paohe_turns,light_num); %���ڱ���ÿ��ļ���ǰ����ֵ�ľ���(����������ܺϴ������ֶȴ������������
    
    oth_x=zeros(repeat_times,fendu_times,paohe_turns,light_num);    %���ڱ���ÿ�������ֵ�ľ���(����������ܺϴ������ֶȴ������������
    oth_y=zeros(repeat_times,fendu_times,paohe_turns,light_num);    %���ڱ���ÿ�������ֵ�ľ���
    oth_mm = zeros(repeat_times,fendu_times,paohe_turns,light_num); %���ڱ���ÿ������Ҷ�ֵ��(����������ܺϴ������ֶȴ������������
    oth_num = zeros(repeat_times,fendu_times,paohe_turns,light_num);%���ڱ���ÿ�����������(����������ܺϴ������ֶȴ������������
    oth_cx = zeros(repeat_times,fendu_times,paohe_turns,light_num); %���ڱ���ÿ��ļ��������ֵ�ľ���(����������ܺϴ������ֶȴ������������
    oth_cy = zeros(repeat_times,fendu_times,paohe_turns,light_num); %���ڱ���ÿ��ļ��������ֵ�ľ���(����������ܺϴ������ֶȴ������������
    other_num=0;
    %%%%%%%����Ԫ����
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
    %%%%%%%%%%%%%%%%%�������ļ���������
    for m=1:paohe_turns
        kk=kk+1;
        fprintf('%d/%d\n',kk,paohe_turns);
        for n=1:fendu_times
            for o=1:repeat_times
                if if_paohe==1
                    filename=sprintf('%s\\%s\\%s_%02d_%03d_%02d.txt',dataDir,subDir,subDir,m-1,n-1,o-1);
                else
                    filename=sprintf('%s\\%s\\%s_%02d_00.txt',dataDir,subDir,subDir,n-1);   %%%��̬�ȶ���
                end
                fid=fopen(filename,'r');
                if fid>0
                    for k=1:light_num
                        fscanf(fid,'%s',1);                      %������Ԫ����
                        all_x(o,n,m,k) = fscanf(fid,'%f',1);   %����x
                        all_y(o,n,m,k) = fscanf(fid,'%f',1);   %����y
                        all_mm(o,n,m,k) = fscanf(fid,'%f',1);  %���Ҷ�ֵ
                        all_num(o,n,m,k) = fscanf(fid,'%f',1); %���ص���
                        all_cx(o,n,m,k) = fscanf(fid,'%f',1);  %�����x
                        all_cy(o,n,m,k) = fscanf(fid,'%f',1);  %�����y
                        fgetl(fid);
                    end
                    k=0;
                    while  ~feof(fid)
                        k=k+1;
                        fscanf(fid,'%s',1);
                        oth_x(o,n,m,k) = fscanf(fid,'%f',1);  %����x
                        oth_y(o,n,m,k) = fscanf(fid,'%f',1);  %����y
                        oth_mm(o,n,m,k) = fscanf(fid,'%f',1); %���Ҷ�ֵ
                        oth_num(o,n,m,k) = fscanf(fid,'%f',1);%���ص���
                        oth_cx(o,n,m,k) = fscanf(fid,'%f',1); %�����x
                        oth_cy(o,n,m,k) = fscanf(fid,'%f',1); %�����y
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
    
    %��������ÿ��һȦ��ͼ
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
        msgbox('û���ҵ�WinRar��û�н����ļ����');
    else
%         buttonname=questdlg('�Ƿ�ɾ��ԭʼ�ļ���',...
%             '�ļ�����',...
%             'Yes','   ','No','Yes');
%         switch buttonname,
%             case 'Yes',
                ss=sprintf('del %s\\%s\\*.txt',dataDir,subDir);
                system(ss);
%             case 'No',
%                 msgbox('�ļ���������');
%             case 'Cancel',
%                 msgbox('�ļ���������');
%         end
    end
end
msgbox('�����ļ��������');
