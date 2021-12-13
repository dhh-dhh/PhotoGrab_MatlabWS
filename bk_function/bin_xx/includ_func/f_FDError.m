function  [error_x,error_y,error_xy,mean_value,std_value,count_num,badname] =f_FDError(xx,yy,mytitle,unit,pathname)
%function  [error_x,error_y,error_xy] =f_FDError(xx,yy,mytitle,unit,pathname)
%�����㣬��x,y����ƽ��ֵ֮���ֵx,y�ľ��������ͼ�Ρ�����ͼ�κ����ݣ����ͳ�ơ��������������ͬ����ʽ��ͬ
%   �������<4ʱ �������error_x,error_y,error_xy
%   �������=4ʱ �����error_x,error_y,error_xy��ͬʱ��ͼ
%   �������>4ʱ �����error_x,error_y,error_xy����ͼ��ͳ�Ʋ�����
%Input:
%   xx:          ����x����
%	yy:          ����y����
%	mytitle��         �����������
%	unit:          ���ͼƬ��
%	pathname��         ����ͼƬ��ͳ�����ݵ�·����ַ
%Output:
%   error_x��         x����ƽ��ֵ�Ĳ�ֵ��С
%	error_y��         y����ƽ��ֵ�Ĳ�ֵ��С
%	error_xy��        error_x��error_y�ľ�����

%  20170707 lzg start

pointNum =size(xx,3) ;
mx=mean(xx,2);
my=mean(yy,2);

f_draw = 0;
f_save = 0;
if nargin < 2
    errordlg('ȱ���������');
    return;
end
if nargin >= 4                        %�������=4ʱ �����error_x,error_y,error_xy��ͬʱ��ͼ
    f_draw=1;
end
if nargin >= 5                            %�������>4ʱ �����error_x,error_y,error_xy����ͼ��ͳ�Ʋ�����
    f_save=1;
end

if f_save == 1
    newfile=strcat(pathname,'_FDerror.html');
    fid=fopen(newfile,'wt');
    fprintf(fid,'<html>\r\n<head>\r\n<meta http-equiv=Content-Type content="text/html; charset=gb2312">\r\n</head>\r\n<body>\r\n');
    fprintf(fid,'�ظ���λ����ͳ�ƽ��\r\n');
    fprintf(fid,'<table border=2  width=900>\r\n');
    fprintf(fid,'<tr height=19>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>��Ԫ��</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>��׼��_xy</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>��ֵ_xy</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>sigma2_xy(��)</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>��׼��_x</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>��ֵ_x</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>sigma2_x(��)</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>��׼��_y</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>��ֵ_y</td>\r\n');
    fprintf(fid,'<td  width=100 height=19 align=middle>sigma2_y(��)</td>\r\n');
    fprintf(fid,'</tr>\r\n');
end

count_num=zeros(1,15);w=0;
error_x=[];
error_y=[];
for p=1:pointNum
    xx1=xx(:,:,p);
    yy1=yy(:,:,p);
    average_x=mx(:,1,p);
    average_y=my(:,1,p);
    for q=1:size(xx1,2)
        error_x(:,q)=xx1(:,q)-average_x;
        error_y(:,q)=yy1(:,q)-average_y;
    end
    %   error_x=(abs(error_x)<500).*error_x+(abs(error_x)>=500).*500;
    %   error_y=(abs(error_y)<500).*error_y+(abs(error_y)>=500).*500;
    error_xy=sqrt(error_x.*error_x+error_y.*error_y);
    
    if f_save == 1
        s=size(xx,2)*size(xx,1);
        mean_error_xy=mean(abs(error_xy(:)));
        mean_error_x=mean(abs(error_x(:)));
        mean_error_y=mean(abs(error_y(:)));
        std_xy=sqrt(sum(error_xy(:).*error_xy(:))/size(error_xy(:),1));
        std_x=sqrt(sum(error_x(:).*error_x(:))/size(error_x(:),1));
        std_y=sqrt(sum(error_y(:).*error_y(:))/size(error_y(:),1));
    end
    
    if std_xy<=14
        count_index=floor(std_xy);
        count_num(count_index+1)=count_num(count_index+1)+1;
    else
        count_num(15)=count_num(15)+1;
        w=w+1;
        badname{w,1}=unit{p};
        badname{w,2}=p;
    end
    
    if f_draw == 1
        std_xy=sqrt(sum(error_xy(:).*error_xy(:))/size(error_xy(:),1));
        titlxy=strcat(mytitle,'��������','(��=',num2str(std_xy),')' );
        title_x=strcat('���������');
        title_y=strcat('���������');
        figure(99)
        subplot(2,1,1)
        plot(error_xy(:,:));
        xlabel('�ֶȵ�');
        ylabel('���');
        set(gca,'FontSize',15);%%gca��ȡ��ǰͼ��������ǰͼ�������С����Ϊ15
        title(titlxy);
        
        subplot(2,2,3)
        plot(error_x(:,:));
        xlabel('�ֶȵ�');
        ylabel('���');
        set(gca,'FontSize',15);
        title(title_x);
        
        subplot(2,2,4)
        plot(error_y(:,:));
        xlabel('�ֶȵ�');
        ylabel('���');
        set(gca,'FontSize',15);
        title(title_y);
        
        if  f_save==1
            if isempty(unit)
                figurename=strcat(pathname,'��Ԫ','.jpg');
            else
                figurename=strcat(pathname,unit{p},'��=',num2str(std_xy),'.jpg');
                %                figurename=strcat(pathname,unit{p},'.jpg');
            end
            saveas(gcf,figurename);
            if isempty(unit)
                figurename=strcat(pathname,'��Ԫ','.fig');
            else
                figurename=strcat(pathname,unit{p},'.fig');
                %                figurename=strcat(pathname,unit{p},'.jpg');
            end
            saveas(gcf,figurename);
        end
        
        if f_save == 1
            sigma_x=0;
            sigma_y=0;
            sigma_xy=0;
            for c=1:s
                if abs(error_x(c))>std_x*2,sigma_x=sigma_x+1;end
                if abs(error_y(c))>std_y*2,sigma_y=sigma_y+1;end
                if error_x(c).*error_x(c)+error_y(c).*error_y(c)>std_xy.*std_xy*4,sigma_xy=sigma_xy+1;end
            end
            pecent_sigma_x=sigma_x/s*100;
            pecent_sigma_y=sigma_y/s*100;
            pecent_sigma_xy=sigma_xy/s*100;
            fprintf(fid,'<tr height=19>\r\n');
            fprintf(fid,'<td  width=100 height=19 align=middle>%s</td>\r\n',unit{p});
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',std_xy);
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',mean_error_xy);
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',pecent_sigma_xy);
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',std_x);
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',mean_error_x);
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',pecent_sigma_x);
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',std_y);
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',mean_error_y);
            fprintf(fid,'<td  width=100 height=19 align=middle>%.4f</td>\r\n',pecent_sigma_y);
            fprintf(fid,'</tr>\r\n');
        end
    end
end
fclose(fid);
mean_value=[mean(error_x(:)),mean(error_y(:)),mean(error_xy(:))]
std_value=[sqrt(sum(error_x(:).*error_x(:)/size(error_x(:),1))),
    sqrt(sum(error_y(:).*error_y(:)/size(error_y(:),1))),
    sqrt(sum(error_xy(:).*error_xy(:)/size(error_xy(:),1)))]
end


% function test()
% fn = '..\testdata\f_FDError.mat';
% fn1='..\testdata\f_FDError.jpg';
% load(fn);
% [error_x,error_y,error_xy,mean_value,std_value] =FDError(xx,yy,'��ֵ�����С',unit,fn1);
