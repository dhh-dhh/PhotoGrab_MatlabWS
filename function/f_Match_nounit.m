function  [XY8,GoodUnit,GoodXY8,num,dx,dy]= f_Match_nounit(LX,LY,XY4,biaoding,canshu_x,canshu_y,MaxDis)
Unit1=[10001:10001+size(LX,1)];
Unit=num2str(Unit1');
%[XY8,GoodUint,GoodXY8,num,dx,dy] =  Match(Unit,XY4,biaoding,canshu_x,canshu_y,LX,LY,MaxDis,mytitle);
%�������꾭��ϵ������任�õ��������������������߽���ƥ��
%���룺
%	Unit:                   ��Ԫ����
%   XY4                     �������� XY(:,1) XY(:,2)  ���Ҷ�ֵ ������
%   LX,LY:                  ��������
%	canshu_x,canshu_y��     ת����������biaodingΪ5ʱcanshu_xΪ5������canshu_yΪ��
%�����
%   GoodUint��              ƥ���ϵ�Ԫ����
%   XY8(:,[1,2]):           ���е�Ԫ�������� XY(:,1) XY(:,2)
%   XY8(:,[3,4]):           ���е�Ԫ������ ���Ҷ�ֵ
%   XY8(:,[5,6]):           ���е�Ԫ΢������
%   XY8(:,[7,8]):           ���е�Ԫ��Ԫ��������
%   GoodXY8(:,[1,2]):       ƥ���ϵ�Ԫ��������
%   GoodXY8(:,[3,4]):       ƥ���ϵ�Ԫ������ ���Ҷ�ֵ
%   GoodXY8(:,[5,6]):       ƥ���ϵ�Ԫ΢������
%   GoodXY6(:,[7:8])        ƥ���ϵ�Ԫ��������

%  2014_07_23   start
%  2015_10_10
%      index_everyU_LightNum1 = min(distance(:,o));  min_d(o) = index_everyU_LightNum1;
%�ĳɣ�        [min_d(o),index_everyU_LightNum(o)] = min(distance(:,o));

GoodXY8=[];
if nargin < 8
    errordlg('ȱ���������');
    return
end
if nargin < 9                      %�������=6ʱ ������������
    ifdraw = 0;
else
    ifdraw = 0;
end

XY8=zeros(size(XY4,1),8);
XY8(1:size(Unit,1),7)=LX;
XY8(1:size(Unit,1),8)=LY;
LightNum=size(XY4(:,1),1);
UnitNum=size(Unit,1);
MaxDistance = MaxDis*MaxDis;
distance=zeros(LightNum,UnitNum);
[XX1,YY1]=f_NiheTrans(biaoding,canshu_x,canshu_y,XY4(:,1),XY4(:,2)); %ʵ��΢������
for l = 1:UnitNum
    distance(:,l) = (XX1 - LX(l)).^2 + (YY1 - LY(l)).^2;
end
k=0;
[min_d,index_everyU_LightNum] = min(distance);
[min_d1,index_U] = min(min_d);
index_L = index_everyU_LightNum(index_U);

while min_d1 < MaxDistance
    k=k+1;
    GoodUnit(k,:)=Unit(index_U,:);
    GoodXY8(k,1:2)  =  XY4(index_L,1:2);  XY4(index_L,1)=-10;   %ƥ������������
    GoodXY8(k,5)  =    XX1(index_L);             %ʵ��΢������x
    GoodXY8(k,6)  =    YY1(index_L);             %ʵ��΢������Y
    GoodXY8(k,7)  =    LX(index_U);                             %����x����
    GoodXY8(k,8)  =    LY(index_U);                              %����y����
    distance(index_L,:) = MaxDistance;
    distance(:,index_U) = MaxDistance;
    min_d(index_U) = MaxDistance;
    for o = 1:UnitNum
        if index_everyU_LightNum(o) == index_L
            [min_d(o),index_everyU_LightNum(o)] = min(distance(:,o));
        end
    end
    [min_d1,index_U] = min(min_d);
    index_L = index_everyU_LightNum(index_U);
end
for i=1:size(Unit,1)
    for j=1:size(GoodUnit,1)
        if strcmp(Unit(i,:),GoodUnit(j,:))
            XY8(i,:) =  GoodXY8(j,:);
            break;
        end
    end
end

ss = size(Unit,1);
for i=1:size(XY4,1)
    if XY4(i,1)~=-10
        ss=ss+1;
        XY8(ss,1:6)=[XY4(i,:),XX1(i),YY1(i)];
    end
end
num = k;
dx = GoodXY8(:,7)-GoodXY8(:,5);
dy = GoodXY8(:,8)-GoodXY8(:,6);
if ifdraw ==1
    quiver(GoodXY8(:,1),GoodXY8(:,2),dx,dy)
end

end


% function test();
% fpath='..\testdata\f_Match.mat';
% load(fpath);
% MaxDis=5000;
% [XY8,GoodUnit,GoodXY8,num,dx,dy]  =  f_Match(unitName,lilun_x,lilun_y,XY4,biaoding,param_x,param_y,MaxDis);
