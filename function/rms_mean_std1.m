% %  一个点的rmse  mean  std
function [rms,cha_ttxy1]=rms_mean_std1(XY)
            for i=1:size(XY,1)
                cha_xy(i,:) = XY(i,:) - mean(XY,1);
%                 cha_yy1( = XY(:,i) - mean(XY,2);
            end
            cha_ttxy1=sqrt(cha_xy(:,1).*cha_xy(:,1) + cha_xy(:,2).*cha_xy(:,2));
%             for i=1:size(cha_ttxy1,2)
                rms(1,1)=sqrt(sum(cha_ttxy1.*cha_ttxy1)/size(cha_ttxy1,1));
                rms(2,1)=mean(cha_ttxy1);
                rms(3,1)=std(cha_ttxy1);
%             end
%             test(1,1)=sqrt(sum(std_ttxy1.*std_ttxy1/(size(std_ttxy1,1))));
%             test(2,1)=mean(std_ttxy1);
%             test(3,1)=std(std_ttxy1);
end