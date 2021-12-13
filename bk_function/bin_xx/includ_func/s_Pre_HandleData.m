%%1.alarm_unit，替换某单元不正常轮的全部数据，用正常的轮数的所有分度点数据mean后替换坏的轮数的全部数据,
%               例如{'PH0402',[2,4];'PH1511',[2:4];}
%                     'PH0402'的第二轮和第四轮的数据是不要修复的;  'PH1511'的第二轮到第四轮的数据是不要修复的.
%%2.alarm_unit2，替换某单元某分度点不正常轮的数据，用此分度点的正常轮数据mean后替换不正常分度点
%               例如{'PH0402',[2,4],2;'PH1511',[2:4],4;}
%                     'PH0402'第二个分度点的第二轮和第四轮的数据是不要修复的;  'PH1511'第四个分度点的第二轮到第四轮的数据是不要修复的.
%%3.alarm_unit3，替换不正常分度点的数据，用不正常分度点的最近分度点拟合修复该不正常分度点
%                例如'PH3024',[117:152];'PH2930',[100:130];
%                     'PH3024'的第117到第152分度点的数据是要修复的;  'PH2930'第100到第130个分度点的数据是要修复的.

%2017.1.15 lzg start 

alarm_num = size(alarm_unit,1);%行数
for i = 1:alarm_num
    for j = 1:light_num
        if strcmp(alarm_unit{i,1},unit{j})
            bad_mean_all_x =  zeros(repeat_times,fendu_times,1,1);
            bad_mean_all_y =  zeros(repeat_times,fendu_times,1,1);
            for m = 1:size(alarm_unit{i,2},2)%列数
                bad_mean_all_x(:,:,1,1) = bad_mean_all_x(:,:,1,1) + all_x(:,:,alarm_unit{i,2}(m),j);%正常轮求和
                bad_mean_all_y(:,:,1,1) = bad_mean_all_y(:,:,1,1) + all_y(:,:,alarm_unit{i,2}(m),j);
            end
            bad_mean_all_x = bad_mean_all_x / size(alarm_unit{i,2},2);%正常轮取平均
            bad_mean_all_y = bad_mean_all_y / size(alarm_unit{i,2},2);         
            for k = 1:size(all_x,3)%轮数
                bad = 1;
                for m = 1:size(alarm_unit{i,2},2)
                    if k == alarm_unit{i,2}(m)
                        bad = 0;
                    end
                end
                if bad == 1      
                    all_x(:,:,k,j) = bad_mean_all_x(:,:,1,1);    %替换不正常轮数据                
                    all_y(:,:,k,j) = bad_mean_all_y(:,:,1,1);
                end
            end
        end
    end   
end


alarm_num2 = size(alarm_unit2,1);
for i = 1:alarm_num2
    for j = 1:point_num
        if strcmp(alarm_unit2{i,1},unit{j})
            bad_mean_all_x2 =  zeros(repeat_times,size(alarm_unit2{i,3},2),1,1);
            bad_mean_all_y2 = zeros(repeat_times,size(alarm_unit2{i,3},2),1,1);
            for m = 1:size(alarm_unit2{i,2},2)
                for n = 1:size(alarm_unit2{i,3},2)
                    bad_mean_all_x2(:,n,1,1) = bad_mean_all_x2(:,n,1,1) + all_x(:,alarm_unit2{i,3}(n),alarm_unit2{i,2}(m),j);
                    bad_mean_all_y2(:,n,1,1) = bad_mean_all_y2(:,n,1,1) + all_y(:,alarm_unit2{i,3}(n),alarm_unit2{i,2}(m),j);
                end
            end
            bad_mean_all_x2 = bad_mean_all_x2 / size(alarm_unit2{i,2},2);
            bad_mean_all_y2 = bad_mean_all_y2 / size(alarm_unit2{i,2},2);         
            for k = 1:size(all_x,3)
                bad = 1;
                for m = 1:size(alarm_unit2{i,2},2)
                    if k == alarm_unit2{i,2}(m)
                        bad = 0;
                    end
                end
                if bad == 1      
                    for n = 1:size(alarm_unit2{i,3},2)
                       all_x(:,alarm_unit2{i,3}(n),k,j) = bad_mean_all_x2(:,n,1,1);                    
                       all_y(:,alarm_unit2{i,3}(n),k,j) = bad_mean_all_y2(:,n,1,1);
                    end
                end
            end
        end
    end   
end


if subDir(15:17)=='cen'
   judge=0;
elseif subDir(15:17)=='ecc'
    judge=1;
end
alarm_num3 = size(alarm_unit3,1);
for i = 1:alarm_num3
     BadIndex=alarm_unit3{i,2};
     BadIndex=sort(BadIndex);
    for j = 1:point_num
        if strcmp(alarm_unit3{i,1},unit{j})
           for e1=1:repeat_times
               for e3=1:paohe_turns
                   
                   temp_x=all_x(e1,:,e3,j);
                   temp_y=all_y(e1,:,e3,j);
                   for e2=size(temp_x,2):-1:1
                       for bad_num=1:size(BadIndex,2)
                           if e2 == BadIndex(bad_num)
                              temp_x(e2)=[];%把错误的分度上的值去掉
                              temp_y(e2)=[];
                           end
                       end
                   end
                   [x0,y0,r0]=f_NiheCircle(temp_x',temp_y');               
                   %得到正确的圆心
                   

                   start=1;
                   for count=2:size(BadIndex,2)
                       if BadIndex(count)-BadIndex(count-1)~=1 || count==size(BadIndex,2)
                           SubBadIndex=[];
                           if count==size(BadIndex,2)
                               SubBadIndex=BadIndex(start:count);
                           else
                               SubBadIndex=BadIndex(start:count-1);
                           end
                           start=count;

                           kkk_leftgood=SubBadIndex(1)-1; 
                           kkk_rightgood=SubBadIndex(end)+1;
                           kkk=kkk_leftgood;
                           if kkk_leftgood<1 && kkk_rightgood>fendu_times
                               msgbox('数据无法修复');return;
                           elseif kkk_leftgood<1;
                               kkk_leftgood=kkk_rightgood+1; 
                               kkk=kkk_rightgood;
                           elseif kkk_rightgood>fendu_times; 
                               kkk_rightgood=kkk_leftgood-10;
                               kkk=kkk_leftgood;
                           end

                           temp_x=all_x(e1,:,e3,j)-x0;
                           temp_y=all_y(e1,:,e3,j)-y0;                       
                           ddd=sqrt((temp_x(kkk_leftgood)-temp_x(kkk_rightgood))^2+(temp_y(kkk_leftgood)-temp_y(kkk_rightgood))^2);
                           angle_chushi=acos((2*r0*r0-ddd*ddd)/(2*r0*r0))/abs((kkk_rightgood-kkk_leftgood));%连续坏点数大于50%不可修复
                           

                           if temp_y(kkk)>0 && temp_x(kkk)>0 %第1象限
                                 angle_kkk=atan(temp_y(kkk)/temp_x(kkk));
                           elseif temp_y(kkk)>0 && temp_x(kkk)<0 %第2象限
                                   angle_kkk=pi-atan(temp_y(kkk)/abs(temp_x(kkk)));
                           elseif temp_y(kkk)<0 && temp_x(kkk)<0 %第3象限
                                   angle_kkk=pi+atan(temp_y(kkk)/temp_x(kkk));
                           elseif temp_y(kkk)<0 && temp_x(kkk)>0 %第4象限
                                   angle_kkk=2*pi-atan(abs(temp_y(kkk))/temp_x(kkk));
                           end
                           for subcount=1:size(SubBadIndex,2)
                               angle_add=abs(SubBadIndex(subcount)-kkk)*angle_chushi;
                               angle=angle_kkk + angle_add*(-1)^((SubBadIndex(subcount)<=kkk)+judge);
                               all_x(e1,SubBadIndex(subcount),e3,j)=r0*cos(angle)+x0;
                               all_y(e1,SubBadIndex(subcount),e3,j)=r0*sin(angle)+y0;
                           end
                       end
                   end
               end
           end
       end
    end
end
        
            



