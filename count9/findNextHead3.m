function [nextHeadx, nextHeady, nextTailx, nextTaily, angle, distance] = findNextHead3(img, preHeadx, preHeady, preTailx, preTaily)
% 函数的作用：根据输入的图像和前一帧的头尾坐标，找到下一帧中的头部和尾部坐标，并计算头部的弯曲角度。
% 输入;img图像、头尾坐标
% 输出：
    [x, y, nextHeadx,nextHeady,nextTailx,nextTaily] = getSkeleton2(img,preHeadx, preHeady, preTailx, preTaily);
    [xs, ys] = divideSpline5(x, y, nextHeadx,nextHeady,nextTailx,nextTaily,6);  % 将骨骼曲线六等分 最终得到包含7个点的坐标点序列（曲线的起点终点 + 五个等分点）
    angle = headBendAngle(xs, ys);
    fprintf('head bend angle is %.2f\n', angle);
    distance = ptDist(nextHeadx, nextHeady, nextTailx, nextTaily);
end
