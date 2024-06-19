function [X, Y, nowHeadx, nowHeady, nowTailx, nowTaily] = getSkeleton2(B, preHeadx, preHeady,~, ~)
% 函数的作用：
% 输入：干净的二值图像
% 输出：骨骼的坐标序列、当前头部的坐标和当前尾部的坐标

    % Check if the image is in RGB format
    if ndims(B) == 3
        % Convert the image to grayscale
        B = rgb2gray(B);
    end
    
    % 使用Otsu算法计算阈值
    threshold = graythresh(B);
    
    % 根据计算得到的阈值进行图像二值化
    img_binary = imbinarize(B, threshold);
    img_convert = ~img_binary; 
    
    % 使用bwmorph函数获取骨骼（通过'thin'可选参数进行细化操作）
    mm = bwmorph(img_convert, 'thin', Inf); 
    imshow(mm); 
    hold on 
    
    % 获取端点的坐标
    endpoints = SkeletonGetEndPt3(mm);
    
    % 输出得到的两个端点坐标
    disp(['Endpoint 1: (', num2str(endpoints(1, 1)), ', ', num2str(endpoints(1, 2)), ')']);
    disp(['Endpoint 2: (', num2str(endpoints(2, 1)), ', ', num2str(endpoints(2, 2)), ')']);
    % 输出前一帧的头部坐标
    disp(['Previous Head Coordinate: (', num2str(preHeadx), ', ', num2str(preHeady), ')']);
    
    % 计算距离上一帧头部最近的端点作为当前帧头部坐标
    dist_head = sqrt((endpoints(:,1) - preHeadx).^2 + (endpoints(:,2) - preHeady).^2);
    [~, idx_head] = min(dist_head);
    nowHeadx = endpoints(idx_head, 1);
    nowHeady = endpoints(idx_head, 2);
    
    % 将当前帧的头部坐标从端点中删除
    endpoints(idx_head, :) = [];

    % 剩下的端点就是当前帧的尾部坐标
    nowTailx = endpoints(1, 1);
    nowTaily = endpoints(1, 2);
    
    fprintf('当前帧的头部坐标为: (%d, %d)\n', nowHeadx, nowHeady);
    fprintf('当前帧的尾部坐标为: (%d, %d)\n', nowTailx, nowTaily);
    
    [x, y] = find(mm == 1); 
    [height, ~] = size(mm); 
    
    % 初始化 x1 和 y1
    x1 = [];
    y1 = [];

    % 变换坐标系
    for idx = 1:length(x)
        newX = y(idx);
        newY = height - x(idx);

        % 判断当前点是否与头部坐标重合，若重合则跳过该点
        if newX == nowHeadx && newY == nowHeady
            continue;
        end

        x1 = [x1, newX];
        y1 = [y1, newY];
    end

    % 初始化 X 和 Y
    X = [];
    Y = [];

    % 将当前头部坐标加入坐标序列
    X = [X, nowHeadx];
    Y = [Y, nowHeady];

    while ~isempty(x1) && ~isempty(y1)
        % 计算距离最后一个点最近的点的索引
        dist = sqrt((x1 - X(end)).^2 + (y1 - Y(end)).^2);
        [~, idx] = min(dist);

        % 将最近的点添加到 X 和 Y 中
        X = [X; x1(idx)];
        Y = [Y; y1(idx)];

        % 从 x1 和 y1 中删除已保存的点
        x1(idx) = [];
        y1(idx) = [];
    end

    % 判断是否找到当前帧尾部坐标
    if X(end) == nowTailx && Y(end) == nowTaily
        disp('出错了');
    end
end
