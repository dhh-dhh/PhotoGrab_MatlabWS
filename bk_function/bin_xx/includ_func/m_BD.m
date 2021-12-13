%%生成标定文件，绘制标定曲线图，并保存.

%  20170707 lzg start

subplot(1,1,1);
for p=1:point_num   %%%%%%%%分单元循环
    nihe_x=mean_x(:,1,p);
    nihe_y=mean_y(:,1,p); 
    [nihe_x00,nihe_y00,nihe_r00] = f_NiheCircle(nihe_x,nihe_y);
    nihe_x0(p)=nihe_x00;nihe_y0(p)=nihe_y00;nihe_r0(p)=nihe_r00;     %nihe_x0(p),nihe_y0(p),nihe_r0
   
    %%%%%%%%%%%%%%%%%%%%先算mean角度
    temp1=0;
    temp2=0;
    count=0;
    %angle11(1)=0; angle12(1)=0;
    %total_angle11(1)=0; total_angle12(1)=0;
    %direct_angle11(1)=0; direct_angle12(1)=0;
    for f=1:fendu_times-1
        la0=sqrt((nihe_x(1)-nihe_x0(p))^2+(nihe_y(1)-nihe_y0(p))^2);
        la=sqrt((nihe_x(f)-nihe_x0(p))^2+(nihe_y(f)-nihe_y0(p))^2);
        lb=sqrt((nihe_x(f+1)-nihe_x0(p))^2+(nihe_y(f+1)-nihe_y0(p))^2);
        lc=sqrt((nihe_x(f)-nihe_x(f+1))^2+(nihe_y(f)-nihe_y(f+1))^2);
        lc0=sqrt((nihe_x(f+1)-nihe_x(1))^2+(nihe_y(f+1)-nihe_y(1))^2);
        s=0.5*(la+lb+lc);
        s0=0.5*(lb+la0+lc0);
    
        angle11(f)=2*asin(sqrt((s-la)*(s-lb)/(la*lb)))*10000;
        angle12(f)=2*asin(sqrt((s-la)*(s-lb)/(la*lb)))*180/pi;
        
        y2=((nihe_y(1)-nihe_y0(p))/(nihe_x(1)-nihe_x0(p)))*(nihe_x(f+1)-nihe_x0(p))+nihe_y0(p);
        if y2>=nihe_y(f+1)
            direct_angle11(f)=2*pi*10000-2*asin(sqrt((s0-lb)*(s0-la0)/(lb*la0)))*10000;
            direct_angle12(f)=360-2*asin(sqrt((s0-lb)*(s0-la0)/(lb*la0)))*180/pi;
        else
            direct_angle11(f)=2*asin(sqrt((s0-lb)*(s0-la0)/(lb*la0)))*10000;
            direct_angle12(f)=2*asin(sqrt((s0-lb)*(s0-la0)/(lb*la0)))*180/pi;
        end
        
        total_angle11(f)=angle11(f)+temp1;
        temp1=total_angle11(f);
        total_angle12(f)=angle12(f)+temp2;
        temp2=total_angle12(f);
        if total_angle12(f)<2.0
            count=f;
        end
    end
    if count>=size(angle12),count=0;end
    min_angle(p)=min(angle12(count+1:end));
    max_angle(p)=max(angle12(count+1:end));
    total(p)=total_angle12(end);
    total_direct(p)=direct_angle12(end);
    %%%%%%%%%%%%每轮跑合算角度
    for q=1:paohe_turns
        nihe_x=xx(:,q,p);
        nihe_y=yy(:,q,p);
        [nihe_x00,nihe_y00,nihe_r00] = f_NiheCircle(nihe_x,nihe_y);
        nihe_x0(p)=nihe_x00;nihe_y0(p)=nihe_y00;nihe_r0(p)=nihe_r00;    %nihe_x0(p),nihe_y0(p),nihe_r0

        total_delta_angle2=zeros(1,fendu_times-1);
        temp1=0;
        temp2=0;
     %   angle21(1,q)=0; angle22(1,q)=0;total_angle21(1,q)=0; total_angle22(1,q)=0; direct_angle21(1,q)=0; direct_angle22(1,q)=0;
        for f=1:fendu_times-1
            la=sqrt((nihe_x(f)-nihe_x0(p))^2+(nihe_y(f)-nihe_y0(p))^2);
            lb=sqrt((nihe_x(f+1)-nihe_x0(p))^2+(nihe_y(f+1)-nihe_y0(p))^2);
            lc=sqrt((nihe_x(f)-nihe_x(f+1))^2+(nihe_y(f)-nihe_y(f+1))^2);
            s=0.5*(la+lb+lc);
            angle21(f,q)=2*asin(sqrt((s-la)*(s-lb)/(la*lb)))*1000;
            angle22(f,q)=2*asin(sqrt((s-la)*(s-lb)/(la*lb)))*180/pi;
            
            total_angle21(f,q)=angle21(f,q)+temp1;
            temp1=total_angle21(f,q);
            total_angle22(f,q)=angle22(f,q)+temp2;
            temp2=total_angle22(f,q);
        end
          
        plot(angle22(:,q),'k-.');
         set(gca,'FontSize',15);
        hold on;
    end
    %%%%%%%%%%%%%%%计算每轮跑合后角度再平均
    mean_angle21=mean(angle21,2);
    mean_angle22=mean(angle22,2);
    mean_total_angle21=mean(total_angle21,2);
    mean_total_angle22=mean(total_angle22,2);
    
    plot(mean_angle22,'b-d');
    hold on;
    plot(angle12,'r-s');
    hold off;
    figure=strcat(dataDir,'\',subDir,'\','tbiaoding_',subDir,'_',unit{p},'.jpg');
    saveas(gcf,figure);
    figure=strcat(dataDir,'\',subDir,'\','tbiaoding_',subDir,'_',unit{p},'.fig');
    saveas(gcf,figure);
    %%%%%%%%%%%%%写标定文件
    newfile=strcat(dataDir,'\',subDir,'\','biaoding_',axes,'_',subDir,'_',unit{p},'.txt');
    fid=fopen(newfile,'w');
    for f=1:fendu_times-1
        fprintf(fid,'%15.6f  ',total_angle11(f));
        fprintf(fid,'%15.6f  ',direct_angle11(f));
        fprintf(fid,'%15.6f  ',angle11(f));
        fprintf(fid,'%15.6f  ',total_angle12(f));
        fprintf(fid,'%15.6f  ',direct_angle12(f));
        fprintf(fid,'%15.6f  ',angle12(f));
        
        fprintf(fid,'%15.6f  ',mean_total_angle21(f));
        fprintf(fid,'%15.6f  ',mean_angle21(f));
        fprintf(fid,'%15.6f  ',mean_total_angle22(f));
        fprintf(fid,'%15.6f  ',mean_angle22(f));
        for q=1:paohe_turns
            fprintf(fid,'%15.6f  ',total_angle21(f,q));
            fprintf(fid,'%15.6f  ',angle21(f,q));
            fprintf(fid,'%15.6f  ',total_angle22(f,q));
            fprintf(fid,'%15.6f  ',angle22(f,q));
        end
        fprintf(fid,'\r\n',angle22(f,q));
    end
    fclose(fid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%生成html统计文件
newfile=strcat(dataDir,'\',subDir,'\','_biaoding.html');
fid=fopen(newfile,'w');
fprintf(fid,'<html>\r\n');
fprintf(fid,'<head>\r\n');
fprintf(fid,'<meta http-equiv=Content-Type content="text/html; charset=gb2312">\r\n');
fprintf(fid,'</head>\r\n');
fprintf(fid,'<body>\r\n');
fprintf(fid,'标定分度统计结果\r\n');
fprintf(fid,'<table border=2  width=900>\r\n');

fprintf(fid,'<tr height=19>\r\n');
fprintf(fid,'<td  width=70 height=19 align=middle>单元号</td>\r\n');
fprintf(fid,'<td  width=70 height=19 align=middle>每步最小角度_x</td>\r\n');
fprintf(fid,'<td  width=70 height=19 align=middle>每步最大角度</td>\r\n');
fprintf(fid,'<td  width=70 height=19 align=middle>终点角度</td>\r\n');
fprintf(fid,'<td  width=70 height=19 align=middle>终点角度差</td>\r\n');
fprintf(fid,'</tr>\r\n');

for p=1:point_num
    fprintf(fid,'<tr height=19>\r\n');
    fprintf(fid,'<td  width=70 height=19 align=middle>%s</td>\r\n',unit{p});
    fprintf(fid,'<td  width=70 height=19 align=middle>%.4f</td>\r\n',min_angle(p));
    fprintf(fid,'<td  width=70 height=19 align=middle>%.4f</td>\r\n',max_angle(p));
    fprintf(fid,'<td  width=70 height=19 align=middle>%.4f</td>\r\n',total(p));
    fprintf(fid,'<td  width=70 height=19 align=middle>%.4f</td>\r\n',abs(total(p)-total_direct(p)));
    fprintf(fid,'</tr>\r\n');
end
fclose(fid);
