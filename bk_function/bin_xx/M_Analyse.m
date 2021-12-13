%%% ���ݴ���

%  2017_06_14   lzg start

close all;clear all;clc;clear maplemex;

%%%%%%%%%%%��ʼ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataDir='..';                          %�ļ�Ŀ¼
subDir1='210929_191350_cen_6300';
subDir2='210929_192022_ecc_6300';
WatchPath='BadUnit_201777102154.txt';
if_CalcParam=2;         % 1 ɽ�϶���  2 Ԥ�ȶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


while  1
    bb=char('��ѡ��Ҫ���еĲ�����','0---�����ۺϼ���','11---��������תԲ����͡��� 21---ƫ������תԲ����� ','12---�������ظ���λ����         22---ƫ�����ظ���λ����','13---������궨���ߣ��գ�     23---ƫ����궨���ߣ��գ�',...
        '1---�������ۺϼ���                   2---ƫ�����ۺϼ���','3---���㵥Ԫ����                             4---���','7---ͼƬ�鿴                               8---�ظ�����ֱ��ͼ',...
        '9---�����ظ���궨����          10---ѡ��ͼƬ�鿴��ʽ');
    
    choice=inputdlg(bb);
    switch choice{1}
        case '11'
            subDir=subDir1; axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\Data_',subDir,'_p.mat'); load(matfile);
            m_NiheAll;
        case '12'
            subDir=subDir1; axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\','Data_',subDir,'_p.mat'); load(matfile);
            [error_x,error_y,error_xy] =f_FDError(xx,yy,'��ֵ�����С',unit,strcat(dataDir,'\',subDir,'\'));     % m_FDerror;
        case '13'
            subDir=subDir1; axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\','Data_',subDir,'_p.mat'); load(matfile);
            m_BD;
        case '21'
            subDir=subDir2;axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\Data_',subDir,'_p.mat'); load(matfile);
            m_NiheAll;
        case '22'
            subDir=subDir2; axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\','Data_',subDir,'_p.mat'); load(matfile);
            [error_x,error_y,error_xy] =f_FDError(xx,yy,'��ֵ�����С',unit,strcat(dataDir,'\',subDir,'\'));     % m_FDerror;
        case '23'
            subDir=subDir2; axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\','Data_',subDir,'_p.mat'); load(matfile);
            m_BD;
        case '0'
            for i=1:2
                if i==1;subDir=subDir1;else subDir=subDir2;end
                matfile=strcat(dataDir,'\Data_',subDir,'_p.mat'); load(matfile);
                m_NiheAll;
                [error_x,error_y,error_xy] =f_FDError(xx,yy,'��ֵ�����С',unit,strcat(dataDir,'\',subDir,'\'));     % m_FDerror;
                m_BD;
            end
            m_ChuShi;
        case '1'
            subDir=subDir1; axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\Data_',subDir,'_p.mat'); load(matfile);
            m_NiheAll;
            [error_x,error_y,error_xy] =f_FDError(xx,yy,'��ֵ�����С',unit,strcat(dataDir,'\',subDir,'\'));     % m_FDerror;
            m_BD;
        case '2'
            subDir=subDir2;axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\Data_',subDir,'_p.mat'); load(matfile);
            m_NiheAll;
            [error_x,error_y,error_xy] =f_FDError(xx,yy,'��ֵ�����С',unit,strcat(dataDir,'\',subDir,'\'));     % m_FDerror;
            m_BD;
        case '3'
            m_ChuShi;
        case '4'
            m_Check;
        case '7';
            matfile=strcat(dataDir,'\Data_',subDir1,'_p.mat'); load(matfile);
            i=0;
            while(i<size(unit,2))
                i=i+1;
                file_cen=dir(strcat('..\',subDir1,'\*',unit{i},'*.fig'));
                if size(file_cen,1)<2
                    fprintf('%s\n',unit{i});
                    %                         errordlg(strcat(unit{i},'The picture number of Cen is less than two'));
                end
                open(strcat('..\',subDir1,'\',file_cen(1).name));    set(gcf,'position',[200,500,600,350]);title(unit{i});
                open(strcat('..\',subDir1,'\',file_cen(2).name));    set(gcf,'position',[820,500,600,350]);title(unit{i});
                if size(file_cen,1)>2
                    for k=3:size(file_cen,1)
                        open(strcat('..\',subDir1,'\',file_cen(k).name));
                    end
                end
                
                file_ecc=dir(strcat('..\',subDir2,'\*',unit{i},'*.fig'));
                if size(file_cen,1)<2
                    fprintf('%s\n',unit{i});
                    %                         errordlg(strcat(unit{i},'The picture number of Cen is less than two'));
                end
                open(strcat('..\',subDir2,'\',file_ecc(1).name));    set(gcf,'position',[200,50,600,350]);title(unit{i});
                open(strcat('..\',subDir2,'\',file_ecc(2).name));    set(gcf,'position',[820,50,600,350]);title(unit{i});
                if size(file_ecc,1)>2
                    for k=3:size(file_ecc,1)
                        open(strcat('..\',subDir2,'\',file_ecc(k).name));
                    end
                end
                
                k = menu('If the cell is OK?  ','Good','Ecc','Cen','All','Bad','Back','Exit');
                if k==1
                    fid=fopen(strcat(dataDir,'\GoodUnit.txt'),'a+');
                    fprintf(fid,'%s\n',unit{i});
                    fclose(fid);
                elseif k==2
                    Ecc='Ecc';
                    fid=fopen(strcat(dataDir,'\BadUnit.txt'),'a+');
                    fprintf(fid,'%s %s\n',unit{i},Ecc);
                    fclose(fid);
                elseif k==3
                    Cen='Cen';
                    fid=fopen(strcat(dataDir,'\BadUnit.txt'),'a+');
                    fprintf(fid,'%s %s\n',unit{i},Cen);
                    fclose(fid);
                elseif k==4
                    All='All';
                    fid=fopen(strcat(dataDir,'\BadUnit.txt'),'a+');
                    fprintf(fid,'%s %s\n',unit{i},All);
                    fclose(fid);
                elseif k==5
                    All='Bad';
                    fid=fopen(strcat(dataDir,'\BadUnit.txt'),'a+');
                    fprintf(fid,'%s %s\n',unit{i},All);
                    fclose(fid);
                elseif k==6
                    i=i-2;
                elseif k==7
                    break;
                end
                close all
            end
            
        case '10';
            if exist(strcat(dataDir,'\BadUnit.txt'),'file')
                string=strcat('�Ƿ�BadUnit.txt������ΪBadUnit_old.txt' );
                choice = questdlg(string,'Choice Menu','Yes','No','Yes');
                if strcmp(choice,'Yes')
                    system('copy ..\BadUnit.txt ..\BadUnit_old.txt');
                end
            end
            if exist(strcat(dataDir,'\BadUnit_old.txt'),'file')
                choice = menu('ѡ��鿴��ʽ  ','ֻ��ʾBadUnit_old�е�Ԫ','ֻ��ʾ����BadUnit_old�е�Ԫ','��ʾ���е�Ԫ');
            else
                choice=3;
            end
            ss=strcat('del ',dataDir,'\BadUnit.txt');
            system(ss);
            matfile=strcat(dataDir,'\Data_',subDir1,'_p.mat'); load(matfile);
            fid=fopen(strcat(dataDir,'\BadUnit_old.txt'));
            m=1;
            while ~feof(fid)
                temp=fscanf(fid,'%s',1);
                if ~isempty(temp)
                    BadName{m}=temp;
                    m=m+1;
                end
                fgetl(fid);
            end
            fclose(fid);
            
            if choice==1 || choice==2
                for n=1:size(unit,2)
                    flag=0;
                    for j=1:size(BadName,2)
                        if strcmp(unit{n},BadName{j})
                            flag=1;break;
                        end
                    end
                    if flag &&  choice==1 || ~flag &&  choice==2
                        i=n;
                        s_CheckUnit;
                    end
                end
            end
            
            if choice==3
                for i=1:size(unit,2)
                    s_CheckUnit;
                end
            end
        case '8';
            subDir=subDir1;
            matfile=strcat(dataDir,'\Data_',subDir,'_p.mat'); load(matfile);
            xx1=xx;yy1=yy;
            subDir=subDir2;
            matfile=strcat(dataDir,'\Data_',subDir,'_p.mat'); load(matfile);
            xx2=xx;yy2=yy;
            [hist_data,std_xy] =f_FDError1(xx1,yy1,xx2,yy2,unit,'ֱ��ͼ');
    
            
            %m_NiheAll;
        case '9';
            subDir=subDir1; axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\','Data_',subDir,'_p.mat'); load(matfile);
            [error_x,error_y,error_xy] =f_FDError(xx,yy,'��ֵ�����С',unit,strcat(dataDir,'\',subDir,'\'));     % m_FDerror;
            m_BD;
            subDir=subDir2; axes = subDir(end-6:end-4);
            matfile=strcat(dataDir,'\','Data_',subDir,'_p.mat'); load(matfile);
            [error_x,error_y,error_xy] =f_FDError(xx,yy,'��ֵ�����С',unit,strcat(dataDir,'\',subDir,'\'));     % m_FDerror;
            m_BD;
        case '11';
            % s_Repeatance ;                     %startpoint; %%%%%%%%%��̬�ȶ���
            mytitle='�������';
            pathname='C:\Users\bj\Desktop\';
            unit='E1';
            R_xx=reshape(xx,[1,size(xx,1),size(xx,3)]);
            R_yy=reshape(yy,[1,size(yy,1),size(yy,3)]);
            [error_x,error_y,error_xy] =f_FDError(R_xx,R_yy,mytitle,unit,pathname);
            %         case 'B'
            %
            %             m_bdt;
            %         case 'C';
            %            %%%%%
            %         case 'D';
            %             nihe_lwm_1;
        case '12';
            m_PlotAll;
            banjing_plot=0;
            banjing;
        case '13';
            banjing_plot=1;
            banjing;
        case '0';
            key=0;
            break;
        otherwise
            %             f_plotunit(xx,yy,choice{1},unit)
            break;
            
    end
end