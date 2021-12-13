clear all;clc;clear maplemex;

addpath('includ_func');
% 对计算出的光点坐标数据进行处理
%  1.拟和圆心半径    2.计算重复定位精度    3.计算标定曲线    4.计算分度误差曲线

canshu_fn='canshu3d_init.txt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataDir='..';                          %文件目录
subDir_cen='210929_191350_cen_6300';
subDir_ecc='210929_192022_ecc_6300';

if_CalcParam=2;          % 1 山上定标  2 预先定标 3  使用像素坐标乘以系数  4 使用微米坐标

param_2_fn='param.mat';                  % if_CalcParam=2
param_3_x=300;param_3_y=300;   % if_CalcParam=3
biaoding=30;
r_min=6000/100;                                     %半径允许范围，用于判断单元是否正常
r_max=9000/100;                                     % 300 2k近距离, 220为4k近距离，250 2k小焦面， 500 远距离
xTwo=[];yTwo=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:2
    if i==1;subDir=subDir_cen;else subDir=subDir_ecc;end
    axes=subDir(end-7:end-5);
    matfile = strcat(dataDir,'\Data_',subDir,'.mat');
    if exist(matfile,'file')~=2,msgbox('没找到坐标文件');return;end
    load(matfile);
    
    %%%%%%%%%%EEEEEEEEEEEEEEEEEEEE%%%%%%%%%对需要修改的单元进行处理%%%%%%%%%%EEEEEEEEEEEEEEEEEEEEEEEE%%%%%%%%%%%%%%
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
    f_PlotAll(xx,yy,'像面绘图',figure_name);
    xTwo=[xTwo,xx];yTwo=[yTwo,yy];
    s_CalcParam;
    % s_Pre_solid;      % all_xy(repeat_times,fendu_times,paohe_turns,light_num) ==> xy(fendu_times,paohe_turns,light_num)
    s_Pre_Xuanzhuan;    % xy(fendu_times,paohe_turns,light_num) ==>  xy(fendu_times,1,paohe_turns,light_num)转换到小坐标系中
    s_Pre_mean;         % xy(fendu_times,paohe_turns,light_num) ==>  mean_xy(fendu_times,1,paohe_turns,light_num)
    figure(2);f_PlotAll(xx,yy,'小坐标系');
    matfile=strcat(dataDir,'\Data_',subDir,'_p.mat');
    save(matfile,'mean_x','mean_y','xx','yy','unit','fendu_times','paohe_turns','point_num','axes','circle');
end
figure_name=strcat(dataDir,'\Plot_AllTwo.jpg');
f_PlotAll(xTwo,yTwo,'二轴',figure_name);
msgbox('完成');
