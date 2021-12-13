function [B]=openraw(fileopen);
   I=fopen(fileopen);
                B1=fread(I,[7920 6004],'uint16');
                B=B1';
                B=flipud(B);
                figure();
                imshow(B,[]);
return