function [headangle] = headBendAngle1(x1,y1,x2,y2,x3,y3)
% ���������ã�
% ���룺�ȷֵ�����������
% ����������ĽǶ�

a2 = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
b2 = (x3 - x2) * (x3 - x2) + (y3 - y2) * (y3 - y2);
c2 = (x1 - x3) * (x1 - x3) + (y1 - y3) * (y1 - y3);

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
