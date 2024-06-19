function bends = wormBends2(x, y, seg)
% 函数的功能：
% 输入：x、y中心线上的点的坐标序列，seg：2：6
% 输出：弯曲角度
bends = [];

for i = seg
    a = ptDist(x(i - 1), y(i - 1), x(i), y(i));
    b = ptDist(x(i + 1), y(i + 1), x(i), y(i));
    c = ptDist(x(i + 1), y(i + 1), x(i - 1), y(i - 1));

    angle = acos((a^2 + b^2 - c^2) / (2 * a * b));
    angle = angle * 180 / pi;
    angle = 180 - angle;

    va = [x(i - 1) - x(i), y(i - 1) - y(i), 0];
    vb = [x(i + 1) - x(i), y(i + 1) - y(i), 0];
    ortho = cross(va, vb);
    if ortho(3) < 0
        angle = -angle;
    end
    bends = [bends, angle];
end
