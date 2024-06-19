function [xNew, yNew] = removeArtifacts(x, y)
%{
���������
x: �������б�Ե�������������x����
y: �������б�Ե�������������y����
���������
xNew: ɾ������������x��������
yNew: ɾ������������y��������
���ã�������ı�Ե��������д���ȥ�������㲢�����µ�����������
������˵��������ʹ����һ��whileѭ������������ֱ�����߳���Ϊԭʼ�����������һ��Ϊֹ��
��ÿ��ѭ���У������ѡ��һ�������ʼ����Ϊ�ο��㣬��ͨ�����ú���closestPoints�ҵ���ο�����ӽ��ĵ㡣
Ȼ�󣬽��õ���ӵ������ϣ������²ο����ʣ�������������
����ҵ�����ӽ�����ο���ľ���С��5��������Ϊ�����㣬�Ὣ����ӵ������ϣ������²ο����ʣ�������������
����ҵ�����ӽ�����ο���ľ�����ڵ���5������ԭʼ������ɾ���õ㡣
���գ������߳��ȴ���ԭʼ�����������һ��ʱ��ѭ������������ɾ��������������������xCurve��yCurve��
���ã���������������ݽ��д���ȥ���쳣�㣬ʹ���߸���ƽ����������
%}
tic
xOriginal = x;
yOriginal = y;
curveLength = 0;
while curveLength < 0.5 * length(x)   % �����length(x)ָԭ �����ϵ�ĸ���
    if toc > 3
        disp('removeArtifacts timed out');
        juwlihgiwuhg;
    end
    xCurve = [];
    yCurve = [];
    x = xOriginal;
    y = yOriginal;
    randomStartPoint = randi(length(x), 1);  % ����һ���������������������x�����ѡ��һ��Ԫ�ء�
    xPrev = x(randomStartPoint);
    yPrev = y(randomStartPoint);   % ������ɲο��������Ϊ(xRef, yRef)
    for i = 1:length(x)
        if toc > 3
            disp('removeArtifacts timed out');
            juwlihgiwuhg;
        end
        [xClosest, yClosest, xNew, yNew] = closestPoints(xPrev, yPrev, x, y);
        % �ҵ���ο�����ӽ��ĵ㣬�������ԭʼ������ɾ��
        % ��󷵻�ɾ���������(xClosest,yClosest)��ɾ����������������( xNew, yNew)
        if ptDist(xClosest, yClosest, xPrev, yPrev) < 5   
            xCurve = [xCurve, xClosest];   % ���
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
