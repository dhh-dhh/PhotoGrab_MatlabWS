%%%%%%%%��xx��yy�ò�ͬ�����ֱ���һ�����Բ��(1:���������ֵ�����Բ��2�ȶ�ÿ����Ԫÿ�ֱַ����Բ���������mean)����д���ļ�

%  20170707 lzg start

newfile=strcat(dataDir,'\','canshu_',subDir,'.txt');
fid=fopen(newfile,'w');
for p=1:point_num
    nihe_x=mean_x(:,1,p);
    nihe_y=mean_y(:,1,p);
    [nihe_x00,nihe_y00,nihe_r00] = f_NiheCircle(nihe_x,nihe_y);
    nihe_x0(p)=nihe_x00;nihe_y0(p)=nihe_y00;nihe_r0(p)=nihe_r00;
    fprintf(fid,'%s   :    ',unit{p});			%��Ԫ���
    fprintf(fid,'%15.6f ',nihe_x0(p));				%meanֵ���Բ������
    fprintf(fid,'%15.6f ',nihe_y0(p));              %meanֵ���Բ������
    fprintf(fid,'%15.6f ',nihe_r0(p));				%meanֵ���Բ�İ뾶
    fprintf(fid,'%15.6f ',mean_x(1,1,p));		%��¼��λֵ
    fprintf(fid,'%15.6f ',mean_y(1,1,p));      %��¼��λֵ
    for q=1:paohe_turns
        nihe_x=xx(:,q,p);
        nihe_y=yy(:,q,p);
        [nihe_x00,nihe_y00,nihe_r00] = f_NiheCircle(nihe_x,nihe_y);
        nihe_x000(p)=nihe_x00;nihe_y000(p)=nihe_y00;nihe_r000(p)=nihe_r00;
        x0(q)=nihe_x000(p);
        y0(q)=nihe_y000(p);
        r0(q)=nihe_r000(p);
        fprintf(fid,'%15.6f ',x0(q));			%ÿ����ϵ�Բ�İ뾶
        fprintf(fid,'%15.6f ',y0(q));			%ÿ����ϵ�Բ�İ뾶
        fprintf(fid,'%15.6f ',r0(q));			%ÿ����ϵ�Բ�İ뾶
    end
    mean_x0=mean(x0);
    mean_y0=mean(y0);
    mean_r0=mean(r0);
    fprintf(fid,'%15.6f ',mean(x0));			%ÿ�����Բ�İ뾶��meanֵ
    fprintf(fid,'%15.6f ',mean(y0));			%ÿ�����Բ�İ뾶��meanֵ
    fprintf(fid,'%15.6f ',mean(r0));			%ÿ�����Բ�İ뾶��meanֵ
    fprintf(fid,'\r\n');
end
fclose(fid);

if axes=='cen'
    mean_x_cen(:,1)=mean_x(1,:,:);
    mean_y_cen(:,1)=mean_y(1,:,:);
    x0_cen=nihe_x0;
    y0_cen=nihe_y0;
    matfile=strcat(dataDir,'\','circle_',subDir,'.mat');
    save(matfile,'unit','x0_cen','y0_cen','mean_x_cen','mean_y_cen','circle','point_num');
elseif axes=='ecc'
    x0_ecc=nihe_x0;
    y0_ecc=nihe_y0;
    r0_ecc_nihe=nihe_r0;
    mean_x_ecc(:,1)=mean_x(1,:,:);
    mean_y_ecc(:,1)=mean_y(1,:,:);
    matfile=strcat(dataDir,'\','circle_',subDir,'.mat');
    save(matfile,'unit','x0_ecc','y0_ecc','r0_ecc_nihe','mean_x_ecc','mean_y_ecc');
end

