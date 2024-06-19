function [xCenterLine,yCenterLine,headx,heady,tailx,taily]=plotDivideSpline3(img, imgName)
persistent headPt tailPt xSeq ySeq h
h = size(img, 1);
img = img(1:end,1:end,1);
% img(1:end, 1:end, 1) 表示对图像 img 进行索引操作，选择所有行（1:end）和所有列（1:end），以及第一个通道（1）。
img1 = img;

figure('Name', '1_Orininal');
imshow(img1);
hold on;

img = edge(img,'sobel');   % 提取图像的边缘    
figure('Name', '2_Edge');
imshow(img);
hold on;

[x,y] = edgesToCoordinates(img);      % 获取边缘的坐标：x和y是一组有序的向量，分别包含了边缘上的所有像素的横坐标和纵坐标。
figure('Name', '3_EdgeCoordinates');
imshow(img);
hold on;
plot(x, h-y, 'r.', 'MarkerSize', 5);

[xSeq,ySeq] = removeArtifacts(x,y);   
figure('Name', '4_RemoveCoordinates');
imshow(img);
hold on;
plot(xSeq, h-ySeq, 'g.', 'MarkerSize', 5);

[xSeq,ySeq] = smoothxy(xSeq,ySeq);    
figure('Name', '5_Smooth');
imshow(img);
hold on;
plot(xSeq, h-ySeq, 'b.', 'MarkerSize', 5);   

% 从csv文件中读取坐标
% 读取csv文件
data = readtable('D:\Postgraduate\NewDL\data\ins-18\7\label\ins-18.csv');
% 当前图片名
currentImageName = imgName;
% 提取与当前图片名一致的坐标
index = strcmp(data.Filename, currentImageName);
 % 提取坐标信息
currentHead = [data(index, 2), data(index, 3)];
currentTail = [data(index, 4), data(index, 5)];

% 将currentHead添加到[xSeq,ySeq]中
% 获取头部和尾部坐标
headx = currentHead{1, 1}; % 获取头部x坐标
heady = h - currentHead{1, 2}; % 获取头部y坐标
tailx = currentTail{1, 1}; % 获取尾部x坐标
taily = h - currentTail{1, 2}; % 获取尾部y坐标

% 将头部和尾部坐标添加到xSeq和ySeq中
% 检查头部坐标是否已经存在于 xSeq 和 ySeq 中
if ~ismember([headx, heady], [xSeq', ySeq'], 'rows')
    % 寻找距离头部坐标最近的点
    distances = sqrt((xSeq - headx).^2 + (ySeq - heady).^2);
    [~, idx] = min(distances);
    
    % 将头部坐标插入到距离最近点的后面
    xSeq = [xSeq(1:idx), headx, xSeq(idx+1:end)];
    ySeq = [ySeq(1:idx), heady, ySeq(idx+1:end)];
else
    disp('头部坐标已经存在于 xSeq 和 ySeq 中');
end

% 检查尾部坐标是否已经存在于 xSeq 和 ySeq 中
if ~ismember([tailx, taily], [xSeq', ySeq'], 'rows')
    % 寻找距离尾部坐标最近的点
    distances = sqrt((xSeq - tailx).^2 + (ySeq - taily).^2);
    [~, idx] = min(distances);
    
    % 将尾部坐标插入到距离最近点的后面
    xSeq = [xSeq(1:idx), tailx, xSeq(idx+1:end)];
    ySeq = [ySeq(1:idx), taily, ySeq(idx+1:end)];
else
    disp('尾部坐标已经存在于 xSeq 和 ySeq 中');
end

% xSeq = horzcat(headx,xSeq, tailx);
% ySeq = horzcat(heady,ySeq, taily);

% 寻找头部和尾部的索引
headPt = find(xSeq == headx & ySeq == heady);
tailPt = find(xSeq == tailx & ySeq == taily);

figure('Name', '6_MarkHead');
imshow(img1);
hold on;
plot(xSeq(headPt),h-ySeq(headPt)+1,'cx','MarkerSize',12,'LineWidth',3,'color','r');
plot(xSeq(tailPt),h-ySeq(tailPt)+1,'cx','MarkerSize',12,'LineWidth',3,'color','g');

% 将边缘的坐标序列 以头尾坐标为分界点 分成两列
[x1,y1,x2,y2] = splitLines(xSeq,ySeq,headPt,tailPt);
% 计算中心线
[xCenterLine,yCenterLine] = makeCenterLine(x1,y1,x2,y2);

[xCenterLine,yCenterLine] = divideSpline(xCenterLine,yCenterLine,6);

figure('Name', '8_EqualSpline');
imshow(img1);
hold on;
plot(xCenterLine,h-yCenterLine+1,'.c','MarkerSize',12,'color',[1,220/255,126/255]);
hold off

curvatureCheck(xCenterLine,yCenterLine);
headx = xSeq(headPt);
heady = h - ySeq(headPt) + 1;
tailx = xSeq(tailPt);
taily = h - ySeq(tailPt) + 1;
