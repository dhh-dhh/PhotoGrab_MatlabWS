function [param_x,param_y,dblCoorX,dblCoorY,cha_x,cha_y,cha,conta] = NiheParam(biaoding,x,y,lilun_x,lilun_y,mytitle)
%[param_x,param_y,dblCoorX,dblCoorY,cha_x,cha_y,cha]=f_NiheParam(biaoding,x,y,lilun_x,lilun_y,mytitle)
%��������������ʵ�����꣬���ת������
%��biaodingΪ5�����x��yƫ������x��y�Ŵ�������ת��
%��biaodingΪ6��12��20��30��42ʱ��������С���˷�ԭ����ж���ʽ��ϣ���ö���ʽϵ����Ϊ�任����
%����任������һ�ס����ס����ס��Ľס����
%
%���룺
%   biaoding:          ����任����������Ϊ��5,6,12,20,30,42��56
%   x,y:               ���任�����꣬ͨ���ǲ���ֵ
%   lilun_x,lilun_y:   �任����ֵ
%   mytitle��          �����ͼ��������Ŀ
%�����
%   param_x,param_y:     �任����
%   dblCoorX,dblCoorY:     ����x,y�ͱ任�������м����õļ���ֵ
%   cha_x,cha_y:           ����ֵ������ֵ֮��
%   cha:                   ����ֵ������ֵ֮����

% 2015.10.10   start

% function testdata()
% biaoding=56; % biaoding���Էֱ����56,42,30,20,12,6���Աȣ�
% load('..\testdata\f_NiheParam.mat')
% x=aa(:,1);
% y=aa(:,2);
% lilun_x=hh(:,1);
% lilun_y=hh(:,2);
% [param_x,param_y,dblCoorX,dblCoorY,cha_x,cha_y,cha]=f_NiheParam(biaoding,x,y,lilun_x,lilun_y,'');

if nargin < 5
    errordlg('ȱ���������');
    return;
end
if nargin < 6                        %�������<6ʱ ������ͼ
    ifdraw= 0;
else
    ifdraw = 0;
end
%�����ĸ�ֵ����С���˷��ó�paramx�������
if biaoding ==5
    x=x(:)';
    y=y(:)';
    p=[x;y];
    p=p(:);
    lilun_x=lilun_x(:)';
    lilun_y=lilun_y(:)';
    q=[lilun_x;lilun_y];
    q=q(:);
    options = optimset('MaxFunEvals',20000,'MaxIter',1000,'TolX',1e-8,'TolFun',1e-8);
    %��С���˷����
    param_x = lsqcurvefit(@bianhuan,[0 0 100 100 0],p,q,[-8000,-8000,10,10,-2],[8000,8000,1000,1000,2],options);
    param_y=[];
    dblCoorX=[];dblCoorY=[];
    [dblCoorX,dblCoorY]=f_NiheTrans(biaoding,param_x,param_y,x,y);	%%%%%%%%%%���ݲ���ֵ�Ͳ���ֵ��ü���ֵ
    cha_x=dblCoorX-lilun_x;
    cha_y=dblCoorY-lilun_y;
    cha=sqrt(cha_x.^2+cha_y.^2);
else
    m=1;
    while m>0;
        m=0;
        Num=size(x,1);
        [A,BX,BY]=f_param(biaoding,x,y,lilun_x,lilun_y);
        param_x=A\BX;
        param_y=A\BY;
        conta=cond(A);
        param=[param_x(:),param_y(:);];
        dblCoorX=[];dblCoorY=[];
        [dblCoorX,dblCoorY]=f_NiheTrans(biaoding,param_x,param_y,x,y);	%%%%%%%%%%���ݲ���ֵ�Ͳ���ֵ��ü���ֵ
        cha_x=dblCoorX-lilun_x;
        cha_y=dblCoorY-lilun_y;
        cha=sqrt(cha_x.^2+cha_y.^2);
        cha_good=sqrt(sum(cha.^2)/Num)*3;    %%%%%%%%%%  3��ֵ
        for i=size(cha(:),1):-1:1;         %%%%%%%%%%  �޳�3��֮��ĵ�
            if cha(i)>cha_good;
                x(i)=[];
                y(i)=[];
                lilun_x(i)=[];
                lilun_y(i)=[];
                m=m+1;
            end;
        end;
    end;
end
if ifdraw ==1
    figure
    quiver(lilun_x,lilun_y,cha_x,cha_y);
    title(mytitle);
end
return;

function f = bianhuan(c,p)
num= size(p,1)/2;
for i=1:num
    f(2*i-1,1)  =(c(4)*(c(2)+p(2*i))*sin(c(5))+c(3)*(p(2*i-1)+c(1))*cos(c(5)));
    f(2*i,1  )  =(c(4)*(c(2)+p(2*i))*cos(c(5))-c(3)*(p(2*i-1)+c(1))*sin(c(5)));
end

%%%%%%%%%%������С����ԭ����ò���ֵ����paper�ļ��У�
function [A,BX,BY]=f_param(biaoding,x,y,lilun_x,lilun_y)
Num=size(x,1);
if biaoding==6;
    A=[
        Num ,sum(x), sum(y);
        sum(x), sum(x.*x), sum(x.*y);
        sum(y) ,sum(y.*x), sum(y.*y) ;
        ];
    
    BX=[
        sum(lilun_x);
        sum(lilun_x.*x);
        sum(lilun_x.*y);
        ];
    
    BY=[
        sum(lilun_y);
        sum(lilun_y.*x);
        sum(lilun_y.*y);
        ];
    
elseif biaoding==12;
    A=[
        Num ,sum(x), sum(y), sum(x.*x), sum(x.*y) ,sum(y.*y);
        sum(x), sum(x.*x), sum(x.*y) ,sum(x.^3),  sum((x.^2).*y),sum((y.^2).*x);
        sum(y) ,sum(y.*x), sum(y.*y) ,sum((x.^2).*y) , sum(x.*(y.^2)) ,sum(y.^3);
        sum(x.*x), sum(x.^3), sum((x.^2).*y), sum(x.^4)  ,sum((x.^3).*y) ,sum((x.^2).*(y.^2));
        sum(x.*y), sum((x.^2).*y), sum(x.*(y.^2)), sum((x.^3).*y),  sum((x.^2).*(y.^2)) ,sum(x.*(y.^3));
        sum(y.*y), sum((y.^2).*x), sum(y.^3) ,sum((x.^2).*(y.^2)),  sum((y.^3).*x) ,sum(y.^4);
        ];
    
    
    BX=[
        sum(lilun_x);
        sum(lilun_x.*x);
        sum(lilun_x.*y);
        sum(lilun_x.*x.*x);
        sum(lilun_x.*x.*y);
        sum(lilun_x.*y.*y);
        ];
    
    BY=[
        sum(lilun_y);
        sum(lilun_y.*x);
        sum(lilun_y.*y);
        sum(lilun_y.*x.*x);
        sum(lilun_y.*x.*y);
        sum(lilun_y.*y.*y);
        ];
    
elseif biaoding==20;
    A=[
        Num ,sum(x), sum(y), sum(x.*x), sum(x.*y) ,sum(y.*y),sum(x.^3),sum(x.^2.*y),sum(y.^2.*x),sum(y.^3);
        sum(x), sum(x.*x), sum(x.*y) ,sum(x.^3),  sum((x.^2).*y), sum((y.^2).*x),sum(x.^4),sum(x.^3.*y),sum(x.^2.*y.^2),sum(x.*y.^3);
        sum(y) ,sum(y.*x), sum(y.*y) ,sum((x.^2).*y) , sum(x.*(y.^2)) ,sum(y.^3),sum(x.^3.*y),sum(x.^2.*y.^2),sum(x.*y.^3),sum(y.^4);
        sum(x.*x), sum(x.^3), sum((x.^2).*y), sum(x.^4)  ,sum((x.^3).*y) ,sum((x.^2).*(y.^2)),sum(x.^5),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^2.*y.^3);
        sum(x.*y), sum((x.^2).*y), sum(x.*(y.^2)), sum((x.^3).*y),  sum((x.^2).*(y.^2)) ,sum(x.*(y.^3)),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.*(y.^4));
        sum(y.*y), sum((y.^2).*x), sum(y.^3) ,sum((x.^2).*(y.^2)),  sum((y.^3).*x) ,sum(y.^4),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.*(y.^4)),sum(y.^5);
        sum(x.^3), sum(x.^4)  ,sum((x.^3).*y) ,sum(x.^5),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^6),sum(x.^5.*y),sum(x.^4.*y.^2),sum(x.^3.*y.^3);
        sum((x.^2).*y),sum((x.^3).*y) ,sum((x.^2).*(y.^2)),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.^5.*y),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^2.*y.^4);
        sum(x.*(y.^2)) ,sum((x.^2).*(y.^2)),sum(x.*(y.^3)),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.*(y.^4)),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.*y.^5);
        sum(y.^3),sum(x.*y.^3),sum(y.^4),sum(x.^2.*y.^3),sum(x.*(y.^4)),sum(y.^5),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.*y.^5),sum(y.^6);
        ];
    
    BX=[
        sum(lilun_x);
        sum(lilun_x.*x);
        sum(lilun_x.*y);
        sum(lilun_x.*x.*x);
        sum(lilun_x.*x.*y);
        sum(lilun_x.*y.*y);
        sum(lilun_x.*x.^3);
        sum(lilun_x.*x.*x.*y);
        sum(lilun_x.*x.*y.*y);
        sum(lilun_x.*y.^3);
        ];
    
    BY=[
        sum(lilun_y);
        sum(lilun_y.*x);
        sum(lilun_y.*y);
        sum(lilun_y.*x.*x);
        sum(lilun_y.*x.*y);
        sum(lilun_y.*y.*y);
        sum(lilun_y.*x.^3);
        sum(lilun_y.*x.*x.*y);
        sum(lilun_y.*x.*y.*y);
        sum(lilun_y.*y.^3);
        ];
    
elseif biaoding==30;
    A=[
        Num ,sum(x), sum(y), sum(x.*x), sum(x.*y) ,sum(y.*y),sum(x.^3),sum(x.^2.*y),sum(y.^2.*x),sum(y.^3),sum(x.^4),sum(x.^3.*y),sum(x.^2.*y.^2),sum(x.*y.^3),sum(y.^4);
        sum(x), sum(x.*x), sum(x.*y) ,sum(x.^3),  sum((x.^2).*y), sum((y.^2).*x),sum(x.^4),sum(x.^3.*y),sum(x.^2.*y.^2),sum(x.*y.^3),sum(x.^5),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.*y.^4);
        sum(y) ,sum(y.*x), sum(y.*y) ,sum((x.^2).*y) , sum(x.*(y.^2)) ,sum(y.^3),sum(x.^3.*y),sum(x.^2.*y.^2),sum(x.*y.^3),sum(y.^4),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.*y.^4),sum(y.^5);
        sum(x.*x), sum(x.^3), sum((x.^2).*y), sum(x.^4)  ,sum((x.^3).*y) ,sum((x.^2).*(y.^2)),sum(x.^5),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.^6),sum(x.^5.*y),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^2.*y.^4);
        sum(x.*y), sum((x.^2).*y), sum(x.*(y.^2)), sum((x.^3).*y),  sum((x.^2).*(y.^2)) ,sum(x.*(y.^3)),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.*(y.^4)),sum(x.^5.*y),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.*y.^5);
        sum(y.*y), sum((y.^2).*x), sum(y.^3) ,sum((x.^2).*(y.^2)),  sum((y.^3).*x) ,sum(y.^4),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.*(y.^4)),sum(y.^5),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.*y.^5),sum(y.^6);
        sum(x.^3), sum(x.^4),sum((x.^3).*y) ,sum(x.^5),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^6),sum(x.^5.*y),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^7),sum(x.^6.*y),sum(x.^5.*y.^2),sum(x.^4.*y.^3),sum(x.^3.*y.^4);
        sum((x.^2).*y),sum((x.^3).*y) ,sum((x.^2).*(y.^2)),sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.^5.*y),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.^6.*y),sum(x.^5.*y.^2),sum(x.^4.*y.^3),sum(x.^3.*y.^4),sum(x.^2.*y.^5);
        sum(x.*(y.^2)) ,sum((x.^2).*(y.^2)),sum(x.*(y.^3)),sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.*(y.^4)),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.*y.^5),sum(x.^5.*y.^2),sum(x.^4.*y.^3),sum(x.^3.*y.^4),sum(x.^2.*y.^5),sum(x.*y.^6);
        sum(y.^3),sum(x.*y.^3),sum(y.^4),sum(x.^2.*y.^3),sum(x.*(y.^4)),sum(y.^5),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.*y.^5),sum(y.^6),sum(x.^4.*y.^3),sum(x.^3.*y.^4),sum(x.^2.*y.^5),sum(x.*y.^6),sum(y.^7);
        sum(x.^4) ,sum(x.^5),sum(x.^4.*y),sum(x.^6),sum(x.^5.*y),sum(x.^4.*y.^2),sum(x.^7),sum(x.^6.*y),sum(x.^5.*y.^2),sum(x.^4.*y.^3),sum(x.^8),sum(x.^7.*y),sum(x.^6.*y.^2),sum(x.^5.*y.^3),sum(x.^4.*y.^4);
        sum((x.^3).*y) ,sum(x.^4.*y),sum(x.^3.*y.^2),sum(x.^5.*y),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^6.*y),sum(x.^5.*y.^2),sum(x.^4.*y.^3),sum(x.^3.*y.^4),sum(x.^7.*y),sum(x.^6.*y.^2),sum(x.^5.*y.^3),sum(x.^4.*y.^4),sum(x.^3.*y.^5);
        sum(x.^2.*y.^2) ,sum(x.^3.*y.^2),sum(x.^2.*y.^3),sum(x.^4.*y.^2),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.^5.*y.^2),sum(x.^4.*y.^3),sum(x.^3.*y.^4),sum(x.^2.*y.^5),sum(x.^6.*y.^2),sum(x.^5.*y.^3),sum(x.^4.*y.^4),sum(x.^3.*y.^5),sum(x.^2.*y.^6);
        sum(x.*y.^3) ,sum(x.^2.*y.^3),sum(x.*y.^4),sum(x.^3.*y.^3),sum(x.^2.*y.^4),sum(x.*y.^5),sum(x.^4.*y.^3),sum(x.^3.*y.^4),sum(x.^2.*y.^5),sum(x.*y.^6),sum(x.^5.*y.^3),sum(x.^4.*y.^4),sum(x.^3.*y.^5),sum(x.^2.*y.^6),sum(x.*y.^7);
        sum(y.^4) ,sum(x.*y.^4),sum(y.^5),sum(x.^2.*y.^4),sum(x.*y.^5),sum(y.^6),sum(x.^3.*y.^4),sum(x.^2.*y.^5),sum(x.*y.^6),sum(y.^7),sum(x.^4.*y.^4),sum(x.^3.*y.^5),sum(x.^2.*y.^6),sum(x.*y.^7),sum(y.^8);
        ];
    
    
    BX=[
        sum(lilun_x);
        sum(lilun_x.*x);
        sum(lilun_x.*y);
        sum(lilun_x.*x.*x);
        sum(lilun_x.*x.*y);
        sum(lilun_x.*y.*y);
        sum(lilun_x.*x.^3);
        sum(lilun_x.*x.*x.*y);
        sum(lilun_x.*x.*y.*y);
        sum(lilun_x.*y.^3);
        sum(lilun_x.*x.^4);
        sum(lilun_x.*x.^3.*y);
        sum(lilun_x.*x.^2.*y.^2);
        sum(lilun_x.*x.*y.^3);
        sum(lilun_x.*y.^4);
        ];
    
    BY=[
        sum(lilun_y);
        sum(lilun_y.*x);
        sum(lilun_y.*y);
        sum(lilun_y.*x.*x);
        sum(lilun_y.*x.*y);
        sum(lilun_y.*y.*y);
        sum(lilun_y.*x.^3);
        sum(lilun_y.*x.*x.*y);
        sum(lilun_y.*x.*y.*y);
        sum(lilun_y.*y.^3);
        sum(lilun_y.*x.^4);
        sum(lilun_y.*x.^3.*y);
        sum(lilun_y.*x.^2.*y.^2);
        sum(lilun_y.*x.*y.^3);
        sum(lilun_y.*y.^4);
        ];
    
elseif biaoding==42;
    A=[
        Num ,                   sum(x),                  sum(y),                sum(x.*x),            sum(x.*y) ,             sum(y.*y),           sum(x.^3),          sum(x.^2.*y),       sum(y.^2.*x),         sum(y.^3),            sum(x.^4),         sum(x.^3.*y),         sum(x.^2.*y.^2),        sum(x.*y.^3),        sum(y.^4),              sum(x.^5),         sum(x.^4.*y),         sum(x.^3.*y.^2),        sum(x.^2.*y.^3),        sum(x.*y.^4),      sum(y.^5);
        sum(x),               sum(x.*x),               sum(x.*y) ,            sum(x.^3),            sum((x.^2).*y),         sum((y.^2).*x),      sum(x.^4),          sum(x.^3.*y),       sum(x.^2.*y.^2),      sum(x.*y.^3),         sum(x.^5),         sum(x.^4.*y),         sum(x.^3.*y.^2),        sum(x.^2.*y.^3),     sum(x.*y.^4),           sum(x.^6),         sum(x.^5.*y),         sum(x.^4.*y.^2),        sum(x.^3.*y.^3),        sum(x.^2.*y.^4),   sum(x.*y.^5);
        sum(y) ,              sum(y.*x),               sum(y.*y) ,            sum((x.^2).*y) ,      sum(x.*(y.^2)) ,        sum(y.^3),           sum(x.^3.*y),       sum(x.^2.*y.^2),    sum(x.*y.^3),         sum(y.^4),            sum(x.^4.*y),      sum(x.^3.*y.^2),      sum(x.^2.*y.^3),        sum(x.*y.^4),        sum(y.^5),              sum(x.^5.*y),      sum(x.^4.*y.^2),       sum(x.^3.*y.^3),        sum(x.^2.*y.^4),        sum(x.*y.^5),      sum(y.^6);
        sum(x.*x),            sum(x.^3),               sum((x.^2).*y),        sum(x.^4)  ,          sum((x.^3).*y) ,        sum((x.^2).*(y.^2)), sum(x.^5),          sum(x.^4.*y),       sum(x.^3.*y.^2),      sum(x.^2.*y.^3),      sum(x.^6),         sum(x.^5.*y),         sum(x.^4.*y.^2),        sum(x.^3.*y.^3),     sum(x.^2.*y.^4),        sum(x.^7),         sum(x.^6.*y),         sum(x.^5.*y.^2),        sum(x.^4.*y.^3),        sum(x.^3.*y.^4),   sum(x.^2.*y.^5);
        sum(x.*y),            sum((x.^2).*y),          sum(x.*(y.^2)),        sum((x.^3).*y),       sum((x.^2).*(y.^2)) ,   sum(x.*(y.^3)),      sum(x.^4.*y),       sum(x.^3.*y.^2),    sum(x.^2.*y.^3),      sum(x.*(y.^4)),       sum(x.^5.*y),      sum(x.^4.*y.^2),      sum(x.^3.*y.^3),        sum(x.^2.*y.^4),     sum(x.*y.^5),           sum(x.^6.*y),      sum(x.^5.*y.^2),       sum(x.^4.*y.^3),        sum(x.^3.*y.^4),        sum(x.^2.*y.^5),   sum(x.*y.^6);
        sum(y.*y),            sum((y.^2).*x),          sum(y.^3) ,            sum((x.^2).*(y.^2)),  sum((y.^3).*x) ,        sum(y.^4),           sum(x.^3.*y.^2),    sum(x.^2.*y.^3),    sum(x.*(y.^4)),       sum(y.^5),            sum(x.^4.*y.^2),   sum(x.^3.*y.^3),      sum(x.^2.*y.^4),        sum(x.*y.^5),        sum(y.^6),              sum(x.^5.*y.^2),    sum(x.^4.*y.^3),       sum(x.^3.*y.^4),        sum(x.^2.*y.^5),        sum(x.*y.^6),      sum(y.^7);
        sum(x.^3),            sum(x.^4),               sum((x.^3).*y) ,       sum(x.^5),            sum(x.^4.*y),           sum(x.^3.*y.^2),     sum(x.^6),          sum(x.^5.*y),       sum(x.^4.*y.^2),      sum(x.^3.*y.^3),      sum(x.^7),         sum(x.^6.*y),         sum(x.^5.*y.^2),        sum(x.^4.*y.^3),     sum(x.^3.*y.^4),        sum(x.^8),         sum(x.^7.*y),         sum(x.^6.*y.^2),        sum(x.^5.*y.^3),        sum(x.^4.*y.^4),   sum(x.^3.*y.^5);
        sum((x.^2).*y),       sum((x.^3).*y) ,         sum((x.^2).*(y.^2)),   sum(x.^4.*y),         sum(x.^3.*y.^2),        sum(x.^2.*y.^3),     sum(x.^5.*y),       sum(x.^4.*y.^2),    sum(x.^3.*y.^3),      sum(x.^2.*y.^4),      sum(x.^6.*y),      sum(x.^5.*y.^2),      sum(x.^4.*y.^3),        sum(x.^3.*y.^4),     sum(x.^2.*y.^5),        sum(x.^7.*y),      sum(x.^6.*y.^2),       sum(x.^5.*y.^3),        sum(x.^4.*y.^4),        sum(x.^3.*y.^5),   sum(x.^2.*y.^6);
        sum(x.*(y.^2)) ,      sum((x.^2).*(y.^2)),     sum(x.*(y.^3)),        sum(x.^3.*y.^2),      sum(x.^2.*y.^3),        sum(x.*(y.^4)),      sum(x.^4.*y.^2),    sum(x.^3.*y.^3),    sum(x.^2.*y.^4),      sum(x.*y.^5),         sum(x.^5.*y.^2),   sum(x.^4.*y.^3),      sum(x.^3.*y.^4),        sum(x.^2.*y.^5),     sum(x.*y.^6),           sum(x.^6.*y.^2),    sum(x.^5.*y.^3),       sum(x.^4.*y.^4),        sum(x.^3.*y.^5),        sum(x.^2.*y.^6),   sum(x.*y.^7);
        sum(y.^3),            sum(x.*y.^3),            sum(y.^4),             sum(x.^2.*y.^3),      sum(x.*(y.^4)),         sum(y.^5),           sum(x.^3.*y.^3),    sum(x.^2.*y.^4),    sum(x.*y.^5),         sum(y.^6),            sum(x.^4.*y.^3),   sum(x.^3.*y.^4),      sum(x.^2.*y.^5),        sum(x.*y.^6),        sum(y.^7),              sum(x.^5.*y.^3),    sum(x.^4.*y.^4),       sum(x.^3.*y.^5),        sum(x.^2.*y.^6),        sum(x.*y.^7),      sum(y.^8);
        sum(x.^4) ,           sum(x.^5),               sum(x.^4.*y),          sum(x.^6),            sum(x.^5.*y),           sum(x.^4.*y.^2),     sum(x.^7),          sum(x.^6.*y),       sum(x.^5.*y.^2),      sum(x.^4.*y.^3),      sum(x.^8),         sum(x.^7.*y),         sum(x.^6.*y.^2),        sum(x.^5.*y.^3),     sum(x.^4.*y.^4),        sum(x.^9),         sum(x.^8.*y),         sum(x.^7.*y.^2),        sum(x.^6.*y.^3),        sum(x.^5.*y.^4),   sum(x.^4.*y.^5);
        sum((x.^3).*y) ,      sum(x.^4.*y),            sum(x.^3.*y.^2),       sum(x.^5.*y),         sum(x.^4.*y.^2),        sum(x.^3.*y.^3),     sum(x.^6.*y),       sum(x.^5.*y.^2),    sum(x.^4.*y.^3),      sum(x.^3.*y.^4),      sum(x.^7.*y),      sum(x.^6.*y.^2),      sum(x.^5.*y.^3),        sum(x.^4.*y.^4),     sum(x.^3.*y.^5),        sum(x.^8.*y),      sum(x.^7.*y.^2),       sum(x.^6.*y.^3),        sum(x.^5.*y.^4),        sum(x.^4.*y.^5),   sum(x.^3.*y.^6);
        sum(x.^2.*y.^2) ,     sum(x.^3.*y.^2),         sum(x.^2.*y.^3),       sum(x.^4.*y.^2),      sum(x.^3.*y.^3),        sum(x.^2.*y.^4),     sum(x.^5.*y.^2),    sum(x.^4.*y.^3),    sum(x.^3.*y.^4),      sum(x.^2.*y.^5),      sum(x.^6.*y.^2),   sum(x.^5.*y.^3),      sum(x.^4.*y.^4),        sum(x.^3.*y.^5),     sum(x.^2.*y.^6),         sum(x.^7.*y.^2),    sum(x.^6.*y.^3),       sum(x.^5.*y.^4),        sum(x.^4.*y.^5),        sum(x.^3.*y.^6),   sum(x.^2.*y.^7);
        sum(x.*y.^3) ,        sum(x.^2.*y.^3),         sum(x.*y.^4),          sum(x.^3.*y.^3),      sum(x.^2.*y.^4),        sum(x.*y.^5),        sum(x.^4.*y.^3),    sum(x.^3.*y.^4),    sum(x.^2.*y.^5),      sum(x.*y.^6),         sum(x.^5.*y.^3),   sum(x.^4.*y.^4),      sum(x.^3.*y.^5),        sum(x.^2.*y.^6),     sum(x.*y.^7),           sum(x.^6.*y.^3),    sum(x.^5.*y.^4),       sum(x.^4.*y.^5),        sum(x.^3.*y.^6),        sum(x.^2.*y.^7),   sum(x.*y.^8);
        sum(y.^4) ,           sum(x.*y.^4),            sum(y.^5),             sum(x.^2.*y.^4),      sum(x.*y.^5),           sum(y.^6),           sum(x.^3.*y.^4),    sum(x.^2.*y.^5),    sum(x.*y.^6),         sum(y.^7),            sum(x.^4.*y.^4),   sum(x.^3.*y.^5),      sum(x.^2.*y.^6),        sum(x.*y.^7),        sum(y.^8),              sum(x.^5.*y.^4),    sum(x.^4.*y.^5),       sum(x.^3.*y.^6),        sum(x.^2.*y.^7),        sum(x.*y.^8),      sum(y.^9);
        sum(x.^5) ,           sum(x.^6),               sum(x.^5.*y),          sum(x.^7),            sum(x.^6.*y),           sum(x.^5.*y.^2),     sum(x.^8),          sum(x.^7.*y),       sum(x.^6.*y.^2),      sum(x.^5.*y.^3),      sum(x.^9),         sum(x.^8.*y),         sum(x.^7.*y.^2),        sum(x.^6.*y.^3),     sum(x.^5.*y.^4),        sum(x.^10),        sum(x.^9.*y),         sum(x.^8.*y.^2),        sum(x.^7.*y.^3),        sum(x.^6.*y.^4),   sum(x.^5.*y.^5);
        sum((x.^4).*y) ,      sum(x.^5.*y),            sum(x.^4.*y.^2),       sum(x.^6.*y),         sum(x.^5.*y.^2),        sum(x.^4.*y.^3),     sum(x.^7.*y),       sum(x.^6.*y.^2),    sum(x.^5.*y.^3),      sum(x.^4.*y.^4),      sum(x.^8.*y),      sum(x.^7.*y.^2),      sum(x.^6.*y.^3),        sum(x.^5.*y.^4),     sum(x.^4.*y.^5),        sum(x.^9.*y),      sum(x.^8.*y.^2),       sum(x.^7.*y.^3),        sum(x.^6.*y.^4),        sum(x.^5.*y.^5),   sum(x.^4.*y.^6);
        sum(x.^3.*y.^2) ,     sum(x.^4.*y.^2),         sum(x.^3.*y.^3),       sum(x.^5.*y.^2),      sum(x.^4.*y.^3),        sum(x.^3.*y.^4),     sum(x.^6.*y.^2),    sum(x.^5.*y.^3),    sum(x.^4.*y.^4),      sum(x.^3.*y.^5),      sum(x.^7.*y.^2),   sum(x.^6.*y.^3),      sum(x.^5.*y.^4),        sum(x.^4.*y.^5),     sum(x.^3.*y.^6),         sum(x.^8.*y.^2),    sum(x.^7.*y.^3),       sum(x.^6.*y.^4),        sum(x.^5.*y.^5),        sum(x.^4.*y.^6),   sum(x.^3.*y.^7);
        sum(x.^2.*y.^3) ,     sum(x.^3.*y.^3),         sum(x.^2.*y.^4),        sum(x.^4.*y.^3),      sum(x.^3.*y.^4),        sum(x.^2.*y.^5),     sum(x.^5.*y.^3),    sum(x.^4.*y.^4),    sum(x.^3.*y.^5),      sum(x.^2.*y.^6),       sum(x.^6.*y.^3),   sum(x.^5.*y.^4),      sum(x.^4.*y.^5),        sum(x.^3.*y.^6),     sum(x.^2.*y.^7),         sum(x.^7.*y.^3),    sum(x.^6.*y.^4),       sum(x.^5.*y.^5),        sum(x.^4.*y.^6),        sum(x.^3.*y.^7),   sum(x.^2.*y.^8);
        sum(x.*y.^4) ,        sum(x.^2.*y.^4),         sum(x.*y.^5),          sum(x.^3.*y.^4),      sum(x.^2.*y.^5),        sum(x.*y.^6),        sum(x.^4.*y.^4),    sum(x.^3.*y.^5),    sum(x.^2.*y.^6),      sum(x.*y.^7),         sum(x.^5.*y.^4),   sum(x.^4.*y.^5),      sum(x.^3.*y.^6),        sum(x.^2.*y.^7),     sum(x.*y.^8),           sum(x.^6.*y.^4),    sum(x.^5.*y.^5),       sum(x.^4.*y.^6),        sum(x.^3.*y.^7),        sum(x.^2.*y.^8),   sum(x.*y.^9);
        sum(y.^5) ,           sum(x.*y.^5),            sum(y.^6),             sum(x.^2.*y.^5),      sum(x.*y.^6),           sum(y.^7),           sum(x.^3.*y.^5),    sum(x.^2.*y.^6),    sum(x.*y.^7),         sum(y.^8),            sum(x.^4.*y.^5),   sum(x.^3.*y.^6),      sum(x.^2.*y.^7),        sum(x.*y.^8),        sum(y.^9),              sum(x.^5.*y.^5),    sum(x.^4.*y.^6),       sum(x.^3.*y.^7),        sum(x.^2.*y.^8),        sum(x.*y.^9),      sum(y.^10);
        ];
    
    BX=[
        sum(lilun_x);
        sum(lilun_x.*x);
        sum(lilun_x.*y);
        sum(lilun_x.*x.*x);
        sum(lilun_x.*x.*y);
        sum(lilun_x.*y.*y);
        sum(lilun_x.*x.^3);
        sum(lilun_x.*x.*x.*y);
        sum(lilun_x.*x.*y.*y);
        sum(lilun_x.*y.^3);
        sum(lilun_x.*x.^4);
        sum(lilun_x.*x.^3.*y);
        sum(lilun_x.*x.^2.*y.^2);
        sum(lilun_x.*x.*y.^3);
        sum(lilun_x.*y.^4);
        sum(lilun_x.*x.^5);
        sum(lilun_x.*x.^4.*y);
        sum(lilun_x.*x.^3.*y.^2);
        sum(lilun_x.*x.^2.*y.^3);
        sum(lilun_x.*x.*y.^4);
        sum(lilun_x.*y.^5);
        ];
    
    BY=[
        sum(lilun_y);
        sum(lilun_y.*x);
        sum(lilun_y.*y);
        sum(lilun_y.*x.*x);
        sum(lilun_y.*x.*y);
        sum(lilun_y.*y.*y);
        sum(lilun_y.*x.^3);
        sum(lilun_y.*x.*x.*y);
        sum(lilun_y.*x.*y.*y);
        sum(lilun_y.*y.^3);
        sum(lilun_y.*x.^4);
        sum(lilun_y.*x.^3.*y);
        sum(lilun_y.*x.^2.*y.^2);
        sum(lilun_y.*x.*y.^3);
        sum(lilun_y.*y.^4);
        sum(lilun_y.*x.^5);
        sum(lilun_y.*x.^4.*y);
        sum(lilun_y.*x.^3.*y.^2);
        sum(lilun_y.*x.^2.*y.^3);
        sum(lilun_y.*x.*y.^4);
        sum(lilun_y.*y.^5);
        ];
    
    
    
elseif biaoding==56;
    
    A=[
        Num ,                   sum(x),                  sum(y),                sum(x.*x),            sum(x.*y) ,             sum(y.*y),           sum(x.^3),          sum(x.^2.*y),       sum(y.^2.*x),         sum(y.^3),            sum(x.^4),         sum(x.^3.*y),         sum(x.^2.*y.^2),        sum(x.*y.^3),        sum(y.^4),              sum(x.^5),         sum(x.^4.*y),         sum(x.^3.*y.^2),        sum(x.^2.*y.^3),        sum(x.*y.^4),      sum(y.^5),      sum(x.^6),    sum((x.^5).*y) ,      sum((x.^4).*y.^2) ,   sum(x.^3.*y.^3) ,       sum(x.^2.*y.^4) ,     sum(x.*y.^5) ,      sum(y.^6) ;
        sum(x),               sum(x.*x),               sum(x.*y) ,            sum(x.^3),            sum((x.^2).*y),         sum((y.^2).*x),      sum(x.^4),          sum(x.^3.*y),       sum(x.^2.*y.^2),      sum(x.*y.^3),         sum(x.^5),         sum(x.^4.*y),         sum(x.^3.*y.^2),        sum(x.^2.*y.^3),     sum(x.*y.^4),           sum(x.^6),         sum(x.^5.*y),         sum(x.^4.*y.^2),        sum(x.^3.*y.^3),        sum(x.^2.*y.^4),   sum(x.*y.^5),             sum(x.^7),     sum(x.^6.*y),        sum(x.^5.*y.^2),     sum(x.^4.*y.^3),        sum(x.^3.*y.^4),      sum(x.^2.*y.^5),    sum(x.*y.^6);
        sum(y) ,              sum(y.*x),               sum(y.*y) ,            sum((x.^2).*y) ,      sum(x.*(y.^2)) ,        sum(y.^3),           sum(x.^3.*y),       sum(x.^2.*y.^2),    sum(x.*y.^3),         sum(y.^4),            sum(x.^4.*y),      sum(x.^3.*y.^2),      sum(x.^2.*y.^3),        sum(x.*y.^4),        sum(y.^5),              sum(x.^5.*y),      sum(x.^4.*y.^2),       sum(x.^3.*y.^3),        sum(x.^2.*y.^4),        sum(x.*y.^5),      sum(y.^6),         sum(x.^6.*y),  sum(x.^5.*y.^2),     sum(x.^4.*y.^3),     sum(x.^3.*y.^4),        sum(x.^2.*y.^5),     sum(x.*y.^6),         sum(y.^7);
        sum(x.*x),            sum(x.^3),               sum((x.^2).*y),        sum(x.^4)  ,          sum((x.^3).*y) ,        sum((x.^2).*(y.^2)), sum(x.^5),          sum(x.^4.*y),       sum(x.^3.*y.^2),      sum(x.^2.*y.^3),      sum(x.^6),         sum(x.^5.*y),         sum(x.^4.*y.^2),        sum(x.^3.*y.^3),     sum(x.^2.*y.^4),        sum(x.^7),         sum(x.^6.*y),         sum(x.^5.*y.^2),        sum(x.^4.*y.^3),        sum(x.^3.*y.^4),   sum(x.^2.*y.^5),       sum(x.^8),     sum(x.^7.*y),        sum(x.^6.*y.^2),    sum(x.^5.*y.^3),          sum(x.^4.*y.^4),    sum(x.^3.*y.^5),     sum(x.^2.*y.^6);
        sum(x.*y),            sum((x.^2).*y),          sum(x.*(y.^2)),        sum((x.^3).*y),       sum((x.^2).*(y.^2)) ,   sum(x.*(y.^3)),      sum(x.^4.*y),       sum(x.^3.*y.^2),    sum(x.^2.*y.^3),      sum(x.*(y.^4)),       sum(x.^5.*y),      sum(x.^4.*y.^2),      sum(x.^3.*y.^3),        sum(x.^2.*y.^4),     sum(x.*y.^5),           sum(x.^6.*y),      sum(x.^5.*y.^2),       sum(x.^4.*y.^3),        sum(x.^3.*y.^4),        sum(x.^2.*y.^5),   sum(x.*y.^6),     sum(x.^7.*y),  sum(x.^6.*y.^2),     sum(x.^5.*y.^3),    sum(x.^4.*y.^4),          sum(x.^3.*y.^5),   sum(x.^2.*y.^6),      sum(x.*y.^7);
        sum(y.*y),            sum((y.^2).*x),          sum(y.^3) ,            sum((x.^2).*(y.^2)),  sum((y.^3).*x) ,        sum(y.^4),           sum(x.^3.*y.^2),    sum(x.^2.*y.^3),    sum(x.*(y.^4)),       sum(y.^5),            sum(x.^4.*y.^2),   sum(x.^3.*y.^3),      sum(x.^2.*y.^4),        sum(x.*y.^5),        sum(y.^6),              sum(x.^5.*y.^2),    sum(x.^4.*y.^3),       sum(x.^3.*y.^4),        sum(x.^2.*y.^5),        sum(x.*y.^6),      sum(y.^7),     sum(x.^6.*y.^2), sum(x.^5.*y.^3),     sum(x.^4.*y.^4),      sum(x.^3.*y.^5),         sum(x.^2.*y.^6),     sum(x.*y.^7),          sum(y.^8);
        sum(x.^3),            sum(x.^4),               sum((x.^3).*y) ,       sum(x.^5),            sum(x.^4.*y),           sum(x.^3.*y.^2),     sum(x.^6),          sum(x.^5.*y),       sum(x.^4.*y.^2),      sum(x.^3.*y.^3),      sum(x.^7),         sum(x.^6.*y),         sum(x.^5.*y.^2),        sum(x.^4.*y.^3),     sum(x.^3.*y.^4),        sum(x.^8),         sum(x.^7.*y),         sum(x.^6.*y.^2),        sum(x.^5.*y.^3),        sum(x.^4.*y.^4),   sum(x.^3.*y.^5),    sum(x.^9),      sum(x.^8.*y),        sum(x.^7.*y.^2),    sum(x.^6.*y.^3),         sum(x.^5.*y.^4),   sum(x.^4.*y.^5),       sum(x.^3.*y.^6);
        sum((x.^2).*y),       sum((x.^3).*y) ,         sum((x.^2).*(y.^2)),   sum(x.^4.*y),         sum(x.^3.*y.^2),        sum(x.^2.*y.^3),     sum(x.^5.*y),       sum(x.^4.*y.^2),    sum(x.^3.*y.^3),      sum(x.^2.*y.^4),      sum(x.^6.*y),      sum(x.^5.*y.^2),      sum(x.^4.*y.^3),        sum(x.^3.*y.^4),     sum(x.^2.*y.^5),        sum(x.^7.*y),      sum(x.^6.*y.^2),       sum(x.^5.*y.^3),        sum(x.^4.*y.^4),        sum(x.^3.*y.^5),   sum(x.^2.*y.^6),      sum(x.^8.*y),    sum(x.^7.*y.^2),    sum(x.^6.*y.^3),    sum(x.^5.*y.^4),          sum(x.^4.*y.^5),  sum(x.^3.*y.^6),       sum(x.^2.*y.^7);
        sum(x.*(y.^2)) ,      sum((x.^2).*(y.^2)),     sum(x.*(y.^3)),        sum(x.^3.*y.^2),      sum(x.^2.*y.^3),        sum(x.*(y.^4)),      sum(x.^4.*y.^2),    sum(x.^3.*y.^3),    sum(x.^2.*y.^4),      sum(x.*y.^5),         sum(x.^5.*y.^2),   sum(x.^4.*y.^3),      sum(x.^3.*y.^4),        sum(x.^2.*y.^5),     sum(x.*y.^6),           sum(x.^6.*y.^2),    sum(x.^5.*y.^3),       sum(x.^4.*y.^4),        sum(x.^3.*y.^5),        sum(x.^2.*y.^6),   sum(x.*y.^7),    sum(x.^7.*y.^2), sum(x.^6.*y.^3),    sum(x.^5.*y.^4),    sum(x.^4.*y.^5),          sum(x.^3.*y.^6),  sum(x.^2.*y.^7),     sum(x.*y.^8);
        sum(y.^3),            sum(x.*y.^3),            sum(y.^4),             sum(x.^2.*y.^3),      sum(x.*(y.^4)),         sum(y.^5),           sum(x.^3.*y.^3),    sum(x.^2.*y.^4),    sum(x.*y.^5),         sum(y.^6),            sum(x.^4.*y.^3),   sum(x.^3.*y.^4),      sum(x.^2.*y.^5),        sum(x.*y.^6),        sum(y.^7),              sum(x.^5.*y.^3),    sum(x.^4.*y.^4),       sum(x.^3.*y.^5),        sum(x.^2.*y.^6),        sum(x.*y.^7),      sum(y.^8),     sum(x.^6.*y.^3), sum(x.^5.*y.^4),   sum(x.^4.*y.^5),   sum(x.^3.*y.^6),          sum(x.^2.*y.^7),  sum(x.*y.^8),         sum(y.^9);
        sum(x.^4) ,           sum(x.^5),               sum(x.^4.*y),          sum(x.^6),            sum(x.^5.*y),           sum(x.^4.*y.^2),     sum(x.^7),          sum(x.^6.*y),       sum(x.^5.*y.^2),      sum(x.^4.*y.^3),      sum(x.^8),         sum(x.^7.*y),         sum(x.^6.*y.^2),        sum(x.^5.*y.^3),     sum(x.^4.*y.^4),        sum(x.^9),         sum(x.^8.*y),         sum(x.^7.*y.^2),        sum(x.^6.*y.^3),        sum(x.^5.*y.^4),   sum(x.^4.*y.^5),      sum(x.^10),      sum(x.^9.*y),      sum(x.^8.*y.^2),   sum(x.^7.*y.^3),          sum(x.^6.*y.^4), sum(x.^5.*y.^5),       sum(x.^4.*y.^6);
        sum((x.^3).*y) ,      sum(x.^4.*y),            sum(x.^3.*y.^2),       sum(x.^5.*y),         sum(x.^4.*y.^2),        sum(x.^3.*y.^3),     sum(x.^6.*y),       sum(x.^5.*y.^2),    sum(x.^4.*y.^3),      sum(x.^3.*y.^4),      sum(x.^7.*y),      sum(x.^6.*y.^2),      sum(x.^5.*y.^3),        sum(x.^4.*y.^4),     sum(x.^3.*y.^5),        sum(x.^8.*y),      sum(x.^7.*y.^2),       sum(x.^6.*y.^3),        sum(x.^5.*y.^4),        sum(x.^4.*y.^5),   sum(x.^3.*y.^6),       sum(x.^9.*y),   sum(x.^8.*y.^2),    sum(x.^7.*y.^3),   sum(x.^6.*y.^4),           sum(x.^5.*y.^5),sum(x.^4.*y.^6),      sum(x.^3.*y.^7);
        sum(x.^2.*y.^2) ,     sum(x.^3.*y.^2),         sum(x.^2.*y.^3),       sum(x.^4.*y.^2),      sum(x.^3.*y.^3),        sum(x.^2.*y.^4),     sum(x.^5.*y.^2),    sum(x.^4.*y.^3),    sum(x.^3.*y.^4),      sum(x.^2.*y.^5),      sum(x.^6.*y.^2),   sum(x.^5.*y.^3),      sum(x.^4.*y.^4),        sum(x.^3.*y.^5),     sum(x.^2.*y.^6),         sum(x.^7.*y.^2),    sum(x.^6.*y.^3),       sum(x.^5.*y.^4),        sum(x.^4.*y.^5),        sum(x.^3.*y.^6),   sum(x.^2.*y.^7),     sum(x.^8.*y.^2), sum(x.^7.*y.^3),   sum(x.^6.*y.^4),   sum(x.^5.*y.^5),        sum(x.^4.*y.^6),   sum(x.^3.*y.^7),        sum(x.^2.*y.^8);
        sum(x.*y.^3) ,        sum(x.^2.*y.^3),         sum(x.*y.^4),          sum(x.^3.*y.^3),      sum(x.^2.*y.^4),        sum(x.*y.^5),        sum(x.^4.*y.^3),    sum(x.^3.*y.^4),    sum(x.^2.*y.^5),      sum(x.*y.^6),         sum(x.^5.*y.^3),   sum(x.^4.*y.^4),      sum(x.^3.*y.^5),        sum(x.^2.*y.^6),     sum(x.*y.^7),           sum(x.^6.*y.^3),    sum(x.^5.*y.^4),       sum(x.^4.*y.^5),        sum(x.^3.*y.^6),        sum(x.^2.*y.^7),   sum(x.*y.^8),    sum(x.^7.*y.^3),   sum(x.^6.*y.^4),  sum(x.^5.*y.^5),   sum(x.^4.*y.^6),      sum(x.^3.*y.^7),    sum(x.^2.*y.^8),        sum(x.*y.^9);
        sum(y.^4) ,           sum(x.*y.^4),            sum(y.^5),             sum(x.^2.*y.^4),      sum(x.*y.^5),           sum(y.^6),           sum(x.^3.*y.^4),    sum(x.^2.*y.^5),    sum(x.*y.^6),         sum(y.^7),            sum(x.^4.*y.^4),   sum(x.^3.*y.^5),      sum(x.^2.*y.^6),        sum(x.*y.^7),        sum(y.^8),              sum(x.^5.*y.^4),    sum(x.^4.*y.^5),       sum(x.^3.*y.^6),        sum(x.^2.*y.^7),        sum(x.*y.^8),      sum(y.^9),        sum(x.^6.*y.^4), sum(x.^5.*y.^5),   sum(x.^4.*y.^6),    sum(x.^3.*y.^7),     sum(x.^2.*y.^8),      sum(x.*y.^9),        sum(y.^10);
        sum(x.^5) ,           sum(x.^6),               sum(x.^5.*y),          sum(x.^7),            sum(x.^6.*y),           sum(x.^5.*y.^2),     sum(x.^8),          sum(x.^7.*y),       sum(x.^6.*y.^2),      sum(x.^5.*y.^3),      sum(x.^9),         sum(x.^8.*y),         sum(x.^7.*y.^2),        sum(x.^6.*y.^3),     sum(x.^5.*y.^4),        sum(x.^10),        sum(x.^9.*y),         sum(x.^8.*y.^2),        sum(x.^7.*y.^3),        sum(x.^6.*y.^4),   sum(x.^5.*y.^5),     sum(x.^11),      sum(x.^10.*y),     sum(x.^9.*y.^2),   sum(x.^8.*y.^3),      sum(x.^7.*y.^4),      sum(x.^6.*y.^5),    sum(x.^5.*y.^6);
        sum((x.^4).*y) ,      sum(x.^5.*y),            sum(x.^4.*y.^2),       sum(x.^6.*y),         sum(x.^5.*y.^2),        sum(x.^4.*y.^3),     sum(x.^7.*y),       sum(x.^6.*y.^2),    sum(x.^5.*y.^3),      sum(x.^4.*y.^4),      sum(x.^8.*y),      sum(x.^7.*y.^2),      sum(x.^6.*y.^3),        sum(x.^5.*y.^4),     sum(x.^4.*y.^5),        sum(x.^9.*y),      sum(x.^8.*y.^2),       sum(x.^7.*y.^3),        sum(x.^6.*y.^4),        sum(x.^5.*y.^5),   sum(x.^4.*y.^6),     sum(x.^10.*y),  sum(x.^9.*y.^2),  sum(x.^8.*y.^3),  sum(x.^7.*y.^4),      sum(x.^6.*y.^5),     sum(x.^5.*y.^6),     sum(x.^4.*y.^7);
        sum(x.^3.*y.^2) ,     sum(x.^4.*y.^2),         sum(x.^3.*y.^3),       sum(x.^5.*y.^2),      sum(x.^4.*y.^3),        sum(x.^3.*y.^4),     sum(x.^6.*y.^2),    sum(x.^5.*y.^3),    sum(x.^4.*y.^4),      sum(x.^3.*y.^5),      sum(x.^7.*y.^2),   sum(x.^6.*y.^3),      sum(x.^5.*y.^4),        sum(x.^4.*y.^5),     sum(x.^3.*y.^6),         sum(x.^8.*y.^2),    sum(x.^7.*y.^3),       sum(x.^6.*y.^4),        sum(x.^5.*y.^5),        sum(x.^4.*y.^6),   sum(x.^3.*y.^7),       sum(x.^9.*y.^2),	sum(x.^8.*y.^3),   sum(x.^7.*y.^4), sum(x.^6.*y.^5),      sum(x.^5.*y.^6),     sum(x.^4.*y.^7),       sum(x.^3.*y.^8);
        sum(x.^2.*y.^3) ,     sum(x.^3.*y.^3),         sum(x.^2.*y.^4),        sum(x.^4.*y.^3),      sum(x.^3.*y.^4),        sum(x.^2.*y.^5),     sum(x.^5.*y.^3),    sum(x.^4.*y.^4),    sum(x.^3.*y.^5),      sum(x.^2.*y.^6),       sum(x.^6.*y.^3),   sum(x.^5.*y.^4),      sum(x.^4.*y.^5),        sum(x.^3.*y.^6),     sum(x.^2.*y.^7),         sum(x.^7.*y.^3),    sum(x.^6.*y.^4),       sum(x.^5.*y.^5),        sum(x.^4.*y.^6),        sum(x.^3.*y.^7),   sum(x.^2.*y.^8),     sum(x.^8.*y.^3), sum(x.^7.*y.^4),   sum(x.^6.*y.^5), sum(x.^5.*y.^6),      sum(x.^4.*y.^7),    sum(x.^3.*y.^8),       sum(x.^2.*y.^9);
        sum(x.*y.^4) ,        sum(x.^2.*y.^4),         sum(x.*y.^5),          sum(x.^3.*y.^4),      sum(x.^2.*y.^5),        sum(x.*y.^6),        sum(x.^4.*y.^4),    sum(x.^3.*y.^5),    sum(x.^2.*y.^6),      sum(x.*y.^7),         sum(x.^5.*y.^4),   sum(x.^4.*y.^5),      sum(x.^3.*y.^6),        sum(x.^2.*y.^7),     sum(x.*y.^8),           sum(x.^6.*y.^4),    sum(x.^5.*y.^5),       sum(x.^4.*y.^6),        sum(x.^3.*y.^7),        sum(x.^2.*y.^8),   sum(x.*y.^9),         sum(x.^7.*y.^4),   sum(x.^6.*y.^5),   sum(x.^5.*y.^6), sum(x.^4.*y.^7),     sum(x.^3.*y.^8),      sum(x.^2.*y.^9),      sum(x.*y.^10);
        sum(y.^5) ,           sum(x.*y.^5),            sum(y.^6),             sum(x.^2.*y.^5),      sum(x.*y.^6),           sum(y.^7),           sum(x.^3.*y.^5),    sum(x.^2.*y.^6),    sum(x.*y.^7),         sum(y.^8),            sum(x.^4.*y.^5),   sum(x.^3.*y.^6),      sum(x.^2.*y.^7),        sum(x.*y.^8),        sum(y.^9),              sum(x.^5.*y.^5),    sum(x.^4.*y.^6),       sum(x.^3.*y.^7),        sum(x.^2.*y.^8),        sum(x.*y.^9),      sum(y.^10),            sum(x.^6.*y.^5), sum(x.^5.*y.^6),   sum(x.^4.*y.^7),  sum(x.^3.*y.^8),     sum(x.^2.*y.^9),     sum(x.*y.^10),          sum(y.^11);
        sum(x.^6),          sum(x.^7),            sum(x.^6.*y),         sum(x.^8),            sum(x.^7.*y),         sum(x.^6.*y.^2),    sum(x.^9),      sum(x.^8.*y),         sum(x.^7.*y.^2), sum(x.^6.*y.^3),     sum(x.^10),        sum(x.^9.*y),      sum(x.^8.*y.^2),        sum(x.^7.*y.^3),     sum(x.^6.*y.^4),     sum(x.^11),       sum(x.^10.*y),         sum(x.^9.*y.^2),     sum(x.^8.*y.^3),        sum(x.^7.*y.^4),     sum(x.^6.*y.^5),           sum(x.^12),        sum(x.^11.*y),  sum(x.^10.*y.^2),sum(x.^9.*y.^3),         sum(x.^8.*y.^4),     sum(x.^7.*y.^5),         sum(x.^6.*y.^6);
        sum((x.^5).*y) ,     sum(x.^6.*y),           sum(x.^5.*y.^2),      sum(x.^7.*y),     sum(x.^6.*y.^2),         sum(x.^5.*y.^3),   sum(x.^8.*y),     sum(x.^7.*y.^2),   sum(x.^6.*y.^3), sum(x.^5.*y.^4),     sum(x.^9.*y),      sum(x.^8.*y.^2),      sum(x.^7.*y.^3),     sum(x.^6.*y.^4),     sum(x.^5.*y.^5),     sum(x.^10.*y),    sum(x.^9.*y.^2),       sum(x.^8.*y.^3),     sum(x.^7.*y.^4),        sum(x.^6.*y.^5),     sum(x.^5.*y.^6),          sum(x.^11.*y),     sum(x.^10.*y.^2),  sum(x.^9.*y.^3),sum(x.^8.*y.^4),          sum(x.^7.*y.^5), sum(x.^6.*y.^6),       sum(x.^5.*y.^7);
        sum((x.^4).*y.^2) ,   sum(x.^5.*y.^2),     sum(x.^4.*y.^3),          sum(x.^6.*y.^2),   sum(x.^5.*y.^3),        sum(x.^4.*y.^4),   sum(x.^7.*y.^2), sum(x.^6.*y.^3),  sum(x.^5.*y.^4), sum(x.^4.*y.^5),     sum(x.^8.*y.^2),    sum(x.^7.*y.^3),      sum(x.^6.*y.^4),    sum(x.^5.*y.^5),      sum(x.^4.*y.^6),    sum(x.^9.*y.^2),  sum(x.^8.*y.^3),       sum(x.^7.*y.^4),     sum(x.^6.*y.^5),        sum(x.^5.*y.^6),     sum(x.^4.*y.^7),          sum(x.^10.*y.^2),    sum(x.^9.*y.^3),  sum(x.^8.*y.^4),sum(x.^7.*y.^5),            sum(x.^6.*y.^6), sum(x.^5.*y.^7),      sum(x.^4.*y.^8);
        sum(x.^3.*y.^3) ,    sum(x.^4.*y.^3),    sum(x.^3.*y.^4),          sum(x.^5.*y.^3),      sum(x.^4.*y.^4),     sum(x.^3.*y.^5),   sum(x.^6.*y.^3),    sum(x.^5.*y.^4), sum(x.^4.*y.^5), sum(x.^3.*y.^6),     sum(x.^7.*y.^3),    sum(x.^6.*y.^4),      sum(x.^5.*y.^5),    sum(x.^4.*y.^6),     sum(x.^3.*y.^7),     sum(x.^8.*y.^3),  sum(x.^7.*y.^4),       sum(x.^6.*y.^5),     sum(x.^5.*y.^6),        sum(x.^4.*y.^7),     sum(x.^3.*y.^8),        sum(x.^9.*y.^3),      sum(x.^8.*y.^4),  sum(x.^7.*y.^5),sum(x.^6.*y.^6),         sum(x.^5.*y.^7), sum(x.^4.*y.^8),        sum(x.^3.*y.^9);
        sum(x.^2.*y.^4) ,   sum(x.^3.*y.^4),       sum(x.^2.*y.^5),          sum(x.^4.*y.^4),   sum(x.^3.*y.^5),         sum(x.^2.*y.^6),   sum(x.^5.*y.^4),  sum(x.^4.*y.^5),sum(x.^3.*y.^6), sum(x.^2.*y.^7),     sum(x.^6.*y.^4),    sum(x.^5.*y.^5),       sum(x.^4.*y.^6),   sum(x.^3.*y.^7),     sum(x.^2.*y.^8),     sum(x.^7.*y.^4),  sum(x.^6.*y.^5),       sum(x.^5.*y.^6),     sum(x.^4.*y.^7),        sum(x.^3.*y.^8),     sum(x.^2.*y.^9),        sum(x.^8.*y.^4),     sum(x.^7.*y.^5),  sum(x.^6.*y.^6),sum(x.^5.*y.^7),         sum(x.^4.*y.^8), sum(x.^3.*y.^9),          sum(x.^2.*y.^10);
        sum(x.*y.^5) ,      sum(x.^2.*y.^5),        sum(x.*y.^6),         sum(x.^3.*y.^5),	    sum(x.^2.*y.^6),        sum(x.*y.^7),    sum(x.^4.*y.^5),  sum(x.^3.*y.^6),  sum(x.^2.*y.^7), sum(x.*y.^8),       sum(x.^5.*y.^5),    sum(x.^4.*y.^6),       sum(x.^3.*y.^7),   sum(x.^2.*y.^8),     sum(x.*y.^9),        sum(x.^6.*y.^5),  sum(x.^5.*y.^6),       sum(x.^4.*y.^7),     sum(x.^3.*y.^8),        sum(x.^2.*y.^9),     sum(x.*y.^10),       sum(x.^7.*y.^5),      sum(x.^6.*y.^6),  sum(x.^5.*y.^7),sum(x.^4.*y.^8),          sum(x.^3.*y.^9), sum(x.^2.*y.^10),          sum(x.*y.^11);
        sum(y.^6) ,          sum(x.*y.^6),          sum(y.^7),             sum(x.^2.*y.^6),        sum(x.*y.^7),          sum(y.^8),     sum(x.^3.*y.^6),  sum(x.^2.*y.^7),  sum(x.*y.^8),     sum(y.^9),          sum(x.^4.*y.^6),    sum(x.^3.*y.^7),      sum(x.^2.*y.^8),    sum(x.*y.^9),       sum(y.^10),           sum(x.^5.*y.^6),  sum(x.^4.*y.^7),       sum(x.^3.*y.^8),     sum(x.^2.*y.^9),        sum(x.*y.^10),       sum(y.^11),            sum(x.^6.*y.^6),     sum(x.^5.*y.^7),  sum(x.^4.*y.^8),sum(x.^3.*y.^9),            sum(x.^2.*y.^10), sum(x.*y.^11),           sum(y.^12);
        ];
    BX=[
        sum(lilun_x);
        sum(lilun_x.*x);
        sum(lilun_x.*y);
        sum(lilun_x.*x.*x);
        sum(lilun_x.*x.*y);
        sum(lilun_x.*y.*y);
        sum(lilun_x.*x.^3);
        sum(lilun_x.*x.*x.*y);
        sum(lilun_x.*x.*y.*y);
        sum(lilun_x.*y.^3);
        sum(lilun_x.*x.^4);
        sum(lilun_x.*x.^3.*y);
        sum(lilun_x.*x.^2.*y.^2);
        sum(lilun_x.*x.*y.^3);
        sum(lilun_x.*y.^4);
        sum(lilun_x.*x.^5);
        sum(lilun_x.*x.^4.*y);
        sum(lilun_x.*x.^3.*y.^2);
        sum(lilun_x.*x.^2.*y.^3);
        sum(lilun_x.*x.*y.^4);
        sum(lilun_x.*y.^5);
        sum(lilun_x.*x.^6);
        sum(lilun_x.*x.^5.*y);
        sum(lilun_x.*x.^4.*y.^2);
        sum(lilun_x.*x.^3.*y.^3);
        sum(lilun_x.*x.^2.*y.^4);
        sum(lilun_x.*x.*y.^5);
        sum(lilun_x.*y.^6);
        ];
    
    BY=[
        sum(lilun_y);
        sum(lilun_y.*x);
        sum(lilun_y.*y);
        sum(lilun_y.*x.*x);
        sum(lilun_y.*x.*y);
        sum(lilun_y.*y.*y);
        sum(lilun_y.*x.^3);
        sum(lilun_y.*x.*x.*y);
        sum(lilun_y.*x.*y.*y);
        sum(lilun_y.*y.^3);
        sum(lilun_y.*x.^4);
        sum(lilun_y.*x.^3.*y);
        sum(lilun_y.*x.^2.*y.^2);
        sum(lilun_y.*x.*y.^3);
        sum(lilun_y.*y.^4);
        sum(lilun_y.*x.^5);
        sum(lilun_y.*x.^4.*y);
        sum(lilun_y.*x.^3.*y.^2);
        sum(lilun_y.*x.^2.*y.^3);
        sum(lilun_y.*x.*y.^4);
        sum(lilun_y.*y.^5);
        sum(lilun_y.*x.^6);
        sum(lilun_y.*x.^5.*y);
        sum(lilun_y.*x.^4.*y.^2);
        sum(lilun_y.*x.^3.*y.^3);
        sum(lilun_y.*x.^2.*y.^4);
        sum(lilun_y.*x.*y.^5);
        sum(lilun_y.*y.^6);
        ];
end;
return;

% function test()
% biaoding=56; % biaoding���Էֱ����56,42,30,20,12,6���Աȣ�
% load('test\data2.mat')
% load('test\data3.mat')
% x=aa(:,1);
% y=aa(:,2);
% lilun_x=hh(:,1);
% lilun_y=hh(:,2);
% [param_x,param_y,dblCoorX,dblCoorY,cha_x,cha_y,cha]=f_NiheParam(biaoding,x,y,lilun_x,lilun_y,'');
% return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function test5()
% biaoding=5;
% % x=[109;   2009;   2012;      744.1    ];
% % y=2048-[132.8;   135.9;  1699;   917.1   ];
% % lilun_x=[  -780.800000;  -243.200000;-243.200000; -601.600000   ]*1000;
% % lilun_y=[-376.894254;-376.894254;  -820.299259;  -598.596756    ]*1000;
% x=[2792;   1516;   1376;    2786    ];
% y=[2362;   2464;   1088;   1058   ];
% lilun_x=[ 473600; -325700;  -308600;  501300   ];
% lilun_y=[421200;421700;  -404000;  -375900    ];
% [param_x,param_y,dblCoorX,dblCoorY,cha_x,cha_y,cha]=f_NiheParam(biaoding,x,y,lilun_x,lilun_y,'');
% return;
