% 像素坐标拟合像素坐标
function [plilun_allunit,plilun_rms]=f_PXYNiHe(px,py,biaoding)

lilun_p(:,1)=mean(px(),2);lilun_p(:,2)=mean(py(),2);
for i=1:size(px,2)
%     biaoding=6;
    [canshu_x2,canshu_y2,dblCoorX,dblCoorY,cha_x,cha_y,cha,conda]=f_NiheParam(biaoding,px(:,i),py(:,i),lilun_p(:,1),lilun_p(:,2),'');
    [PX(:,i),PY(:,i)]=f_NiheTrans(biaoding,canshu_x2,canshu_y2,px(:,i),py(:,i));
end

%  [canshu_x2,canshu_y2,dblCoorX,dblCoorY,cha_x,cha_y,cha,conda]=f_NiheParam(biaoding,px(:,1),py(:,1),lilun_p(:,1),lilun_p(:,2),'');%%只用第一次参数
% for i=1:size(px,2)
% %     biaoding=6;
%     [PX(:,i),PY(:,i)]=f_NiheTrans(biaoding,canshu_x2,canshu_y2,px(:,i),py(:,i));
% end

rms=f_figure_cirlle_pixel(PX,PY,1);

[plilun_allunit,plilun_rms]=  rms_mean_std(PX,PY);
end