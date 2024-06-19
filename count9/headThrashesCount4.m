clc
close all

allAngles(1) = 0;
timeArray = [];
angles = [];
htdistance = [];
trainPath = 'D:\Postgraduate\NewDL\data\ins-18\7\Binary_85\';
theFiles = dir([trainPath, '*.jpg']);
disp(length(theFiles));
count = 1;
train_num = length(theFiles);

sort_nat_name = sort_nat({theFiles.name});   % 按照数据集中数据的命名规律 对数据进行排序 

for k = 1:train_num
    fullFileName = sort_nat_name{k};
    fprintf(1, 'Now reading %s\n', fullFileName);
    I = imread([trainPath, fullFileName]);
    count = count + 1;
    
    if k == 1
        [height, width] = size(I);
        % 获取图像的名称
        [~, imgName, ~] = fileparts(fullFileName);
        [x, y, headx, heady, tailx, taily] = plotDivideSpline3(I, imgName);
        figure('Name', '9_Skeleton');
        angle = headBendAngle(x, y);
        fprintf('head bend angle is %.2f\n', angle);
        angles = [angles, angle];
        heady = height - heady;  % 还原
        taily = height - taily;  
        headToTailDist = ptDist(headx, heady, tailx, taily);
        htdistance = [htdistance, headToTailDist];
        continue;
    end
    
    [newHeadx, newHeady, newTailx, newTaily, ang, dis] = findNextHead3(I, headx, heady, tailx, taily);
    
    % 更新相关变量
    headx = newHeadx;
    heady = newHeady;
    tailx = newTailx;
    taily = newTaily;
    angles = [angles, ang];
    htdistance = [htdistance, dis];
end


% 异常判断
noChangeCount = 0;  % 记录连续没有改变的图片数量
exceptionIndex = 0;  % 记录异常出现的图片索引

for k = 1:train_num-1
    headToTailDist1 = htdistance(k);  % 获取当前循环中的头尾距离
    headToTailDist2 = htdistance(k+1);  % 获取当前循环中的头尾距离
    
    % 判断是否满足omega turn的条件
    if noChangeCount < 50
        if headToTailDist1 == headToTailDist2
            noChangeCount = noChangeCount + 1;
        else
            noChangeCount = 0;
        end 
    else
        % disp(['异常发生在：', sort_nat_name{k-50}]);
    end
end

if noChangeCount < 50
    disp('没有发生异常');
end

omegaTurns = 0;
omegaTurnStart = false;  % omega turn开始标记
maxHeadToTailDist = max(htdistance);  % 最大头尾距离
fprintf('maxHeadToTailDist is %.2f\n', maxHeadToTailDist);
omegaTurnImgs = {};  % 用于保存满足omega turn条件的图像名称

for k = 1:train_num
    headToTailDist = htdistance(k);  % 获取当前循环中的头尾距离
    % 判断是否满足omega turn的条件
    if headToTailDist < maxHeadToTailDist * 0.5
        omegaTurnStart = true;
        disp(['满足条件的图像名称：', sort_nat_name{k}, '，headToTailDist值：', num2str(headToTailDist)]);
    else 
        if omegaTurnStart
            omegaTurns = omegaTurns + 1;  % 增加omega turn计数
            disp(['结束的图像名称：', sort_nat_name{k}, '，headToTailDist值：', num2str(headToTailDist)]);
            omegaTurnStart = false;
        end
    end
end

% 输出计数次数
fprintf('The number of omega turns are %d\n', omegaTurns)

anglength = length(angles);
newangles = [];
i = 1;

% 循环结束后，新角度序列newangles中将只包含绝对值大于0的角度。
for t = 1:(anglength - 1)
    if abs(angles(t)) > 5
        newangles(i) = angles(t);
        i = i + 1;
    end
end

a = length(newangles);
anglecha = [];

% 将连续的两帧之间角度的差值保存在anglecha
for t = 1:(a - 1)
    anglecha(t) = newangles(t) - newangles(t + 1);
end
% 忽略掉连续的两帧之间的摆动角度差值小于5°的角，返回有意义的角度的位置
x = find(abs(anglecha) < 5);
anglecha(x) = [];
headThrashesnum = 0;


% 创建表格
%data = table(sort_nat_name', angles', htdistance', 'VariableNames', {'ImageName', 'Angle', 'HeadToTailDistance'});
% 将表格写入CSV文件
%csvFileName = 'D:\Postgraduate\NewDL\data\N2\5\data\data.csv';
%writetable(data, csvFileName);

headThrashes = {};  % 存储发生头部摇晃的图片名
for i = 1:(length(anglecha) - 1)
    if anglecha(i) > 0 && anglecha(i + 1) < 0
        if abs(abs(anglecha(i)) - abs(anglecha(i + 1))) > 5
            headThrashesnum = headThrashesnum + 1;
            imgName = sort_nat_name{i + 1};  % 获取发生头部摇晃的图片名
            headThrashes{end+1} = imgName;  % 将图片名添加到列表中
        end
    end
end
% 将来回的弯曲动作 记作一次摆动
headThrashesnum = round(headThrashesnum / 2);
fprintf('The number of head thrash are %d\n', headThrashesnum)

% 输出发生头部摇晃的图片名
fprintf('Image names with head thrashes:\n');
for i = 1:length(headThrashes)
    fprintf('%s\n', headThrashes{i});
end

