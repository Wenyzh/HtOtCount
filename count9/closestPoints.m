% �ҵ���ο�����ӽ��ĵ㣬�������ԭʼ������ɾ������󷵻�ɾ�����������ɾ����������������
function [xClosest, yClosest, xNew, yNew] = closestPoints(xRef, yRef, x, y)
%{
���������
xRef: �ο����x����
yRef: �ο����y����
x: �������е������������x����
y: �������е������������y����
���������
xClosest: ��ο�����ӽ��ĵ��x����
yClosest: ��ο�����ӽ��ĵ��y����
xNew: ɾ����ӽ�������x��������  ������
yNew: ɾ����ӽ�������y��������
%}
oldDist = 1e6;
pointNum = 0;
for i = 1:length(x)
    newDist = ptDist(xRef, yRef, x(i), y(i));  % ����ο��㣨xRef, yRef���뵱ǰ�㣨x(i), y(i)��֮��ľ��룬���������ֵ��newDist��
    if newDist < oldDist
        oldDist = newDist;
        pointNum = i;   % ������ӽ����������Ϊi��
    end
end

xClosest = x(pointNum);   % ����ӽ����x���긳ֵ��xClosest
yClosest = y(pointNum);   % ����ӽ����x���긳ֵ��yClosest
x(pointNum) = 0;   % ����ӽ����x������Ϊ0���Ա����ɾ����
y(pointNum) = 0;   % ����ӽ����y������Ϊ0���Ա����ɾ����
xNew = removeZeros(x);   % ɾ��
yNew = removeZeros(y);
