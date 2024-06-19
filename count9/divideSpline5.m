function [xs, ys] = divideSpline5(x, y, nowHeadx, nowHeady, nowTailx, nowTaily, n)
    dist = zeros(1, length(x) - 1);
    for i = 2:length(x)
        if i ~= 2
            dist(i - 1) = ptDist(x(i - 1), y(i - 1), x(i), y(i)) + dist(i - 2);
        else
            dist(i - 1) = ptDist(x(i - 1), y(i - 1), x(i), y(i));
        end
    end
    
    if ~isnumeric(n) || n <= 0 || mod(n, 1) ~= 0
        error('n must be a positive integer');
    end
    segLength = dist(end) / n;
    
    xs = zeros(1, n+1);
    ys = zeros(1, n+1);
    
    xs(1) = nowHeadx;
    ys(1) = nowHeady;
    
    currentSegLength = 0;
    j = 1;
    for i = 1:length(x)-1
        segmentLength = ptDist(x(i), y(i), x(i+1), y(i+1));
        while j < n && currentSegLength + segmentLength >= j * segLength
            t = min((j * segLength - currentSegLength) / segmentLength, 1); % 修正t的计算，确保不超过1
            xs(j+1) = x(i) + t * (x(i+1) - x(i));
            ys(j+1) = y(i) + t * (y(i+1) - y(i));
            j = j + 1;
            if j == n && abs(currentSegLength + segmentLength - j * segLength) < 1e-6 % 处理最后一段的情况
                xs(j+1) = x(i+1);
                ys(j+1) = y(i+1);
                break; % 结束循环
            end
        end
        currentSegLength = currentSegLength + segmentLength;
    end
    
    xs(end) = nowTailx;
    ys(end) = nowTaily;
    disp([xs; ys]');
end

function d = ptDist(x1, y1, x2, y2)
    d = sqrt((x2 - x1)^2 + (y2 - y1)^2);
end
