function [tttx,ttty,pppx,pppy]=f_del_zero(xx,yy,px,py)
for i=size(px,1):-1:1
   if px(i,1)==0
       xx(i,:)=[];yy(i,:)=[];px(i,:)=[];py(i,:)=[];
   end
end
tttx=xx;ttty=yy;pppx=px;pppy=py;