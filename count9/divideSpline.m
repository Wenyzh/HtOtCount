function [xs ,ys] = divideSpline(x, y, n)
% 函数的作用：
% 输入：x中心线上的点横坐标序列、y中心线上的点纵坐标序列、n被分割的段数
% 输出：将中心线六等分的分割点的坐标序列

dist = zeros(1, length(x) - 1);
% 通过循环计算每个相邻中心点之间的距离并累加得到总距离。
% dist存储的是中心线的总长度
for i = 2:length(x)
    if i ~= 2
        dist(i - 1) = ptDist(x(i - 1), y(i - 1), x(i), y(i)) + dist(i - 2);
    else
        dist(i - 1) = ptDist(x(i - 1), y(i - 1), x(i), y(i));
    end
end
segLength = dist(end) / n;  % 间隔

xs = x(1);   % 将原始曲线x序列的第一个元素赋值给xs变量。
ys = y(1);   % 将原始曲线y序列的第一个元素赋值给ys变量。

index(1) = 1;

% 通过循环计算分割点在原始曲线中的索引。
for target = segLength:segLength:(n - 1) * segLength
    index = [index, findClosest(dist, target)];
end
index = [index, length(x)];

xs = x(index);
ys = y(index);

disp('Spline divided into segments');


function index = findClosest(dist, target)
% 函数的功能：
% 输入：dist中心线的总长度 target分割点的所在位置的长度
% 输出：距离target最近的中心点位置的索引值
lowestDist = 1e6;
for i = 1:length(dist)
    currDist = abs(dist(i) - target);
    if currDist < lowestDist
        lowestDist = currDist;
        index = i;
    end
end
