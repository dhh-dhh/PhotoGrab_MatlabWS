function circle_point=f_find_c(px_rf,py_rf,center,range_r);
pxy=[px_rf,py_rf];circle_point=[];
for i=1:size(pxy,1)
    dis=sqrt((pxy(i,1)-center(1,1))^2+(pxy(i,2)-center(1,2))^2);
   if dis<range_r
       circle_point=[circle_point;pxy(i,:)];
   end
end
