% 对每个坐标点进行线性插值，以平滑整条曲线。
function [xs, ys] = smoothxy(x, y)
xo = x;
yo = y;
x = [x(end), x, x(1)];
y = [y(end), y, y(1)];
xs = zeros(1, length(xo));
ys = zeros(1, length(yo));
for i = 2:length(x) - 1
    ab = [x(i + 1) - x(i - 1); y(i + 1) - y(i - 1)];
    abu = ab / sqrt(ab(1)^2 + ab(2)^2);
    ac = [x(i) - x(i - 1); y(i) - y(i - 1)];
    d = dot(ac, abu) * abu + [x(i - 1); y(i - 1)];
    [ex, ey] = midpoint(d(1), d(2), x(i), y(i));
    xs(i - 1) = ex;
    ys(i - 1) = ey;
end
