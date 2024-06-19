function [headangle] = headBendAngle(x, y)
% ���������ã�
% ���룺�ȷֵ�����������
% ����������ĽǶ�

a2 = (x(1) - x(2)) * (x(1) - x(2)) + (y(1) - y(2)) * (y(1) - y(2));
b2 = (x(3) - x(2)) * (x(3) - x(2)) + (y(3) - y(2)) * (y(3) - y(2));
c2 = (x(1) - x(3)) * (x(1) - x(3)) + (y(1) - y(3)) * (y(1) - y(3));

a = sqrt(a2);
b = sqrt(b2);
c = sqrt(c2);
pos = (a2 + b2 - c2) / (2 * a * b);
angle = acos(pos);
realangle = angle * 180 / pi; % ������ת�Ƕ�ֵ
headangle = 180 - realangle;  % 180��ȥ�ýǶ�ֵ�õ������ĽǶȡ�

headangle = roundn(headangle, -2);   % roundn����������x�������뵽ָ����С��λ��n��

%{
if headangle > 90
    headangle = 89;
end
%}
end
