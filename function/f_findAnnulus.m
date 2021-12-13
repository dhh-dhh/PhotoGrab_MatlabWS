%% 通过圆环找光纤
function [annulusList]=f_findAnnulus(allPointX,allPointY,rMin,rMax,step,fiberNumThreshold)
annulusList=[];
% step=5;%% 查找步长
for i=floor(min(min(allPointX))):step:floor(max(max(allPointX)))
   for j=floor(min(min(allPointY))):step: floor(max(max(allPointY)))
       dis=sqrt((allPointX-i).^2+(allPointY-j).^2);
       [x,y]=find(dis<rMax & dis>rMin);
       if size(x,1) >fiberNumThreshold
           annulusList=[annulusList;[i,j]];
       end
   end
end
% figure();plot(annulusList(:,1),annulusList(:,2),'.b');








end