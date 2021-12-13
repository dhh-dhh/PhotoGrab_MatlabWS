function [x0,y0,r0] = f_NiheCircle_RF(x,y)
%function [x0,y0,r0,n1,n2] = f_NiheCircle(x,y,mytitle)
%[x0,y0,r0,n1,n2] = NiheCircle(x,y)
%[x0,y0,r0,n1,n2] = NiheCircle(x,y,mytitle)
%
%���������(x,y)�����Բ
%
%���룺    
%   x,y:       ��֪������
%   mytitle�� �����,���Բͼ����
%�����
%   x0,y0:     ���ԲԲ������
%   r0:        ���Բ�뾶
%   n1:        ����������
%   n2:        ʵ�ʽ�����ϵĵ������

if nargin < 2
    errordlg('ȱ���������');
    return;
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
end


