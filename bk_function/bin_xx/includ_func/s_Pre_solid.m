%%%%%%�õ����й�������xx��yy(fendu_times,paohe_turns,light_num)
%%����������̶���������õ�������ꣻͬʱmean��repeat
% ����ƽ��

%2017.7.5 lzg start

if isempty(solid_x)
    origin_x=0; 
    origin_y=0;
else
    origin_x=mean(solid_x,4); 
    origin_y=mean(solid_y,4);
end

figure(100);
subplot(2,1,1);
plot(origin_x(:));
subplot(2,1,2);
plot(origin_y(:));
figurename = strcat(dataDir,'\P_Solid_',subDir,'.jpg');
saveas(gcf,figurename);
 
temp_x=zeros(repeat_times,fendu_times,paohe_turns,light_num);%���ڱ���ÿ�������ֵ�ľ���(�ظ��������ֶȴ������ܺϴ������������
temp_y=zeros(repeat_times,fendu_times,paohe_turns,light_num);%���ڱ���ÿ�������ֵ�ľ���
for u=1:light_num
    temp_x(:,:,:,u)=(all_x(:,:,:,u)-origin_x);
    temp_y(:,:,:,u)=(all_y(:,:,:,u)-origin_y);          %%%%  ��������
end

%����repeat
xx1=mean(temp_x,1);
yy1=mean(temp_y,1);
xx=zeros(fendu_times,paohe_turns,light_num);%���ڱ���ÿ�������ֵ�ľ���(�ֶȴ������ܺϴ������������
yy=zeros(fendu_times,paohe_turns,light_num);%���ڱ���ÿ�������ֵ�ľ���
xx(:,:,:)=xx1(1,:,:,:);
yy(:,:,:)=yy1(1,:,:,:);

