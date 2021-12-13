# PhotoGrab_MatlabWS

CalUnitParam  
%计算光纤机器人初始参数

FindQCircleCenter2.0
% 通过像素初值寻找参考光纤与偏移量
% 输入：像素坐标、像素初值
% 输出：FF初始像素位置、偏移量

FindQCircleCenter3_0
% 在原有的版本上减少了输入参数，优化了代码。
% 通过像素寻找参考光纤
% 输入：像素坐标
% 通过像素遍历同心圆来判断同心圆中光斑数量>fiberNumThreshold的作为参考光纤
% 再通过聚类算法聚类出 FFNum 个参考光纤
% 求取同类均值后进行排序
% 拟合圆心
% 输出：FF初始像素位置
