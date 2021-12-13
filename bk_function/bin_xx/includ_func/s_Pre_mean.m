%%%%%%得到所有光点的坐标xx，yy(fendu_times,paohe_turns,light_num)*nihe_bili
%%%%%%          mean_x,mean_y(fendu_times,1,light_num)*nihe_bili
%%%%%%%%%%%%%%对paohe_turns求平均

%2016.1.1 start

mean_x=mean(xx,2);
mean_y=mean(yy,2);
dist=xx;  %(分度次数，跑合次数，光点数）
bb=xx;
for p=1:size(all_x,3)
    dist(:,p,:)=sqrt((xx(:,p,:)-mean_x).^2+(yy(:,p,:)-mean_y).^2);%%按轮数平均得距离
end
min_dist=min(dist,[],2);
max_dist=(max(dist,[],2)-min_dist)*2/3+min_dist+10;
max_dist=(max_dist>=40).*max_dist+(max_dist<40)*40;%%把max_dist小于40的元素赋值为40
for p=1:size(all_x,3)
    bb(:,p,:)=max_dist(:,1,:)>=dist(:,p,:);
end
    sum_bb=sum(bb,2);
mean_x=sum(xx.*bb,2)./sum_bb;
mean_y=sum(yy.*bb,2)./sum_bb;

