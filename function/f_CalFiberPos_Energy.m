function  [XY4,FiberEnergy] =f_CalFiberPos_Energy(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,FlagEnergy,FlagBackGround)
%function  [XYMN] =CalFiberPos(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,mytitle)
%�˵���ͨ������
%���ù����ķ��������λ��,����һ��ͼƬ�ϵĹ���λ�ã��õ�������λ�����ꡢ��λ�õĵ����Ҷ�ֵ�Լ�������,�Լ�������ߵ�����
%
%Input:
%   data:                       �ҶȾ���
%	intImageHeight = 2048;  	��Ƭ�߶�2048
%	intImageWidth  = 2048;      ��Ƭ����2048
%	intLightThreshold = 300;	������ֵ�ݶ�300
% 	intBkThreshold = 100;       ������ֵ�ݶ�100
%	nImageType =0;              0:����Ҫƫת    1����X�᷽��ת������2K���
%Output:
%   XY4(:,1) = XX          ����λ��x����
%	XY4(:,2) = YY          ����λ��y����
%	XY4(:,3) = MM          ÿ������λ�õ����Ҷ�ֵ
%	XY4(:,4) = Num         ÿ������λ��������
%   FiberEnergy

% 2013_06_10   start

% if nargin <5
%     errordlg('ȱ���������');
%     return
% end
% if nargin < 6                       %�������=6ʱ ������������
%     ifdraw = 0;
% else
%     ifdraw = 1;
% end

intCounter = 0;
NumDui=512*512;
m_nDui = zeros(3,NumDui);
for i=1:intImageHeight
    for j=1:intImageWidth
        if data(i,j) > intLightThreshold   %���ܴ���һ������
            sumRow=0;
            sumCol=0;
            SumGray=0;
            m_nTop = 1;
            m_nBottom = 1;
            mm = 0;
            m_nDui(1,m_nBottom) = i;
            m_nDui(2,m_nBottom) = j;
            m_nDui(3,m_nBottom) = data(i,j);
            data(i,j) = 0;
            m_nBottom = m_nBottom + 1;
            if m_nBottom > NumDui
                m_nBottom=1;
            end
            while m_nTop ~= m_nBottom
                p = m_nDui(1,m_nTop);
                q = m_nDui(2,m_nTop);
                g = m_nDui(3,m_nTop);
                if mm < g
                    mm=g;
                end
                sumRow = sumRow + p * g;      %���ؼ�Ȩx����ͣ�ȨֵΪ�Ҷ�ֵ
                sumCol = sumCol + q * g;      %���ؼ�Ȩy����ͣ�ȨֵΪ�Ҷ�ֵ
                SumGray = SumGray + g;        %���ػҶ�ֵ��
                m_nTop = m_nTop + 1;          %����ֵ��1
                if m_nTop > NumDui
                    m_nTop = 1;
                end
                m1 = p-1;
                if m1 < 1
                    m1 = 1;
                end
                m2 = p+1;
                if m2 > intImageHeight
                    m2 =intImageHeight;
                end
                n1 = q-1;
                if n1 < 1
                    n1=1;
                end
                n2 = q+1;
                if n2 > intImageWidth
                    n2=intImageWidth;
                end
                for  m=m1:m2                   %���ҵ���������������ɢ1������
                    for n=n1:n2
                        if data(m,n) > intBkThreshold
                            m_nDui(1,m_nBottom) = m;
                            m_nDui(2,m_nBottom) = n;
                            m_nDui(3,m_nBottom) = data(m,n);
                            data(m,n) = 0;
                            m_nBottom = m_nBottom + 1;
                            if m_nBottom > NumDui
                                m_nBottom = 1;
                            end
                        end
                    end
                end
            end
            intCounter = intCounter + 1;
            YY(intCounter) = sumRow / SumGray;            %��Ȩ�ͳ���Ȩ�͵�y->row
            XX(intCounter)= sumCol / SumGray;             %��Ȩ�ͳ���Ȩ�͵�x->col
            MM(intCounter) = mm;                          %���Ҷ�ֵ
            Num(intCounter) = m_nTop-1 ;                  %������
            
            if FlagBackGround==1
               Energy = m_nDui(3,1:(m_nTop-1))-intBkThreshold;
            elseif FlagBackGround==0
                Energy = m_nDui(3,1:(m_nTop-1));
            end
            if FlagEnergy==2
                Energy=Energy.^2;
            end
            FiberEnergy(intCounter,1)=sum(Energy); 
            
        end
    end
end

XY4(:,1) = XX(1:intCounter) ;%:col
XY4(:,2) = YY(1:intCounter) ;%:row
XY4(:,3) = MM(1:intCounter) ;
XY4(:,4) = Num(1:intCounter) ;

% if ifdraw == 1
%     plot(XY4(:,1),XY4(:,2),'*');
% end
return



% fn ='..\testdata\Image_2048.raw';
% intImageHeight = 2048;          %��Ƭ�߶�2048
% intImageWidth = 2048;           %��Ƭ����2048
% intLightThreshold = 300;        %������ֵ�ݶ�300
% intBkThreshold = 100;           %������ֵ�ݶ�100
% nImageType =1;                  %��X�᷽��ת������2K���
% ifdraw = 1;
% data =f_ReadImage(fn,intImageHeight,intImageWidth,nImageType,ifdraw);
% [XYMN] =f_CalFiberPos(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,ifdraw);



% fn = '..\test\image_xiangxian3.tif';
% intImageHeight = 4096;          %��Ƭ�߶�2048
% intImageWidth = 4096;           %��Ƭ����2048
% intLightThreshold = 500;        %������ֵ�ݶ�300
% intBkThreshold = 200;           %������ֵ�ݶ�100
% nImageType =3;                  %��X�᷽��ת������2K���
% ifdraw = 1;
% data =f_ReadImage(fn,intImageHeight,intImageWidth,nImageType,ifdraw);
% [XYMN] =f_CalFiberPos(data,intImageHeight,intImageWidth,intLightThreshold,intBkThreshold,ifdraw);
