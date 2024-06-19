% 从输入向量in中找到所有的非零元素，并将其保存到输出向量out中
function out = removeZeros(in)
out = [];
for i = 1:length(in)
    if in(i) ~= 0
        out = [out, in(i)];
    end
end
