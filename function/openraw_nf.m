clc;clear all;close all;
f_path='F:\20201119五楼拍摄倾斜实验\正视\';

% I=fopen(f_path);
% A=fread(I,[7920 6004],'uint16');
% % A = uint8(A/16);
% A=A';
% % A=flipud(A);
%  figure();imshow(A,[]);

p_image=dir(strcat(f_path,'*.raw'));
image_count=size(p_image,1);      %获取文件夹内所有图片数
dircell=struct2cell(p_image)';   %将结构体转换为元胞数组
image_profile=dircell(:,1);
%             positions_10=zeros(600,4,((image_count)/10));
%                                     for i=1:1

% figure(1);
t=0;
for i=1:image_count
    %                 for i=1: 1
    t=t+1;
        filename=char(image_profile(i,1));
        rawfile = [f_path, filename];
        I = fopen(rawfile,'r');
        A=fread(I,[7920 6004],'uint16');
%         A=fread(I,[4096 4096],'uint16');
        fclose(I);
        A=A';
        R1=[4138,2685,40,40];
       R=R1-[20,20,0,0];
       figure();
imshow(A,[]);
%         R=[3566,2882,40,40];
%         img = imcrop(A,R);
%         subplot(2,8,t)
%         imshow(img,[]);
end