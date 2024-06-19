function curvatureCheck(mX, mY)
% 函数的作用：
% 输入：中心线上的点的坐标序列
% 输出：
    bends = wormBends2(mX, mY, 2:6);
    if max(abs(bends)) > 135
        disp(bends)
        disp('Invalid worm spline curvature; Retrying.')
        guihgka
    end
end
