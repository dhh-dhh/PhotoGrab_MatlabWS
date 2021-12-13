function [pxy_allunit,plilun_rms_all]=pixcel_process(px,py)

% for i=size(pxy_all_unit,1):-1:1
%     if pxy_all_unit(i,1)>10 || pxy_all_unit(i,1)==0
%         px(i,:)=[];py(i,:)=[];
%     end
% end
[plilun_allunit6,plilun_rms6]=f_PXYNiHe(px,py,6);
[plilun_allunit12,plilun_rms12]=f_PXYNiHe(px,py,12);
[plilun_allunit20,plilun_rms20]=f_PXYNiHe(px,py,20);
[plilun_allunit30,plilun_rms30]=f_PXYNiHe(px,py,30);
[plilun_allunit_demean,plilun_rms_demean]=f_PXYdemean(px,py); %%Æ½ÒÆ
pxy_allunit=[plilun_allunit_demean,plilun_allunit6,plilun_allunit12,plilun_allunit20,plilun_allunit30];
plilun_rms_all=[plilun_rms_demean,plilun_rms6,plilun_rms12,plilun_rms20,plilun_rms30];

end