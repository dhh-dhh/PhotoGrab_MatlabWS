function [hough_space,hough_circle,para] = hough_circle_dot(px,py,step_r,step_angle,r_min,r_max,p)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input
% px py:�ȶ�������λ�ã�
% step_r:����Բ�뾶����
% step_angle:�ǶȲ�������λΪ����
% r_min:��СԲ�뾶
% r_max:���Բ�뾶
% p:��ֵ��0��1֮����� ͨ������ֵ���Եõ�ͼ��Բ��Բ�ĺͰ뾶
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output
% hough_space:�����ռ䣬h(a,b,r)��ʾԲ����(a,b)�뾶Ϊr��Բ�ϵĵ���
% hough_circl:��ֵͼ�񣬼�⵽��Բ
% para:��⵽��Բ��Բ�ġ��뾶
BW=zeros(6004,7920);
% min_x=-min(px)+100;min_y=-min(py)+100;
PXY=floor([px(:,1),py(:,1)]);
for i=1:size(PXY,1)
    BW(PXY(i,2),PXY(i,1))=1;
end
%  imshow(BW);

circleParaXYR=[];
para=[];
% m=6004;n=7920;
[m,n] = size(BW);
% [m,n] = size(PXY);%
size_r = round((r_max-r_min)/step_r)+1;%��������
size_angle = round(2*pi/step_angle);

hough_space = zeros(m,n,size_r);

[rows,cols] = find(BW);%���ҷ���Ԫ�ص���������
% rows=PXY(:,1);cols=PXY(:,2);
% [rows,cols] = PXY;%���ҷ���Ԫ�ص���������
ecount = size(PXY,1);%��������ĸ���

% Hough�任
% ��ͼ��ռ�(x,y)��Ӧ�������ռ�(a,b,r)

% a = x-r*cos(angle)
% b = y-r*sin(angle)
t1=0;t2=0;
for i=1:ecount
    for r=1:size_r %�뾶������
        for k=1:size_angle %��һ�����Ȱ�Բ���ȷ�
            a = round(rows(i)-(r_min+(r-1)*step_r)*cos(k*step_angle));
            t1=max(a,t1);
            b = round(cols(i)-(r_min+(r-1)*step_r)*sin(k*step_angle));
            t2=max(b,t2);
            if(a>0&a<=m&b>0&b<=n)
                hough_space(a,b,r) = hough_space(a,b,r)+1;%h(a,b,r)�����꣬Բ�ĺͰ뾶
            end
        end
    end
end


% ����������ֵ�ľۼ��㡣���ڶ��Բ�ļ�⣬��ֵҪ���Сһ�㣡ͨ������ֵ�������������Բ��Բ�ĺͰ뾶
max_para = max(max(max(hough_space)));%����ֵ���������������ֵ
index = find(hough_space>=max_para*p);%һ�������У����ҵ����д���max_para*p����λ��
% index = find(hough_space>0);%һ�������У����ҵ����д���max_para*p����λ��
length = size(index);%������ֵ�ĸ���
hough_circle = false(m,n);
%hough_circle = zeros(m,n);
%ͨ��λ����뾶��Բ�ġ�
for i=1:ecount
    for k=1:length
        par3 = floor(index(k)/(m*n))+1;
        par2 = floor((index(k)-(par3-1)*(m*n))/m)+1;
        par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m;
        if((rows(i)-par1)^2+(cols(i)-par2)^2<(r_min+(par3-1)*step_r)^2+5&&(rows(i)-par1)^2+(cols(i)-par2)^2>(r_min+(par3-1)*step_r)^2-5)
            hough_circle(rows(i),cols(i)) = true;   %����Բ
        end
    end
end

% �ӳ�����ֵ��ֵ�еõ�
for k=1:length
    par3 = floor(index(k)/(m*n))+1;%ȡ��
    par2 = floor((index(k)-(par3-1)*(m*n))/m)+1;
    par1 = index(k)-(par3-1)*(m*n)-(par2-1)*m;
    circleParaXYR = [circleParaXYR;par1,par2,par3];
    hough_circle(par1,par2)= true; %��ʱ�õ��ö�Բ�ĺͰ뾶����ͬ��Բ��Բ�Ĵ��ۼ��ö�㣬������Ϊ������Բ���Ǳ�׼��Բ
    %fprintf(1,'test1:Center %d %d \n',par1,par2);
end

%�����ڸ���Բ��Բ�Ĵ��ĵ�ȡƽ�����õ����ÿ��Բ�ľ�ȷԲ�ĺͰ뾶��
while size(circleParaXYR,1) >= 1
    num=1;
    XYR=[];
    temp1=circleParaXYR(1,1);
    temp2=circleParaXYR(1,2);
    temp3=circleParaXYR(1,3);
    c1=temp1;
    c2=temp2;
    c3=temp3;
    temp3= r_min+(temp3-1)*step_r;
    if size(circleParaXYR,1)>1
        for k=2:size(circleParaXYR,1)
            if (circleParaXYR(k,1)-temp1)^2+(circleParaXYR(k,2)-temp2)^2 > (temp3*2.3)^2
                XYR=[XYR;circleParaXYR(k,1),circleParaXYR(k,2),circleParaXYR(k,3)];  %����ʣ��Բ��Բ�ĺͰ뾶λ��
            else
                c1=c1+circleParaXYR(k,1);
                c2=c2+circleParaXYR(k,2);
                c3=c3+circleParaXYR(k,3);
                num=num+1;
            end
        end
    end
    %fprintf(1,'sum %d %d radius %d\n',c1,c2,r_min+(c3-1)*step_r);
    %     c1=round(c1/num);
    %     c2=round(c2/num);
    %     c3=round(c3/num);
    c1=c1/num;
    c2=c2/num;
    c3=c3/num;
    c3=r_min+(c3-1)*step_r;
    %fprintf(1,'num=%d\n',num)
    %fprintf(1,'Center %d %d radius %d\n',c1,c2,c3);
    para=[para;c1,c2,c3]; %�������Բ��Բ�ĺͰ뾶��ֵ
    circleParaXYR=XYR;
end
figure();
imshow(BW),title('hough')
hold on;
plot(para(:,2), para(:,1), 'r+');

for k = 1 : size(para, 1)
    t=0:0.01*pi:2*pi;
    x=cos(t).*para(k,3)+para(k,2);y=sin(t).*para(k,3)+para(k,1);
    plot(x,y,'r-');
end
% para(:,1)=para(:,1)-min_y;
% para(:,2)=para(:,2)-min_x;
