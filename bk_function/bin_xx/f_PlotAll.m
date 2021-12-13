function  PlotAll(xx,yy,mytitle,save_path)
% �������е�Ԫ���˶��켣
%xx�� 3D
%yy�� 3D

%2017.7.5 lzg start

if nargin<2;
    msgbox('ȱ���������������'); return;
elseif nargin>=2
    for i=1:size(xx,2)
        plotx(:,:)=xx(:,i,:);
        ploty(:,:)=yy(:,i,:);
        plot(plotx,ploty);
        hold on;
    end
    if nargin>=3
        title(mytitle);
    end
    hold off;
    if nargin>=4
        saveas(gcf,save_path);
    end
end

% function test()
% fpath='..\testdata\f_PlotAll.mat';
% save_path='..\testdata\f_PlotAll.jpg';
% load(fpath);
% PlotAll(xx,yy,'С����ϵ',save_path);
