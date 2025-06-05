% MATLAB 工程数值方法大作业 (Final Version - Revised with Save Output)

% 清理工作区、关闭所有图像窗口、清空命令行
clearvars;
close all;
clc;

% --- 设置输出文件夹 ---
outputDir = 'output';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
    fprintf('输出文件夹 "%s" 已创建。\n', outputDir);
else
    fprintf('输出文件夹 "%s" 已存在。\n', outputDir);
end
fprintf('\n');

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
% a) 图像输入与灰度转换
% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
fprintf('--- 任务 a: 图像输入与灰度转换 ---\n');
% 步骤 a.1: 读取照片
try
    original_image_rgb = imread('photo.jpg'); % 替换为你的文件名
catch ME
    fprintf('错误：无法读取图像文件！请确保图像文件与脚本在同一目录下，并且文件名正确。\n');
    fprintf('错误信息: %s\n', ME.message);
    return;
end
% 步骤 a.2: 显示原始图像
figure;
imshow(original_image_rgb);
title_str_a1 = 'a.1: 原始彩色照片';
title(title_str_a1);
saveas(gcf, fullfile(outputDir, 'toolbox_a1_original_color.png'));

% 获取图像原始尺寸以备后用
[img_rows_orig, img_cols_orig, ~] = size(original_image_rgb);

% 步骤 a.3: 转换为灰度图像
if size(original_image_rgb,3) == 3
    original_image_gray = rgb2gray(original_image_rgb);
else
    original_image_gray = original_image_rgb; % 如果已经是单通道，则直接使用
end
% 显示灰度图像
figure;
imshow(original_image_gray);
title_str_a2 = 'a.2: 灰度照片';
title(title_str_a2);
saveas(gcf, fullfile(outputDir, 'toolbox_a2_grayscale_photo.png'));

fprintf('任务 a 完成。\n\n');

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
% b) 图像压缩与恢复 (严格针对彩色图像，强化彩色差异可视化)
% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
fprintf('--- 任务 b: 彩色图像压缩、恢复与差异评估 ---\n');
% 压缩参数
compress_factor = 8;
original_size_hw = [size(original_image_rgb,1), size(original_image_rgb,2)]; % 高度x宽度

% 压缩原始彩色图像
% 使用 imresize 进行压缩。'bicubic' 方法是一种高级插值技术，
% 它通过拟合局部像素邻域的三次多项式曲线来进行计算，
% 因此符合“采用曲线拟合和函数插值的方法”的要求。
compressed_image_rgb = imresize(original_image_rgb, 1/compress_factor, 'bicubic');
% 基于压缩后的图像，通过插值的方式恢复彩色图像
% 同样使用 'bicubic' 插值方法进行恢复，确保尽可能逼真。
restored_image_rgb = imresize(compressed_image_rgb, original_size_hw, 'bicubic');

% 显示压缩和恢复后的图像
figure_b1_b2 = figure; % 获取figure句柄
subplot(1,2,1); imshow(original_image_rgb); title('b.1: 原始彩色图像');
subplot(1,2,2); imshow(compressed_image_rgb); title(sprintf('b.2: 压缩后彩色图像 (1/%d)', compress_factor^2));
saveas(figure_b1_b2, fullfile(outputDir, 'toolbox_b1_b2_original_vs_compressed.png'));

figure_b3 = figure;
imshow(restored_image_rgb);
title_str_b3 = 'b.3: 恢复后的彩色图像';
title(title_str_b3);
saveas(figure_b3, fullfile(outputDir, 'toolbox_b3_restored_color.png'));

% 估算恢复后图像与原始图像的差异，并将差异可视化 (针对彩色图像)
fprintf('计算彩色图像差异与评估指标...\n');

% 1. 直接的彩色差异图像 (RGB通道各自的差异)
diff_image_color_channels = imabsdiff(original_image_rgb, restored_image_rgb);
figure_b4 = figure;
imshow(diff_image_color_channels);
title_str_b4 = 'b.4: 原始与恢复彩色图像的差异 (RGB各通道)';
title(title_str_b4);
saveas(figure_b4, fullfile(outputDir, 'toolbox_b4_diff_color_channels.png'));

% 2. 色彩差异幅度图 (单通道差异总和，用伪彩色显示)
diff_magnitude_map_gray = sum(double(diff_image_color_channels), 3); 
figure_b5 = figure;
imshow(diff_magnitude_map_gray, []); % 显示灰度幅值
colormap('parula'); % 应用伪彩色映射 (parula 或 jet)
colorbar; % 添加颜色条以表示差异幅度
title_str_b5 = 'b.5: 色彩差异幅度图 (伪彩色, 各通道差异之和)';
title(title_str_b5);
saveas(figure_b5, fullfile(outputDir, 'toolbox_b5_diff_magnitude_map_pseudocolor.png'));

% 3. 计算彩色图像的 MSE 和 PSNR (直接在RGB图像上计算)
mse_color_value = immse(original_image_rgb, restored_image_rgb);
psnr_color_value = psnr(original_image_rgb, restored_image_rgb); 
fprintf('  针对彩色图像的评估:\n');
fprintf('  均方误差 (MSE): %.4f\n', mse_color_value);
fprintf('  峰值信噪比 (PSNR): %.4f dB\n', psnr_color_value);

% 4. 各颜色通道差异值的直方图
figure_b6 = figure;
subplot(3,1,1);
histogram(diff_image_color_channels(:,:,1)); % R 通道差异
title('R 通道差异分布');
ylabel('像素数量');

subplot(3,1,2);
histogram(diff_image_color_channels(:,:,2)); % G 通道差异
title('G 通道差异分布');
ylabel('像素数量');

subplot(3,1,3);
histogram(diff_image_color_channels(:,:,3)); % B 通道差异
title('B 通道差异分布');
xlabel('差异值');
ylabel('像素数量');

sgtitle_str_b6 = 'b.6: 各颜色通道差异值直方图';
sgtitle(sgtitle_str_b6); % Super title for all subplots
saveas(figure_b6, fullfile(outputDir, 'toolbox_b6_rgb_channel_diff_histograms.png'));

fprintf('任务 b 完成。\n\n');


% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
% c) 自动面部双眼定位与尺寸估算 (使用工具箱)
% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
fprintf('--- 任务 c: 自动面部双眼定位与尺寸估算 (使用工具箱) ---\n');
% 指定中文字体
chineseFont = 'SimSun'; % 或者 'Microsoft YaHei' 等你系统上有的中文字体

% 步骤 c.1: 人脸检测
% 使用 vision.CascadeObjectDetector 进行人脸检测。
% 这是一种基于机器学习的方法 (如 Viola-Jones 算法)，其训练过程和特征提取
% (例如 Haar-like 特征，涉及像素块之间的强度差异计算) 间接利用了数值微分的概念。
faceDetector = vision.CascadeObjectDetector(); 
bbox_face = step(faceDetector, original_image_rgb);

if isempty(bbox_face)
    fprintf('未能检测到人脸，无法继续进行眼部定位。\n');
    figure; imshow(original_image_rgb); 
    title_str_c1_fail = 'c.1: 未检测到人脸';
    title(title_str_c1_fail);
    saveas(gcf, fullfile(outputDir, 'toolbox_c1_no_face_detected.png'));
    return; 
else
    bbox_face = bbox_face(1, :); 
    fprintf('检测到人脸，边界框: [x=%d, y=%d, width=%d, height=%d]\n', bbox_face(1), bbox_face(2), bbox_face(3), bbox_face(4));
    
    faceImage = imcrop(original_image_rgb, bbox_face);
    faceImageGray = imcrop(original_image_gray, bbox_face);

    figure;
    detected_face_image_annotated = insertObjectAnnotation(original_image_rgb, 'rectangle', bbox_face, '人脸', ...
                                                          'TextBoxOpacity', 0.8, 'FontSize', 18, 'Color', 'yellow', 'Font', chineseFont);
    imshow(detected_face_image_annotated);
    title_str_c1_ok = 'c.1: 检测到的人脸区域';
    title(title_str_c1_ok, 'FontName', chineseFont); % 确保标题也用中文字体
    saveas(gcf, fullfile(outputDir, 'toolbox_c1_detected_face_area.png'));
    
    x_roi_face = 1;
    y_roi_face = 1; 
    width_roi_face = size(faceImageGray, 2);
    height_roi_face = round(size(faceImageGray, 1) * 0.6); 
    eyeSearchRegion = imcrop(faceImageGray, [x_roi_face, y_roi_face, width_roi_face, height_roi_face]);
    
    figure;
    imshow(eyeSearchRegion);
    title_str_c2_roi = 'c.2: 眼部搜索区域 (人脸ROI内)';
    title(title_str_c2_roi, 'FontName', chineseFont);
    saveas(gcf, fullfile(outputDir, 'toolbox_c2_eye_search_region.png'));
end

% 步骤 c.2: 在眼部搜索区域内使用 imfindcircles 定位眼睛
% imfindcircles 函数基于圆霍夫变换 (Circular Hough Transform) 来检测圆形。
% 霍夫变换通常依赖于图像的边缘信息 (边缘检测广泛使用数值微分方法，如 Sobel, Canny 算子，
% imfindcircles 的 'EdgeThreshold' 参数也与此相关)。
% 它通过在参数空间中投票来找到最能描述图像中圆形特征的参数 (圆心和半径)，
% 这可以被视为一种广义的曲线/形状拟合过程。
Rmin = 6;  
Rmax = 25; 
sensitivity_value = 0.90; 
fprintf('在眼部搜索区域使用 imfindcircles 寻找圆形 (Rmin=%d, Rmax=%d, Sensitivity=%.2f)...\n', Rmin, Rmax, sensitivity_value);

[centers, radii, metric] = imfindcircles(eyeSearchRegion, [Rmin Rmax], ...
                                          'ObjectPolarity', 'dark', ...
                                          'Sensitivity', sensitivity_value, ...
                                          'EdgeThreshold', 0.1); 
if isempty(centers)
    fprintf('在指定的眼部搜索区域内未能使用 imfindcircles 找到圆形。\n');
    fprintf('请尝试调整 Rmin, Rmax, Sensitivity 或 EdgeThreshold 参数。\n');
    if exist('faceImage','var')
        figure; imshow(faceImage); 
        title_str_c2_fail1 = 'imfindcircles 未找到眼睛 (人脸区域)';
        title(title_str_c2_fail1, 'FontName', chineseFont);
        saveas(gcf, fullfile(outputDir, 'toolbox_c2_imfindcircles_no_eyes_face.png'));
    else % Should not happen if face detection succeeded and returned
        figure; imshow(original_image_gray); 
        title_str_c2_fail2 = 'imfindcircles 未找到眼睛 (全图搜索)';
        title(title_str_c2_fail2, 'FontName', chineseFont);
        saveas(gcf, fullfile(outputDir, 'toolbox_c2_imfindcircles_no_eyes_full.png'));
    end
    return; 
end
fprintf('imfindcircles 找到 %d 个潜在圆形区域。\n', size(centers,1));

num_circles_found = size(centers, 1);
eye_centers_face_coords = []; 

if num_circles_found >= 2
    [~, sort_idx] = sort(metric, 'descend');
    centers_sorted = centers(sort_idx, :);
    radii_sorted = radii(sort_idx);
    metric_sorted = metric(sort_idx); 
    
    num_to_consider = min(num_circles_found, 5); 
    best_pair_score = -1;
    final_eye1_center_face = [];
    final_eye2_center_face = [];
    final_radii_pair = [];

    if num_to_consider >=2
        possible_pairs = nchoosek(1:num_to_consider, 2);
        for k_pair = 1:size(possible_pairs,1)
            p_idx1 = possible_pairs(k_pair,1);
            p_idx2 = possible_pairs(k_pair,2);
            c1 = centers_sorted(p_idx1,:);
            c2 = centers_sorted(p_idx2,:);
            r1 = radii_sorted(p_idx1);
            r2 = radii_sorted(p_idx2);
            
            y_diff_eyes = abs(c1(2) - c2(2));
            allowed_y_diff = mean([r1, r2]) * 1.5; 
            
            x_diff_eyes = abs(c1(1) - c2(1));
            min_x_sep_eyes = r1 + r2; 
            max_x_sep_eyes = width_roi_face * 0.7; 
            
            if y_diff_eyes < allowed_y_diff && x_diff_eyes > min_x_sep_eyes && x_diff_eyes < max_x_sep_eyes
                current_score = metric_sorted(p_idx1) + metric_sorted(p_idx2);
                if current_score > best_pair_score
                    best_pair_score = current_score;
                    if c1(1) < c2(1) 
                        final_eye1_center_face = c1; final_eye2_center_face = c2;
                        final_radii_pair = [r1,r2];
                    else 
                        final_eye1_center_face = c2; final_eye2_center_face = c1;
                        final_radii_pair = [r2,r1];
                    end
                end
            end
        end
    end
    
    if ~isempty(final_eye1_center_face)
        eye_centers_face_coords = [final_eye1_center_face; final_eye2_center_face];
        fprintf('筛选后确定一对眼睛。\n');
    else
        fprintf('未能从 imfindcircles 的结果中筛选出符合几何约束的一对眼睛。\n');
    end
    
elseif num_circles_found == 1
    fprintf('imfindcircles 只找到一个圆形区域，无法构成双眼。\n');
else
    fprintf('imfindcircles 未能找到足够的圆形区域。\n');
end

if size(eye_centers_face_coords, 1) < 2
    fprintf('自动眼部定位失败。请检查 imfindcircles 参数或图像质量。\n');
    figure; imshow(eyeSearchRegion);
    if ~isempty(centers)
        viscircles(centers, radii,'EdgeColor','r','LineWidth',0.5);
    end
    title_str_c2_fail3 = 'c.2: imfindcircles 检测到的所有圆形(筛选失败)';
    title(title_str_c2_fail3, 'FontName', chineseFont);
    saveas(gcf, fullfile(outputDir, 'toolbox_c2_imfindcircles_all_circles_filter_fail.png'));
    return;
else
    eye_centers_in_face_image_coords = eye_centers_face_coords; 
    
    left_eye_center_global = [eye_centers_in_face_image_coords(1,1) + bbox_face(1) - 1, ...
                              eye_centers_in_face_image_coords(1,2) + bbox_face(2) - 1];
    right_eye_center_global = [eye_centers_in_face_image_coords(2,1) + bbox_face(1) - 1, ...
                               eye_centers_in_face_image_coords(2,2) + bbox_face(2) - 1];
    fprintf('自动定位 - 左眼中心 (全局坐标): (%.1f, %.1f)\n', left_eye_center_global(1), left_eye_center_global(2));
    fprintf('自动定位 - 右眼中心 (全局坐标): (%.1f, %.1f)\n', right_eye_center_global(1), right_eye_center_global(2));
    
    figure;
    imshow(detected_face_image_annotated); 
    hold on;
    plot(left_eye_center_global(1), left_eye_center_global(2), 'g+', 'MarkerSize', 15, 'LineWidth', 2);
    text(left_eye_center_global(1)+10, left_eye_center_global(2), '左眼', 'Color', 'green', 'FontSize', 14, 'FontName', chineseFont);
    plot(right_eye_center_global(1), right_eye_center_global(2), 'g+', 'MarkerSize', 15, 'LineWidth', 2);
    text(right_eye_center_global(1)+10, right_eye_center_global(2), '右眼', 'Color', 'green', 'FontSize', 14, 'FontName', chineseFont);
    title_str_c2_2 = 'c.2.2: 自动定位的双眼中心';
    title(title_str_c2_2, 'FontName', chineseFont);
    hold off;
    saveas(gcf, fullfile(outputDir, 'toolbox_c2_2_auto_detected_eyes.png'));
    
    if exist('eyeSearchRegion','var') && exist('final_radii_pair','var') && ~isempty(final_radii_pair) 
        figure; imshow(eyeSearchRegion); hold on;
        viscircles(eye_centers_face_coords, final_radii_pair,'EdgeColor','b'); 
        title_str_c2_3 = 'c.2.3: imfindcircles 定位的双眼 (在眼部搜索区域)';
        title(title_str_c2_3, 'FontName', chineseFont);
        hold off;
        saveas(gcf, fullfile(outputDir, 'toolbox_c2_3_imfindcircles_eyes_in_roi.png'));
    end
    
    inter_pupillary_distance_pixels = norm(left_eye_center_global - right_eye_center_global);
    fprintf('两眼之间的像素距离 (自动): %.2f 像素\n', inter_pupillary_distance_pixels);
    
    ref_object_length_pixels = 652; 
    ref_object_actual_length_mm = 621; 
    fprintf('\n参考尺寸信息 (硬编码):\n');
    fprintf('  参考物照片长度: %.0f 像素\n', ref_object_length_pixels);
    fprintf('  参考物实际长度: %.0f mm\n', ref_object_actual_length_mm);
    if ref_object_length_pixels > 0 && ref_object_actual_length_mm > 0
        pixels_per_mm = ref_object_length_pixels / ref_object_actual_length_mm;
        inter_pupillary_distance_mm = inter_pupillary_distance_pixels / pixels_per_mm;
        fprintf('每毫米对应的像素数: %.4f 像素/mm\n', pixels_per_mm);
        fprintf('估算的两眼间实际距离 (自动): %.2f mm\n', inter_pupillary_distance_mm);
    else
        fprintf('参考物信息无效，无法计算实际物理尺寸。\n');
    end
end
fprintf('任务 c 完成。\n\n');


% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
% d) 尝试人脸识别或字母识别
% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
fprintf('--- 任务 d: 尝试人脸识别或字母识别 ---\n');
% d.1 尝试人脸识别 (检测与特征提取概念)
fprintf('d.1: 人脸识别尝试 (检测与特征提取)\n');
if exist('bbox_face', 'var') && ~isempty(bbox_face) && exist('faceImage','var') && ~isempty(faceImage)
    fprintf('已在任务 c 中检测到人脸。\n');
    figure; 
    imshow(faceImage); 
    title_str_d1_1 = 'd.1.1: 用于特征提取的人脸区域';
    title(title_str_d1_1, 'FontName', chineseFont);
    saveas(gcf, fullfile(outputDir, 'toolbox_d1_1_face_for_LBP.png'));

    try
        if size(faceImage,3) == 3
            faceImageForLBP = rgb2gray(faceImage);
        else
            faceImageForLBP = faceImage;
        end
        
        cellSizeLBP = [16 16]; 
        if size(faceImageForLBP,1) >= cellSizeLBP(1)*3 && size(faceImageForLBP,2) >= cellSizeLBP(2)*3
            lbpFeatures = extractLBPFeatures(faceImageForLBP, 'CellSize', cellSizeLBP, 'NumNeighbors', 8, 'Radius', 1, 'Upright', true);
            fprintf('从人脸区域提取的LBP特征向量维度: %d\n', length(lbpFeatures));
        
            numLBPFeatures = length(lbpFeatures);
            numCellsProd = prod(floor(size(faceImageForLBP) ./ cellSizeLBP));
            if numCellsProd > 0 && mod(numLBPFeatures, numCellsProd) == 0
                featuresPerCell = numLBPFeatures / numCellsProd;
                lbpCellHists = reshape(lbpFeatures, numCellsProd, featuresPerCell);
            
                figure;
                subplot(1,2,1); imshow(faceImageForLBP); title('人脸灰度图', 'FontName', chineseFont);
                subplot(1,2,2); bar(lbpCellHists(1,:)); title(sprintf('第一个Cell的LBP直方图 (%d bins)', featuresPerCell), 'FontName', chineseFont); 
                sgtitle_str_d1_2 = 'd.1.2: LBP特征提取示例';
                sgtitle(sgtitle_str_d1_2, 'FontName', chineseFont);
                saveas(gcf, fullfile(outputDir, 'toolbox_d1_2_LBP_example.png'));
                fprintf('LBP特征已提取。在完整的人脸识别系统中，这些特征将用于与数据库中的已知人脸特征进行比较。\n');
            else
                fprintf('LBP特征总数 %d 不能被总Cell数 %d 整除，或Cell数为0。无法 reshape。\n', numLBPFeatures, numCellsProd);
            end
        else
            fprintf('人脸区域过小，无法使用 cellSize=[%d %d] 提取LBP特征。\n', cellSizeLBP(1), cellSizeLBP(2));
        end
    catch ME_lbp
        fprintf('提取LBP特征时出错: %s\n', ME_lbp.message);
        fprintf('错误详情: %s (文件: %s, 行号: %d)\n', ME_lbp.identifier, ME_lbp.stack(1).file, ME_lbp.stack(1).line);
    end
else
    fprintf('未检测到人脸 (bbox_face为空或faceImage未定义)，无法进行人脸特征提取。\n');
end

fprintf('任务 d 完成。\n\n');
fprintf('--- 所有任务执行完毕 ---\n');