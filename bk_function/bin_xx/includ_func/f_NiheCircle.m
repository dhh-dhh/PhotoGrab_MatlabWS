function [x0,y0,r0,n1,n2] = NiheCircle(x,y,mytitle)
%function [x0,y0,r0,n1,n2] = f_NiheCircle(x,y,mytitle)
%[x0,y0,r0,n1,n2] = NiheCircle(x,y)
%[x0,y0,r0,n1,n2] = NiheCircle(x,y,mytitle)
%
%���������(x,y)�����Բ
%
%���룺    
%   x,y:       ��֪������
%   mytitle1�� �����ͼ����
%   mytitle2�� ���Բͼ����
%�����
%   x0,y0:     ���ԲԲ������
%   r0:        ���Բ�뾶
%   n1:        ����������
%   n2:        ʵ�ʽ�����ϵĵ������

 
% 2017.7.6  lzg start

if nargin < 2
    errordlg('ȱ���������');
    return;
end
if nargin < 3                        %�������<3ʱ ������ͼ
    ifdraw= 0;
else
    ifdraw = 1;
end

matrix_b=zeros(size(x(:),1),3);
matrix_b(:,1)=2*x;
matrix_b(:,2)=2*y;
matrix_b(:,3)=1;
matrix_a=x.^2+y.^2;
m=1;
matrix_a=matrix_a(:);
while m>0;
    m=0;
    result=matrix_b\matrix_a;
    x0=result(1);
    y0=result(2);
    r0=sqrt(result(3)+x0^2+y0^2);
    %%%%%%%%%%%%%ÿ���ֶȵ������Բ������뾶����ϰ뾶�Ƚ��޳���Ч��
    rr=sqrt((matrix_b(:,1)/2-x0).^2+(matrix_b(:,2)/2-y0).^2);
    nihe_c=std(rr);
    max_good=r0+nihe_c*3;
    min_good=r0-nihe_c*3;
    for i=size(rr(:),1):-1:1;
        if rr(i)>max_good || rr(i)<min_good;
            matrix_b(i,:)=[];
            matrix_a(i,:)=[];
            m=m+1;
        end;
    end;
end;
n1=size(x(:),1);
n2=size(matrix_a(:),1);

if ifdraw ==1
    subplot(2,1,1);
    plot(x(:),y(:),'r*');
    hold on;
    ezplot(@(x)(cos(x)*r0+x0),@(x)(sin(x)*r0+y0),[0,2*pi]);
    title(mytitle);
    for i = 1:size(x,2) 
        cha(i)=sqrt((x(i)-x0)^2+(y(i)-y0)^2)-r0;
    end
    subplot(2,1,2);
    plot(cha)
    title('�뾶��');
end
return;

% function  test=testdata()
% fpath='..\testdata\f_NiheCircle.mat';
% load(fpath);
% [nihe_x2,nihe_y2,nihe_r2]=NiheCircle(mean_x(:,1,1),mean_y(:,1,1));
% plot(mean_x(:),mean_y(:))
% hold on
% plot(nihe_x2,nihe_y2,'ro')
% hold off
