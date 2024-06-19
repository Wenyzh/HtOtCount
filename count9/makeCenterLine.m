function [mX, mY, cX, cY, oX, oY] = makeCenterLine(x1, y1, x2, y2)
% ���������ã�����������
% ������������ָ������������������������
% ����������������ߵ����ĵ���������

% ���϶̵���������㸳������x��y���ϳ�����������㸳������xp��yp  
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
    
    leng = length(x);   % ���϶����ߵĸ�����ֵ��leng
    seg = 25;
    interval = floor(leng / seg);    % ����ÿ�εļ��interval
    % ����һ�����interval�����϶̵����߷�Ϊ25�Σ�ÿ�εļ����interval�� floor����������ȡ��
    q = 3;
    % �� x1 �� y1 �������յ�����ֱ�ֵ�� hX��hY �� tX��tY��
    % ʵ���� �����ǽ�ͷ����β��������ֱ𸳸�hX��hY �� tX��tY��
    hX = x1(1);
    hY = y1(1);
    tX = x1(end);
    tY = y1(end);
    cX = [];
    cY = [];
    % x��y�ǽ϶����ߵ���������   xp��yp�ǽϳ����ߵ���������
    % �ڽϳ�������Ѱ�� ���� �϶������ϵķֶε� ����ĵ�
    for i = 2 * interval : interval : length(x) - 2 * interval
        % diff�����������ǣ����㵼��
        v = [mean(diff(y(i - q : i + q))); -mean(diff(x(i - q : i + q)))];
        % v �������� v ��ģ�����õ���λ���� vu��
        vu = v / sqrt(v(1)^2 + v(2)^2);
        [closestx, closesty] = minimizeDistance(vu, xp, yp, x(i), y(i));
        closestx = closestx(1);
        closesty = closesty(1);
        % ͨ��minimizeDistance���������ǿ����ҵ��ϳ���������ÿ���϶����߷ֶε���ӽ��ĵ㣬������Щ�������洢������cX��cY�С�
        cX = [cX, closestx];
        cY = [cY, closesty];
    end
    % ���϶����߳�ȥ���˵ķֶε������洢������oX��oY�С�
    oX = x(2 * interval : interval : length(x) - 2 * interval);
    oY = y(2 * interval : interval : length(x) - 2 * interval);
    % ���ĵ�����cX��cY��ԭ���ߵ�����oX��oY����ÿ�����ĵ����Ӧԭ���ߵ���е����꣬������Щ�е�����洢������mX��mY�С�
    mX = zeros(1, length(cX));
    mY = zeros(1, length(cX));
    for i = 1 : length(cX)
        [mX(i), mY(i)] = midpoint(cX(i), cY(i), oX(i), oY(i));
    end
    % ��ͷ����β����������ӵ�mX��mY�У��γ������������ߡ�
    mX = [hX, mX, tX];
    mY = [hY, mY, tY];
    % Ϊ��ʹ�����߸���ƽ���������������߽����˲�ֵ���������˵����������󷵻ز�ֵ�������������mX��mY��
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
% ���������ã�
% ���룺vector����λ����  x��y���ϳ����ߵ���������   x1��y1���϶����߱��ȷֺ�ĵ�ĳһ�����������
% �����
    a = [x - x1; y - y1];
    b = vector;
    proj = [];
    lengthVectorProj = zeros(1, length(x));
    perpendicularDist = zeros(1, length(x));
    
    for i = 1 : length(x)
        p = dot(a(:, i), b) * b;   % �����a(:, i)������b�ϵ�ͶӰ��������洢�ھ���p�С�
        lp = sqrt(p(1)^2 + p(2)^2);   % ����ͶӰp�ĳ���lp��
        lengtha = sqrt(a(1, i)^2 + a(2, i)^2);   % �����a(:, i)�ĳ���lengtha��
        pd = sqrt(lengtha^2 - lp^2);   % �����a(:, i)������b�Ĵ�ֱ����pd��
        lengthVectorProj(i) = lp;
        perpendicularDist(i) = pd;
    end
    
    cp = find(perpendicularDist < 1);   % �ҵ����д�ֱ����С��1�ĵ���������洢������cp�С�
    cp = findMins(cp, perpendicularDist);  % �ҵ�cp��perpendicular�е�����ֵ
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
