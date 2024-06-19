function [nextHeadx, nextHeady, nextTailx, nextTaily, angle, distance] = findNextHead3(img, preHeadx, preHeady, preTailx, preTaily)
% ���������ã����������ͼ���ǰһ֡��ͷβ���꣬�ҵ���һ֡�е�ͷ����β�����꣬������ͷ���������Ƕȡ�
% ����;imgͼ��ͷβ����
% �����
    [x, y, nextHeadx,nextHeady,nextTailx,nextTaily] = getSkeleton2(img,preHeadx, preHeady, preTailx, preTaily);
    [xs, ys] = divideSpline5(x, y, nextHeadx,nextHeady,nextTailx,nextTaily,6);  % �������������ȷ� ���յõ�����7�������������У����ߵ�����յ� + ����ȷֵ㣩
    angle = headBendAngle(xs, ys);
    fprintf('head bend angle is %.2f\n', angle);
    distance = ptDist(nextHeadx, nextHeady, nextTailx, nextTaily);
end
