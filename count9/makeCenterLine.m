function [mX, mY, cX, cY, oX, oY] = makeCenterLine(x1, y1, x2, y2)
% 函数的作用：生成中心线
% 输入参数：被分割的两段曲线完整的坐标序列
% 输出参数：两侧曲线的中心点坐标序列

% 将较短的曲线坐标点赋给变量x和y，较长的曲线坐标点赋给变量xp和yp  
    if length(x1) < length(x2)
        x = x1;
        y = y1;
        xp = x2;
        yp = y2;
    else
        x = x2;
        y = y2;
        xp = x1;
        yp = y1;
    end
    
    leng = length(x);   % 将较短曲线的个数赋值给leng
    seg = 25;
    interval = floor(leng / seg);    % 计算每段的间隔interval
    % 定义一个间隔interval，将较短的曲线分为25段，每段的间隔是interval； floor函数：向下取整
    q = 3;
    % 将 x1 和 y1 的起点和终点坐标分别赋值给 hX、hY 和 tX、tY。
    % 实际上 这里是将头部和尾部的坐标分别赋给hX、hY 和 tX、tY。
    hX = x1(1);
    hY = y1(1);
    tX = x1(end);
    tY = y1(end);
    cX = [];
    cY = [];
    % x、y是较短曲线的坐标序列   xp、yp是较长曲线的坐标序列
    % 在较长曲线中寻找 距离 较短曲线上的分段点 最近的点
    for i = 2 * interval : interval : length(x) - 2 * interval
        % diff函数的作用是：计算导数
        v = [mean(diff(y(i - q : i + q))); -mean(diff(x(i - q : i + q)))];
        % v 向量除以 v 的模长，得到单位向量 vu。
        vu = v / sqrt(v(1)^2 + v(2)^2);
        [closestx, closesty] = minimizeDistance(vu, xp, yp, x(i), y(i));
        closestx = closestx(1);
        closesty = closesty(1);
        % 通过minimizeDistance函数，我们可以找到较长曲线中与每个较短曲线分段点最接近的点，并将这些点的坐标存储在数组cX和cY中。
        cX = [cX, closestx];
        cY = [cY, closesty];
    end
    % 将较短曲线除去两端的分段点的坐标存储在数组oX和oY中。
    oX = x(2 * interval : interval : length(x) - 2 * interval);
    oY = y(2 * interval : interval : length(x) - 2 * interval);
    % 中心点坐标cX和cY与原曲线点坐标oX和oY计算每个中心点与对应原曲线点的中点坐标，并将这些中点坐标存储在数组mX和mY中。
    mX = zeros(1, length(cX));
    mY = zeros(1, length(cX));
    for i = 1 : length(cX)
        [mX(i), mY(i)] = midpoint(cX(i), cY(i), oX(i), oY(i));
    end
    % 将头部和尾部的坐标添加到mX和mY中，形成完整的中心线。
    mX = [hX, mX, tX];
    mY = [hY, mY, tY];
    % 为了使中心线更加平滑，函数对中心线进行了插值处理，增加了点的数量。最后返回插值后的中心线坐标mX和mY。
    mXi = interp(mX, 8);
    mYi = interp(mY, 8);
    mXi = mXi(1 : end - 7);
    mYi = mYi(1 : end - 7);
    
    mX = mXi;
    mY = mYi;
    
    %{
    figure('Name', '7_Midpoint');
    plot(x1, y1);
    hold on;
    plot(x2, y2, 'r');
    plot(mX, mY, 'k');
    plot(hX, hY, 'cx', 'MarkerSize', 12);
    delete(figure);
    %}
    disp('Produced centerline successfully');

end

function [closestx, closesty] = minimizeDistance(vector, x, y, x1, y1)
% 函数的作用：
% 输入：vector：单位向量  x、y：较长曲线的坐标序列   x1、y1：较短曲线被等分后的的某一个定点的坐标
% 输出：
    a = [x - x1; y - y1];
    b = vector;
    proj = [];
    lengthVectorProj = zeros(1, length(x));
    perpendicularDist = zeros(1, length(x));
    
    for i = 1 : length(x)
        p = dot(a(:, i), b) * b;   % 计算点a(:, i)在向量b上的投影，将结果存储在矩阵p中。
        lp = sqrt(p(1)^2 + p(2)^2);   % 计算投影p的长度lp。
        lengtha = sqrt(a(1, i)^2 + a(2, i)^2);   % 计算点a(:, i)的长度lengtha。
        pd = sqrt(lengtha^2 - lp^2);   % 计算点a(:, i)到向量b的垂直距离pd。
        lengthVectorProj(i) = lp;
        perpendicularDist(i) = pd;
    end
    
    cp = find(perpendicularDist < 1);   % 找到所有垂直距离小于1的点的索引，存储在数组cp中。
    cp = findMins(cp, perpendicularDist);  % 找到cp在perpendicular中的索引值
    lowestPoint = find(lengthVectorProj(cp) == min(lengthVectorProj(cp)));
    lowestPoint = cp(lowestPoint);
    
    closestx = x(lowestPoint);
    closesty = y(lowestPoint);
end

function cp = findMins(cp, perpDist)
    temp = [];
    cp = [cp(1), cp];
    cpnew = [];
    lcp = length(cp);
    
    for i = 2 : lcp
        if cp(i) - cp(i - 1) < 2
            temp = [temp, cp(i)];
        else
            minimum = find(perpDist(temp) == min(perpDist(temp)));
            minimum = temp(minimum);
            minimum = minimum(1);
            cpnew = [cpnew, minimum];
            temp = cp(i);
        end
    end
    
    minimum = find(perpDist == min(perpDist(temp)));
    cpnew = [cpnew, minimum];
    cpnew = unique(cpnew);
    cp = cpnew;
end
