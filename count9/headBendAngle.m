function [headangle] = headBendAngle(x, y)
% 函数的作用：
% 输入：等分点点的坐标序列
% 输出：弯曲的角度

a2 = (x(1) - x(2)) * (x(1) - x(2)) + (y(1) - y(2)) * (y(1) - y(2));
b2 = (x(3) - x(2)) * (x(3) - x(2)) + (y(3) - y(2)) * (y(3) - y(2));
c2 = (x(1) - x(3)) * (x(1) - x(3)) + (y(1) - y(3)) * (y(1) - y(3));

a = sqrt(a2);
b = sqrt(b2);
c = sqrt(c2);
pos = (a2 + b2 - c2) / (2 * a * b);
angle = acos(pos);
realangle = angle * 180 / pi; % 弧度制转角度值
headangle = 180 - realangle;  % 180减去该角度值得到弯曲的角度。

headangle = roundn(headangle, -2);   % roundn将输入数据x四舍五入到指定的小数位数n。

%{
if headangle > 90
    headangle = 89;
end
%}
end
