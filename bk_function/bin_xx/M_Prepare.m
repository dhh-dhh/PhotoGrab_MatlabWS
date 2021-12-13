clear all;clc;clear maplemex;

addpath('includ_func');
% �Լ�����Ĺ���������ݽ��д���
%  1.���Բ�İ뾶    2.�����ظ���λ����    3.����궨����    4.����ֶ��������

canshu_fn='canshu3d_init.txt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataDir='..';                          %�ļ�Ŀ¼
subDir_cen='210929_191350_cen_6300';
subDir_ecc='210929_192022_ecc_6300';

if_CalcParam=2;          % 1 ɽ�϶���  2 Ԥ�ȶ��� 3  ʹ�������������ϵ��  4 ʹ��΢������

param_2_fn='param.mat';                  % if_CalcParam=2
param_3_x=300;param_3_y=300;   % if_CalcParam=3
biaoding=30;
r_min=6000/100;                                     %�뾶����Χ�������жϵ�Ԫ�Ƿ�����
r_max=9000/100;                                     % 300 2k������, 220Ϊ4k�����룬250 2kС���棬 500 Զ����
xTwo=[];yTwo=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:2
    if i==1;subDir=subDir_cen;else subDir=subDir_ecc;end
    axes=subDir(end-7:end-5);
    matfile = strcat(dataDir,'\Data_',subDir,'.mat');
    if exist(matfile,'file')~=2,msgbox('û�ҵ������ļ�');return;end
    load(matfile);
    
    %%%%%%%%%%EEEEEEEEEEEEEEEEEEEE%%%%%%%%%����Ҫ�޸ĵĵ�Ԫ���д���%%%%%%%%%%EEEEEEEEEEEEEEEEEEEEEEEE%%%%%%%%%%%%%%
    if i==1
         all_x=all_x(:,:,:,:);
         all_y=all_y(:,:,:,:);
         solid_x=all_x(:,:,:,[]);
         solid_y=all_y(:,:,:,[]);
         
%          alarm_unit= {'PG0808',[2,3,4];};
%          alarm_unit2 ={};
%          alarm_unit3 ={'PG1508',[196:197];};
         alarm_unit= {};
         alarm_unit2 ={};
         alarm_unit3 ={};

    else
         all_x=all_x(:,:,:,:);
         all_y=all_y(:,:,:,:);
         solid_x=all_x(:,:,:,[]);
         solid_y=all_y(:,:,:,[]);
         
%          alarm_unit= {'PG0402',[5,4];};
%          alarm_unit2 ={};
%          alarm_unit3 ={};
         alarm_unit= {};
         alarm_unit2 ={};
         alarm_unit3 ={};
    end
   % s_Pre_HandleData;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    paohe_turns=size(all_x,3);
    s_Pre_solid;       % all_xy(repeat_times,fendu_times,paohe_turns,light_num) ==> xy(fendu_times,paohe_turns,light_num)
    figure(1);
    figure_name=strcat(dataDir,'\Plot_',subDir,'.jpg');
    f_PlotAll(xx,yy,'�����ͼ',figure_name);
    xTwo=[xTwo,xx];yTwo=[yTwo,yy];
    s_CalcParam;
    % s_Pre_solid;      % all_xy(repeat_times,fendu_times,paohe_turns,light_num) ==> xy(fendu_times,paohe_turns,light_num)
    s_Pre_Xuanzhuan;    % xy(fendu_times,paohe_turns,light_num) ==>  xy(fendu_times,1,paohe_turns,light_num)ת����С����ϵ��
    s_Pre_mean;         % xy(fendu_times,paohe_turns,light_num) ==>  mean_xy(fendu_times,1,paohe_turns,light_num)
    figure(2);f_PlotAll(xx,yy,'С����ϵ');
    matfile=strcat(dataDir,'\Data_',subDir,'_p.mat');
    save(matfile,'mean_x','mean_y','xx','yy','unit','fendu_times','paohe_turns','point_num','axes','circle');
end
figure_name=strcat(dataDir,'\Plot_AllTwo.jpg');
f_PlotAll(xTwo,yTwo,'����',figure_name);
msgbox('���');
