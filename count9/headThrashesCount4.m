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

sort_nat_name = sort_nat({theFiles.name});   % �������ݼ������ݵ��������� �����ݽ������� 

for k = 1:train_num
    fullFileName = sort_nat_name{k};
    fprintf(1, 'Now reading %s\n', fullFileName);
    I = imread([trainPath, fullFileName]);
    count = count + 1;
    
    if k == 1
        [height, width] = size(I);
        % ��ȡͼ�������
        [~, imgName, ~] = fileparts(fullFileName);
        [x, y, headx, heady, tailx, taily] = plotDivideSpline3(I, imgName);
        figure('Name', '9_Skeleton');
        angle = headBendAngle(x, y);
        fprintf('head bend angle is %.2f\n', angle);
        angles = [angles, angle];
        heady = height - heady;  % ��ԭ
        taily = height - taily;  
        headToTailDist = ptDist(headx, heady, tailx, taily);
        htdistance = [htdistance, headToTailDist];
        continue;
    end
    
    [newHeadx, newHeady, newTailx, newTaily, ang, dis] = findNextHead3(I, headx, heady, tailx, taily);
    
    % ������ر���
    headx = newHeadx;
    heady = newHeady;
    tailx = newTailx;
    taily = newTaily;
    angles = [angles, ang];
    htdistance = [htdistance, dis];
end


% �쳣�ж�
noChangeCount = 0;  % ��¼����û�иı��ͼƬ����
exceptionIndex = 0;  % ��¼�쳣���ֵ�ͼƬ����

for k = 1:train_num-1
    headToTailDist1 = htdistance(k);  % ��ȡ��ǰѭ���е�ͷβ����
    headToTailDist2 = htdistance(k+1);  % ��ȡ��ǰѭ���е�ͷβ����
    
    % �ж��Ƿ�����omega turn������
    if noChangeCount < 50
        if headToTailDist1 == headToTailDist2
            noChangeCount = noChangeCount + 1;
        else
            noChangeCount = 0;
        end 
    else
        % disp(['�쳣�����ڣ�', sort_nat_name{k-50}]);
    end
end

if noChangeCount < 50
    disp('û�з����쳣');
end

omegaTurns = 0;
omegaTurnStart = false;  % omega turn��ʼ���
maxHeadToTailDist = max(htdistance);  % ���ͷβ����
fprintf('maxHeadToTailDist is %.2f\n', maxHeadToTailDist);
omegaTurnImgs = {};  % ���ڱ�������omega turn������ͼ������

for k = 1:train_num
    headToTailDist = htdistance(k);  % ��ȡ��ǰѭ���е�ͷβ����
    % �ж��Ƿ�����omega turn������
    if headToTailDist < maxHeadToTailDist * 0.5
        omegaTurnStart = true;
        disp(['����������ͼ�����ƣ�', sort_nat_name{k}, '��headToTailDistֵ��', num2str(headToTailDist)]);
    else 
        if omegaTurnStart
            omegaTurns = omegaTurns + 1;  % ����omega turn����
            disp(['������ͼ�����ƣ�', sort_nat_name{k}, '��headToTailDistֵ��', num2str(headToTailDist)]);
            omegaTurnStart = false;
        end
    end
end

% �����������
fprintf('The number of omega turns are %d\n', omegaTurns)

anglength = length(angles);
newangles = [];
i = 1;

% ѭ���������½Ƕ�����newangles�н�ֻ��������ֵ����0�ĽǶȡ�
for t = 1:(anglength - 1)
    if abs(angles(t)) > 5
        newangles(i) = angles(t);
        i = i + 1;
    end
end

a = length(newangles);
anglecha = [];

% ����������֮֡��ǶȵĲ�ֵ������anglecha
for t = 1:(a - 1)
    anglecha(t) = newangles(t) - newangles(t + 1);
end
% ���Ե���������֮֡��İڶ��ǶȲ�ֵС��5��Ľǣ�����������ĽǶȵ�λ��
x = find(abs(anglecha) < 5);
anglecha(x) = [];
headThrashesnum = 0;


% �������
%data = table(sort_nat_name', angles', htdistance', 'VariableNames', {'ImageName', 'Angle', 'HeadToTailDistance'});
% �����д��CSV�ļ�
%csvFileName = 'D:\Postgraduate\NewDL\data\N2\5\data\data.csv';
%writetable(data, csvFileName);

headThrashes = {};  % �洢����ͷ��ҡ�ε�ͼƬ��
for i = 1:(length(anglecha) - 1)
    if anglecha(i) > 0 && anglecha(i + 1) < 0
        if abs(abs(anglecha(i)) - abs(anglecha(i + 1))) > 5
            headThrashesnum = headThrashesnum + 1;
            imgName = sort_nat_name{i + 1};  % ��ȡ����ͷ��ҡ�ε�ͼƬ��
            headThrashes{end+1} = imgName;  % ��ͼƬ����ӵ��б���
        end
    end
end
% �����ص��������� ����һ�ΰڶ�
headThrashesnum = round(headThrashesnum / 2);
fprintf('The number of head thrash are %d\n', headThrashesnum)

% �������ͷ��ҡ�ε�ͼƬ��
fprintf('Image names with head thrashes:\n');
for i = 1:length(headThrashes)
    fprintf('%s\n', headThrashes{i});
end

