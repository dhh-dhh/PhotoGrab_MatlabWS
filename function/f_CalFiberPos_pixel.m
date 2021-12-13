function  [positions] =f_CalFiberPos_pixel(data)
positioner_number=0;
FlagEnergy=1;                     %  1�Ҷ�;2�Ҷ�ƽ��
FlagBackGround=0;                 %  0��������ֵ��1������ֵ
intImageHeight =6004;            %��Ƭ�߶�4096
intImageWidth = 7920;            %��Ƭ����4096
% intImageHeight =2048;            %��Ƭ�߶�4096
% intImageWidth = 2048;            %��Ƭ����4096

%                  intImageHeight =7920;            %��Ƭ�߶�4096
%                 intImageWidth = 6004;            %��Ƭ����4096

% intLightThreshold =mean(mean(data(:,:),1))+30*std(std(data(:,:),1));  %           %������ֵ�ݶ�600
% intBkThreshold =mean(mean(data(:,:),1))+10*std(std(data(:,:),1)); %               %������ֵ�ݶ�250


intLightThreshold =500;  %           %������ֵ�ݶ�600
intBkThreshold =400; %               %������ֵ�ݶ�250
% nImageType =3 ;                   %��X�᷽��ת�����罹��ǰ�����֧����4K���
% nihe_FN='3.tif';
Percent=0.8;
AllowError=1;
% data=imread(nihe_FN,'tif');
[XY4,FiberEnergy]  =  f_CalFiberPos_Energy(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,FlagEnergy,FlagBackGround);



[a , b ]=size(XY4);

k=1;
%%%%%%%%% �����С��5����Ԫ�Ĺ��ɾ����
while k <= a
    
    if XY4(k,4) < 5
        
        XY4(k,:)=[];
        
        k=k-1;
        a=a-1;
    end
    
    k=k+1;
    
    
end

[a, b]=size(XY4);

% for j=1:a
%     
%     alldots(1:a,:,i)=XY4;
%     
% end

tempXY4 = XY4(positioner_number+1:a,:);  %% �����к�����������
positioner_number=0;   % ���������Ǽ������вο����˵㣬���� ���Ǽ��㶨λ��Ԫ�Ĺ�ߵ��ȶ���
SortXX=tempXY4(:,1);
SortYY=tempXY4(:,2);
SortWW=tempXY4(:,3);
SortZZ=tempXY4(:,4);
[aa, bb]= size(SortXX);
%                 SortXX = imrotate(SortXX,90);
%                 SortYY = imrotate(SortYY,90);
%                 SortXX = imrotate(SortXX,90);
%                 SortXX = imrotate(SortXX,90);

for m=1:aa
    positions(1:m,1)=SortXX(1:m,1);
    positions(1:m,2)=SortYY(1:m,1);
    positions(1:m,3)=SortWW(1:m,1);
    positions(1:m,4)=SortZZ(1:m,1);
end
end