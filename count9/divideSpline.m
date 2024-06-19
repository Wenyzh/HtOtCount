function [xs ,ys] = divideSpline(x, y, n)
% ���������ã�
% ���룺x�������ϵĵ���������С�y�������ϵĵ����������С�n���ָ�Ķ���
% ����������������ȷֵķָ�����������

dist = zeros(1, length(x) - 1);
% ͨ��ѭ������ÿ���������ĵ�֮��ľ��벢�ۼӵõ��ܾ��롣
% dist�洢���������ߵ��ܳ���
for i = 2:length(x)
    if i ~= 2
        dist(i - 1) = ptDist(x(i - 1), y(i - 1), x(i), y(i)) + dist(i - 2);
    else
        dist(i - 1) = ptDist(x(i - 1), y(i - 1), x(i), y(i));
    end
end
segLength = dist(end) / n;  % ���

xs = x(1);   % ��ԭʼ����x���еĵ�һ��Ԫ�ظ�ֵ��xs������
ys = y(1);   % ��ԭʼ����y���еĵ�һ��Ԫ�ظ�ֵ��ys������

index(1) = 1;

% ͨ��ѭ������ָ����ԭʼ�����е�������
for target = segLength:segLength:(n - 1) * segLength
    index = [index, findClosest(dist, target)];
end
index = [index, length(x)];

xs = x(index);
ys = y(index);

disp('Spline divided into segments');


function index = findClosest(dist, target)
% �����Ĺ��ܣ�
% ���룺dist�����ߵ��ܳ��� target�ָ�������λ�õĳ���
% ���������target��������ĵ�λ�õ�����ֵ
lowestDist = 1e6;
for i = 1:length(dist)
    currDist = abs(dist(i) - target);
    if currDist < lowestDist
        lowestDist = currDist;
        index = i;
    end
end
