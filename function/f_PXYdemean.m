% 像素坐标减去平均值计算
function [plilun_allunit,plilun_rms]=f_PXYdemean(px,py)
lilun_p=[];
lilun_p(1,:)=mean(px(),1);lilun_p(2,:)=mean(py(),1);
for i=1:size(px,2)
    PX(:,i)= px(:,i)-lilun_p(1,i);
    PY(:,i)= py(:,i)-lilun_p(2,i);
end
rms=f_figure_cirlle_pixel(PX,PY,1);
[plilun_allunit,plilun_rms]=rms_mean_std(PX,PY);