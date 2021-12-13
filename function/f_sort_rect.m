
function [xx,yy]=f_sort_rect(rows,XY)
%对标准靶上的所有点进行排序，左->右，上->下
%rows=26
%XY 第一列x坐标  第二列y坐标

index_up=1;
[y,index_y]=sort(XY(:,2));
for i=1:size(y,1)
    x(i,1)= XY(index_y(i),1);
end
add=(max(y)-min(y))/(rows-1);

for i=1:rows
    count=0;
%     temp1_y=min(y)+(i-1)*add;
    temp1_y=max(y)-(i-1)*add;
    temp2_y=[];temp2_x=[];
    temp3_y=[];temp3_x=[];
    for j=1:size(y,1)
        if y(j,1)>=temp1_y-0.7*add && y(j,1)<=temp1_y+0.3*add
            count=count+1;
            temp2_y(count,1)=y(j,1);
            temp2_x(count,1)=x(j,1);
        end
    end
    if count>0
        [temp3_x,index]=sort(temp2_x);
        for k=1:size(temp3_x,1)
            temp3_y(k,1)=temp2_y(index(k),1);
        end
        index_down=index_up+size(temp3_x,1)-1;
        xx(index_up:index_down,1)=temp3_x;
        yy(index_up:index_down,1)=temp3_y;
        index_up=index_down+1;
    end
end
return

%function ff()
% path='..\testdata\XY4.mat';
% load(path);
% rows=26;
% [xx,yy]=sort_rect(rows,XY4);
% figure(1); plot(xx,yy,'.');