function endPoints = SkeletonGetEndPt3(skeletonImg)
    endPoints = [];
    padImg = padarray(skeletonImg, [1 1], 0, 'both');
    padImg = uint8(padImg);  % 将填充后的图像转换为 uint8 类型
    zerOneImg = imbinarize(padImg);

    kernel1 = [-1 -1 0; -1 1 1; -1 -1 0];
    kernel2 = [-1 -1 -1; -1 1 -1; 0 1 0];
    kernel3 = [0 -1 -1; 1 1 -1; 0 -1 -1];
    kernel4 = [0 1 0; -1 1 -1; -1 -1 -1];
    kernel5 = [-1 -1 -1; -1 1 -1; -1 -1 1];
    kernel6 = [-1 -1 -1; -1 1 -1; 1 -1 -1];
    kernel7 = [1 -1 -1; -1 1 -1; -1 -1 -1];
    kernel8 = [-1 -1 1; -1 1 -1; -1 -1 -1];

    endPointsImg = zeros(size(padImg));
    kernels = {kernel1, kernel2, kernel3, kernel4, kernel5, kernel6, kernel7, kernel8};
    for i = 1:length(kernels)
        hitmisImg = bwhitmiss(zerOneImg, kernels{i});
        endPointsImg = bitor(hitmisImg, endPointsImg);
    end

    endPointsImg = uint8(endPointsImg * 255);
    [rows, cols] = find(endPointsImg > 0);
    for i = 1:length(rows)
        endPoints = [endPoints; [cols(i), size(skeletonImg, 1) - rows(i) + 1]];
    end
end
