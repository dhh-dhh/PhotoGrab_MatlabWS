function [trans_x,trans_y]=NiheTrans(biaoding,param_x,param_y,x,y)
%function [trans_x,trans_y]=NiheTrans(biaoding,param_x,param_y,x,y)
%������������������任��������ü�������
%
%���룺
%   biaoding:           ����任����������Ϊ��5,6,12,20,30,42
%   param_x:            �任����,biaodingΪ5ʱparam_x������
%   param_y:            �任����,biaodingΪ5ʱparam_yΪ��
%   x,y:                ���任�����꣬ͨ���ǲ���ֵ
%   lilun_x,lilun_y:    �任����ֵ��
%
%�����
%   trans_x,trans_y:   ����x,y�ͱ任�������м����õļ���ֵ

% 2015.10.10   start

if biaoding==5;
    c=param_x;
    trans_x = (c(4).*(c(2)+y).*sin(c(5))+c(3).*(x+c(1)).*cos(c(5)));
    trans_y = (c(4).*(c(2)+y).*cos(c(5))-c(3).*(x+c(1)).*sin(c(5)));
    
end

if biaoding==6; %ƽ��+xy�������� һ��
    trans_x=param_x(1)+param_x(2).*x+param_x(3).*y;
    trans_y=param_y(1)+param_y(2).*x+param_y(3).*y;
elseif biaoding==12;%ƽ��+xy��������+xyƽ�� ����
    trans_x=param_x(1)+param_x(2).*x+param_x(3).*y+param_x(4).*x.*x+param_x(5).*x.*y+param_x(6).*y.*y;
    trans_y=param_y(1)+param_y(2).*x+param_y(3).*y+param_y(4).*x.*x+param_y(5).*x.*y+param_y(6).*y.*y;
elseif biaoding==20;%ƽ��+xy�������� ����
    trans_x=param_x(1)+param_x(2).*x+param_x(3).*y+param_x(4).*x.*x+param_x(5).*x.*y+param_x(6).*y.*y+param_x(7).*x.^3+param_x(8).*x.^2.*y+param_x(9).*x.*y.^2+param_x(10).*y.^3;
    trans_y=param_y(1)+param_y(2).*x+param_y(3).*y+param_y(4).*x.*x+param_y(5).*x.*y+param_y(6).*y.*y+param_y(7).*x.^3+param_y(8).*x.^2.*y+param_y(9).*x.*y.^2+param_y(10).*y.^3;
elseif biaoding==30;%ƽ��+xy�������� �Ľ�
    trans_x=param_x(1)+param_x(2).*x+param_x(3).*y+param_x(4).*x.*x+param_x(5).*x.*y+param_x(6).*y.*y+param_x(7).*x.^3+param_x(8).*x.^2.*y+param_x(9).*x.*y.^2+param_x(10).*y.^3+param_x(11).*x.^4+param_x(12).*x.^3.*y+param_x(13).*x.^2.*y.^2+param_x(14).*x.*y.^3+param_x(15).*y.^4;
    trans_y=param_y(1)+param_y(2).*x+param_y(3).*y+param_y(4).*x.*x+param_y(5).*x.*y+param_y(6).*y.*y+param_y(7).*x.^3+param_y(8).*x.^2.*y+param_y(9).*x.*y.^2+param_y(10).*y.^3+param_y(11).*x.^4+param_y(12).*x.^3.*y+param_y(13).*x.^2.*y.^2+param_y(14).*x.*y.^3+param_y(15).*y.^4;
elseif biaoding==42;
    trans_x=param_x(1)+param_x(2).*x+param_x(3).*y+param_x(4).*x.*x+param_x(5).*x.*y+param_x(6).*y.*y+param_x(7).*x.^3+param_x(8).*x.^2.*y+param_x(9).*x.*y.^2+param_x(10).*y.^3+param_x(11).*x.^4+param_x(12).*x.^3.*y+param_x(13).*x.^2.*y.^2+param_x(14).*x.*y.^3+param_x(15).*y.^4+param_x(16).*x.^5+param_x(17).*x.^4.*y+param_x(18).*x.^3.*y.^2+param_x(19).*x.^2.*y.^3+param_x(20).*x.*y.^4+param_x(21).*y.^5;
    trans_y=param_y(1)+param_y(2).*x+param_y(3).*y+param_y(4).*x.*x+param_y(5).*x.*y+param_y(6).*y.*y+param_y(7).*x.^3+param_y(8).*x.^2.*y+param_y(9).*x.*y.^2+param_y(10).*y.^3+param_y(11).*x.^4+param_y(12).*x.^3.*y+param_y(13).*x.^2.*y.^2+param_y(14).*x.*y.^3+param_y(15).*y.^4+param_y(16).*x.^5+param_y(17).*x.^4.*y+param_y(18).*x.^3.*y.^2+param_y(19).*x.^2.*y.^3+param_y(20).*x.*y.^4+param_y(21).*y.^5;
elseif biaoding==56;
    trans_x=param_x(1)+param_x(2).*x+param_x(3).*y+param_x(4).*x.*x+param_x(5).*x.*y+param_x(6).*y.*y+param_x(7).*x.^3+param_x(8).*x.^2.*y+param_x(9).*x.*y.^2+param_x(10).*y.^3+param_x(11).*x.^4+param_x(12).*x.^3.*y+param_x(13).*x.^2.*y.^2+param_x(14).*x.*y.^3+param_x(15).*y.^4+param_x(16).*x.^5+param_x(17).*x.^4.*y+param_x(18).*x.^3.*y.^2+param_x(19).*x.^2.*y.^3+param_x(20).*x.*y.^4+param_x(21).*y.^5+param_x(22).*x.^6+param_x(23).*x.^5.*y+param_x(24).*x.^4.*y.^2+param_x(25).*x.^3.*y.^3+param_x(26).*x.^2.*y.^4+param_x(27).*x.*y.^5+param_x(28).*y.^6;
    trans_y=param_y(1)+param_y(2).*x+param_y(3).*y+param_y(4).*x.*x+param_y(5).*x.*y+param_y(6).*y.*y+param_y(7).*x.^3+param_y(8).*x.^2.*y+param_y(9).*x.*y.^2+param_y(10).*y.^3+param_y(11).*x.^4+param_y(12).*x.^3.*y+param_y(13).*x.^2.*y.^2+param_y(14).*x.*y.^3+param_y(15).*y.^4+param_y(16).*x.^5+param_y(17).*x.^4.*y+param_y(18).*x.^3.*y.^2+param_y(19).*x.^2.*y.^3+param_y(20).*x.*y.^4+param_y(21).*y.^5+param_y(22).*x.^6+param_y(23).*x.^5.*y+param_y(24).*x.^4.*y.^2+param_y(25).*x.^3.*y.^3+param_y(26).*x.^2.*y.^4+param_y(27).*x.*y.^5+param_y(28).*y.^6;
end
return;

%function testdata()
% fpath='..\testdata\f_NiheTrans.mat';
% load(fpath);
% [XX1,YY1]=f_NiheTrans(biaoding,canshu_x,canshu_y,XY4(:,1),XY4(:,2));
