function curvatureCheck(mX, mY)
% ���������ã�
% ���룺�������ϵĵ����������
% �����
    bends = wormBends2(mX, mY, 2:6);
    if max(abs(bends)) > 135
        disp(bends)
        disp('Invalid worm spline curvature; Retrying.')
        guihgka
    end
end
