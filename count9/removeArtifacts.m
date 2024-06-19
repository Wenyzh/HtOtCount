function [xNew, yNew] = removeArtifacts(x, y)
%{
输入参数：
x: 包含所有边缘点的有向向量的x坐标
y: 包含所有边缘点的有向向量的y坐标
输出参数：
xNew: 删除噪声点后的新x坐标向量
yNew: 删除噪声点后的新y坐标向量
作用：对输入的边缘点坐标进行处理，去除噪声点并返回新的坐标向量。
具体来说，代码中使用了一个while循环来迭代处理，直到曲线长度为原始坐标点数量的一半为止。
在每次循环中，代码会选择一个随机起始点作为参考点，并通过调用函数closestPoints找到与参考点最接近的点。
然后，将该点添加到曲线上，并更新参考点和剩余的坐标向量。
如果找到的最接近点与参考点的距离小于5，即被视为噪声点，会将其添加到曲线上，并更新参考点和剩余的坐标向量。
如果找到的最接近点与参考点的距离大于等于5，则会从原始坐标中删除该点。
最终，当曲线长度大于原始坐标点数量的一半时，循环结束，返回删除噪声点后的新坐标向量xCurve和yCurve。
作用：对输入的曲线数据进行处理，去除异常点，使曲线更加平滑和连续。
%}
tic
xOriginal = x;
yOriginal = y;
curveLength = 0;
while curveLength < 0.5 * length(x)   % 这里的length(x)指原 曲线上点的个数
    if toc > 3
        disp('removeArtifacts timed out');
        juwlihgiwuhg;
    end
    xCurve = [];
    yCurve = [];
    x = xOriginal;
    y = yOriginal;
    randomStartPoint = randi(length(x), 1);  % 生成一个随机索引，用于在向量x中随机选择一个元素。
    xPrev = x(randomStartPoint);
    yPrev = y(randomStartPoint);   % 随机生成参考点的坐标为(xRef, yRef)
    for i = 1:length(x)
        if toc > 3
            disp('removeArtifacts timed out');
            juwlihgiwuhg;
        end
        [xClosest, yClosest, xNew, yNew] = closestPoints(xPrev, yPrev, x, y);
        % 找到与参考点最接近的点，并将其从原始坐标中删除
        % 最后返回删除点的坐标(xClosest,yClosest)与删除点后的新坐标向量( xNew, yNew)
        if ptDist(xClosest, yClosest, xPrev, yPrev) < 5   
            xCurve = [xCurve, xClosest];   % 添加
            yCurve = [yCurve, yClosest];
            xPrev = xClosest;
            yPrev = yClosest;
            x = xNew;
            y = yNew;
        else
            loc = intersect(find(x == xClosest), find(y == yClosest));
            try
                xNew = [x(1:loc - 1), x(1:loc + 1)];
                yNew = [y(1:loc - 1), y(1:loc + 1)];
            catch
            end
        end
    end
    curveLength = length(xCurve);
end
xNew = xCurve;
yNew = yCurve;
