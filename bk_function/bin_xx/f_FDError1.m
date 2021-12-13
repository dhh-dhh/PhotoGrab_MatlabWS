function  [name,count,std_xy] =f_FDError1(xx1,yy1,xx2,yy2,unit,mytitle)
pointNum =size(xx1,3) ;
mx1=mean(xx1,2);my1=mean(yy1,2);
mx2=mean(xx2,2);my2=mean(yy2,2);
error_x1=[];error_y1=[];
error_x2=[];error_y2=[];
error_xy1=[];error_xy2=[];
std_xy1=zeros(pointNum,1);
%hh=zeros(14,1);
count=0;
for p=1:pointNum
    xx11=xx1(:,:,p);
    yy11=yy1(:,:,p);
    xx22=xx2(:,:,p);
    yy22=yy2(:,:,p);
    average_x1=mx1(:,1,p);
    average_y1=my1(:,1,p);
    average_x2=mx2(:,1,p);
    average_y2=my2(:,1,p);
    for q=1:size(xx1,2)
        error_x1(:,q)=xx11(:,q)-average_x1;
        error_y1(:,q)=yy11(:,q)-average_y1;
        error_x2(:,q)=xx22(:,q)-average_x2;
        error_y2(:,q)=yy22(:,q)-average_y2;
    end
    error_xy1=sqrt(error_x1.*error_x1+error_y1.*error_y1);
    error_xy2=sqrt(error_x2.*error_x2+error_y2.*error_y2);
    std_xy1(p,1)=sqrt((sum(error_xy1(:).*error_xy1(:))+sum(error_xy2(:).*error_xy2(:)))/(size(error_xy1(:),1)+size(error_xy2(:),1)));
    % hh(n)=hh(n)+1
end
for i=1:pointNum
    if std_xy1(i,1)>0.5&&std_xy1(i,1)<10
        count=count+1;
        name{count,1}=unit(i);
        std_xy(count,1)=std_xy1(i,1);
        
        if count>=140
            break;
        end
    end
end

