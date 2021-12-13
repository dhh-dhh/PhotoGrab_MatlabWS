function  PlotAll(xx,yy,mytitle,save_path)
% 画出所有单元的运动轨迹
%xx： 3D
%yy： 3D

%2017.7.5 lzg start

if nargin<2;
    msgbox('缺少输入参数。。。'); return;
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
% PlotAll(xx,yy,'小坐标系',save_path);
