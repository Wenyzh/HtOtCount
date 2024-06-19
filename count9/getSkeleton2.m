function [X, Y, nowHeadx, nowHeady, nowTailx, nowTaily] = getSkeleton2(B, preHeadx, preHeady,~, ~)
% ���������ã�
% ���룺�ɾ��Ķ�ֵͼ��
% ������������������С���ǰͷ��������͵�ǰβ��������

    % Check if the image is in RGB format
    if ndims(B) == 3
        % Convert the image to grayscale
        B = rgb2gray(B);
    end
    
    % ʹ��Otsu�㷨������ֵ
    threshold = graythresh(B);
    
    % ���ݼ���õ�����ֵ����ͼ���ֵ��
    img_binary = imbinarize(B, threshold);
    img_convert = ~img_binary; 
    
    % ʹ��bwmorph������ȡ������ͨ��'thin'��ѡ��������ϸ��������
    mm = bwmorph(img_convert, 'thin', Inf); 
    imshow(mm); 
    hold on 
    
    % ��ȡ�˵������
    endpoints = SkeletonGetEndPt3(mm);
    
    % ����õ��������˵�����
    disp(['Endpoint 1: (', num2str(endpoints(1, 1)), ', ', num2str(endpoints(1, 2)), ')']);
    disp(['Endpoint 2: (', num2str(endpoints(2, 1)), ', ', num2str(endpoints(2, 2)), ')']);
    % ���ǰһ֡��ͷ������
    disp(['Previous Head Coordinate: (', num2str(preHeadx), ', ', num2str(preHeady), ')']);
    
    % ���������һ֡ͷ������Ķ˵���Ϊ��ǰ֡ͷ������
    dist_head = sqrt((endpoints(:,1) - preHeadx).^2 + (endpoints(:,2) - preHeady).^2);
    [~, idx_head] = min(dist_head);
    nowHeadx = endpoints(idx_head, 1);
    nowHeady = endpoints(idx_head, 2);
    
    % ����ǰ֡��ͷ������Ӷ˵���ɾ��
    endpoints(idx_head, :) = [];

    % ʣ�µĶ˵���ǵ�ǰ֡��β������
    nowTailx = endpoints(1, 1);
    nowTaily = endpoints(1, 2);
    
    fprintf('��ǰ֡��ͷ������Ϊ: (%d, %d)\n', nowHeadx, nowHeady);
    fprintf('��ǰ֡��β������Ϊ: (%d, %d)\n', nowTailx, nowTaily);
    
    [x, y] = find(mm == 1); 
    [height, ~] = size(mm); 
    
    % ��ʼ�� x1 �� y1
    x1 = [];
    y1 = [];

    % �任����ϵ
    for idx = 1:length(x)
        newX = y(idx);
        newY = height - x(idx);

        % �жϵ�ǰ���Ƿ���ͷ�������غϣ����غ��������õ�
        if newX == nowHeadx && newY == nowHeady
            continue;
        end

        x1 = [x1, newX];
        y1 = [y1, newY];
    end

    % ��ʼ�� X �� Y
    X = [];
    Y = [];

    % ����ǰͷ�����������������
    X = [X, nowHeadx];
    Y = [Y, nowHeady];

    while ~isempty(x1) && ~isempty(y1)
        % ����������һ��������ĵ������
        dist = sqrt((x1 - X(end)).^2 + (y1 - Y(end)).^2);
        [~, idx] = min(dist);

        % ������ĵ���ӵ� X �� Y ��
        X = [X; x1(idx)];
        Y = [Y; y1(idx)];

        % �� x1 �� y1 ��ɾ���ѱ���ĵ�
        x1(idx) = [];
        y1(idx) = [];
    end

    % �ж��Ƿ��ҵ���ǰ֡β������
    if X(end) == nowTailx && Y(end) == nowTaily
        disp('������');
    end
end
