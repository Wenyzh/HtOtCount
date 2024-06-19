% 找到与参考点最接近的点，并将其从原始坐标中删除，最后返回删除点的坐标与删除点后的新坐标向量
function [xClosest, yClosest, xNew, yNew] = closestPoints(xRef, yRef, x, y)
%{
输入参数：
xRef: 参考点的x坐标
yRef: 参考点的y坐标
x: 包含所有点的有向向量的x坐标
y: 包含所有点的有向向量的y坐标
输出参数：
xClosest: 与参考点最接近的点的x坐标
yClosest: 与参考点最接近的点的y坐标
xNew: 删除最接近点后的新x坐标向量  【集合
yNew: 删除最接近点后的新y坐标向量
%}
oldDist = 1e6;
pointNum = 0;
for i = 1:length(x)
    newDist = ptDist(xRef, yRef, x(i), y(i));  % 计算参考点（xRef, yRef）与当前点（x(i), y(i)）之间的距离，并将结果赋值给newDist。
    if newDist < oldDist
        oldDist = newDist;
        pointNum = i;   % 更新最接近点的索引号为i。
    end
end

xClosest = x(pointNum);   % 将最接近点的x坐标赋值给xClosest
yClosest = y(pointNum);   % 将最接近点的x坐标赋值给yClosest
x(pointNum) = 0;   % 将最接近点的x坐标置为0，以便后续删除。
y(pointNum) = 0;   % 将最接近点的y坐标置为0，以便后续删除。
xNew = removeZeros(x);   % 删除
yNew = removeZeros(y);
