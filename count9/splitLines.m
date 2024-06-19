function [x1, y1, x2, y2] = splitLines(xSeq, ySeq, headPt, tailPt)
% 将线虫的边缘曲线 划分成 从头部到尾部 与 从尾部到头部 两部分
 x1 = [];
 y1 = [];
 x2 = [];
 y2 = [];
 
% 使用一个循环将第一段曲线的坐标从xSeq和ySeq中提取出来，并存储到x1和y1数组中。
 i1 = headPt;
 while i1 ~= tailPt + 1
     if i1 == length(xSeq) + 1
         i1 = 1;
     end
     x1 = [x1, xSeq(i1)];
     y1 = [y1, ySeq(i1)];
     i1 = i1 + 1;
 end
 
% 使用一个循环将第二段曲线的坐标从xSeq和ySeq中提取出来，并存储到x2和y2数组中。
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