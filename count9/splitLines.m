function [x1, y1, x2, y2] = splitLines(xSeq, ySeq, headPt, tailPt)
% ���߳�ı�Ե���� ���ֳ� ��ͷ����β�� �� ��β����ͷ�� ������
 x1 = [];
 y1 = [];
 x2 = [];
 y2 = [];
 
% ʹ��һ��ѭ������һ�����ߵ������xSeq��ySeq����ȡ���������洢��x1��y1�����С�
 i1 = headPt;
 while i1 ~= tailPt + 1
     if i1 == length(xSeq) + 1
         i1 = 1;
     end
     x1 = [x1, xSeq(i1)];
     y1 = [y1, ySeq(i1)];
     i1 = i1 + 1;
 end
 
% ʹ��һ��ѭ�����ڶ������ߵ������xSeq��ySeq����ȡ���������洢��x2��y2�����С�
 i2 = headPt;
 while i2 ~= tailPt - 1
     if i2 == 0
         i2 = length(xSeq);
     end
     x2 = [x2, xSeq(i2)];
     y2 = [y2, ySeq(i2)];
     i2 = i2 - 1;
 end

 disp('Lines split successfully');
end