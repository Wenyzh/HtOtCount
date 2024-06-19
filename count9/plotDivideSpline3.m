function [xCenterLine,yCenterLine,headx,heady,tailx,taily]=plotDivideSpline3(img, imgName)
persistent headPt tailPt xSeq ySeq h
h = size(img, 1);
img = img(1:end,1:end,1);
% img(1:end, 1:end, 1) ��ʾ��ͼ�� img ��������������ѡ�������У�1:end���������У�1:end�����Լ���һ��ͨ����1����
img1 = img;

figure('Name', '1_Orininal');
imshow(img1);
hold on;

img = edge(img,'sobel');   % ��ȡͼ��ı�Ե    
figure('Name', '2_Edge');
imshow(img);
hold on;

[x,y] = edgesToCoordinates(img);      % ��ȡ��Ե�����꣺x��y��һ��������������ֱ�����˱�Ե�ϵ��������صĺ�����������ꡣ
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

% ��csv�ļ��ж�ȡ����
% ��ȡcsv�ļ�
data = readtable('D:\Postgraduate\NewDL\data\ins-18\7\label\ins-18.csv');
% ��ǰͼƬ��
currentImageName = imgName;
% ��ȡ�뵱ǰͼƬ��һ�µ�����
index = strcmp(data.Filename, currentImageName);
 % ��ȡ������Ϣ
currentHead = [data(index, 2), data(index, 3)];
currentTail = [data(index, 4), data(index, 5)];

% ��currentHead��ӵ�[xSeq,ySeq]��
% ��ȡͷ����β������
headx = currentHead{1, 1}; % ��ȡͷ��x����
heady = h - currentHead{1, 2}; % ��ȡͷ��y����
tailx = currentTail{1, 1}; % ��ȡβ��x����
taily = h - currentTail{1, 2}; % ��ȡβ��y����

% ��ͷ����β��������ӵ�xSeq��ySeq��
% ���ͷ�������Ƿ��Ѿ������� xSeq �� ySeq ��
if ~ismember([headx, heady], [xSeq', ySeq'], 'rows')
    % Ѱ�Ҿ���ͷ����������ĵ�
    distances = sqrt((xSeq - headx).^2 + (ySeq - heady).^2);
    [~, idx] = min(distances);
    
    % ��ͷ��������뵽���������ĺ���
    xSeq = [xSeq(1:idx), headx, xSeq(idx+1:end)];
    ySeq = [ySeq(1:idx), heady, ySeq(idx+1:end)];
else
    disp('ͷ�������Ѿ������� xSeq �� ySeq ��');
end

% ���β�������Ƿ��Ѿ������� xSeq �� ySeq ��
if ~ismember([tailx, taily], [xSeq', ySeq'], 'rows')
    % Ѱ�Ҿ���β����������ĵ�
    distances = sqrt((xSeq - tailx).^2 + (ySeq - taily).^2);
    [~, idx] = min(distances);
    
    % ��β��������뵽���������ĺ���
    xSeq = [xSeq(1:idx), tailx, xSeq(idx+1:end)];
    ySeq = [ySeq(1:idx), taily, ySeq(idx+1:end)];
else
    disp('β�������Ѿ������� xSeq �� ySeq ��');
end

% xSeq = horzcat(headx,xSeq, tailx);
% ySeq = horzcat(heady,ySeq, taily);

% Ѱ��ͷ����β��������
headPt = find(xSeq == headx & ySeq == heady);
tailPt = find(xSeq == tailx & ySeq == taily);

figure('Name', '6_MarkHead');
imshow(img1);
hold on;
plot(xSeq(headPt),h-ySeq(headPt)+1,'cx','MarkerSize',12,'LineWidth',3,'color','r');
plot(xSeq(tailPt),h-ySeq(tailPt)+1,'cx','MarkerSize',12,'LineWidth',3,'color','g');

% ����Ե���������� ��ͷβ����Ϊ�ֽ�� �ֳ�����
[x1,y1,x2,y2] = splitLines(xSeq,ySeq,headPt,tailPt);
% ����������
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
