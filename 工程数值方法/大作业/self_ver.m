% MATLAB 工程数值方法大作业 

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
saveas(gcf, fullfile(outputDir, 'custom_a1_original_color.png'));

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
saveas(gcf, fullfile(outputDir, 'custom_a2_grayscale_photo.png'));

fprintf('任务 a 完成。\n\n');

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
% b) 图像压缩与恢复 (严格针对彩色图像，强化彩色差异可视化)
% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
fprintf('--- 任务 b: 彩色图像压缩、恢复与差异评估 ---\n');
% 压缩参数
compress_factor = 8;
original_size_hw = [size(original_image_rgb,1), size(original_image_rgb,2)]; % 高度x宽度

% --- 显式实现图像压缩 (子采样) ---
fprintf('执行图像压缩 (子采样)...\n');
[h_orig, w_orig, num_channels] = size(original_image_rgb);
h_comp = floor(h_orig / compress_factor);
w_comp = floor(w_orig / compress_factor);
compressed_image_rgb_custom = zeros(h_comp, w_comp, num_channels, class(original_image_rgb));

for c = 1:num_channels
    for i = 1:h_comp
        for j = 1:w_comp
            orig_r = (i-1) * compress_factor + 1;
            orig_c = (j-1) * compress_factor + 1;
            compressed_image_rgb_custom(i,j,c) = original_image_rgb(orig_r, orig_c, c);
        end
    end
end
fprintf('图像压缩完成。\n');

% --- 显式实现图像恢复 (双线性插值) ---
fprintf('执行图像恢复 (双线性插值)...\n');
restored_image_rgb_custom = zeros(h_orig, w_orig, num_channels, class(original_image_rgb));
original_image_double = double(compressed_image_rgb_custom); % 插值计算需要浮点数

for c = 1:num_channels
    for y_out = 1:h_orig
        for x_out = 1:w_orig
            % 将输出像素坐标映射回压缩图像的坐标 (可能是浮点数)
            x_in = (x_out - 0.5) / compress_factor + 0.5;
            y_in = (y_out - 0.5) / compress_factor + 0.5;

            % 获取整数部分和小数部分
            x1 = floor(x_in);
            y1 = floor(y_in);
            
            % 检查边界
            x1 = max(1, min(x1, w_comp));
            y1 = max(1, min(y1, h_comp));
            x2 = max(1, min(x1 + 1, w_comp));
            y2 = max(1, min(y1 + 1, h_comp));

            % 四个最近邻点的像素值
            Q11 = original_image_double(y1, x1, c);
            Q21 = original_image_double(y1, x2, c);
            Q12 = original_image_double(y2, x1, c);
            Q22 = original_image_double(y2, x2, c);

            % 计算插值权重 (小数部分)
            dx = x_in - x1;
            dy = y_in - y1;
            
            % 双线性插值公式
            % R1 = (x2 - x_in)/(x2 - x1)*Q11 + (x_in - x1)/(x2 - x1)*Q21;
            % R2 = (x2 - x_in)/(x2 - x1)*Q12 + (x_in - x1)/(x2 - x1)*Q22;
            % P  = (y2 - y_in)/(y2 - y1)*R1  + (y_in - y1)/(y2 - y1)*R2;
            % 简化后 (假设 x2-x1 = 1, y2-y1 = 1, 如果x1,x2等是单位间隔的)
            if x1 == x2 % 处理边缘情况，当x_in非常接近w_comp时
                R1 = Q11;
                R2 = Q12;
            else
                R1 = (1-dx)*Q11 + dx*Q21;
                R2 = (1-dx)*Q12 + dx*Q22;
            end

            if y1 == y2 % 处理边缘情况
                P = R1;
            else
                P = (1-dy)*R1 + dy*R2;
            end
            
            restored_image_rgb_custom(y_out, x_out, c) = cast(P, class(original_image_rgb));
        end
    end
end
fprintf('图像恢复完成。\n');

% 使用压缩和恢复的图像进行后续处理
restored_image_rgb = restored_image_rgb_custom; 
compressed_image_rgb = compressed_image_rgb_custom; 

% 显示压缩和恢复后的图像
figure_b1_b2 = figure; % 获取figure句柄
subplot(1,2,1); imshow(original_image_rgb); title('b.1: 原始彩色图像');
subplot(1,2,2); imshow(compressed_image_rgb); title(sprintf('b.2: 压缩后彩色图像 (1/%d)', compress_factor^2));
saveas(figure_b1_b2, fullfile(outputDir, 'custom_b1_b2_original_vs_compressed.png'));

figure_b3 = figure;
imshow(restored_image_rgb);
title_str_b3 = 'b.3: 恢复后的彩色图像 (双线性插值)';
title(title_str_b3);
saveas(figure_b3, fullfile(outputDir, 'custom_b3_restored_color.png'));

% 估算恢复后图像与原始图像的差异，并将差异可视化 (针对彩色图像)
fprintf('计算彩色图像差异与评估指标 (基于恢复)...\n');

% 1. 直接的彩色差异图像 (RGB通道各自的差异)
diff_image_color_channels = imabsdiff(original_image_rgb, restored_image_rgb);
figure_b4 = figure;
imshow(diff_image_color_channels);
title_str_b4 = 'b.4: 原始与恢复彩色图像的差异 (RGB各通道)';
title(title_str_b4);
saveas(figure_b4, fullfile(outputDir, 'custom_b4_diff_color_channels.png'));

% 2. 色彩差异幅度图 (单通道差异总和，用伪彩色显示)
diff_magnitude_map_gray = sum(double(diff_image_color_channels), 3); 
figure_b5 = figure;
imshow(diff_magnitude_map_gray, []); % 显示灰度幅值
colormap('parula'); % 应用伪彩色映射 (parula 或 jet)
colorbar; % 添加颜色条以表示差异幅度
title_str_b5 = 'b.5: 色彩差异幅度图 (伪彩色, 各通道差异之和)';
title(title_str_b5);
saveas(figure_b5, fullfile(outputDir, 'custom_b5_diff_magnitude_map_pseudocolor.png'));

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
saveas(figure_b6, fullfile(outputDir, 'custom_b6_rgb_channel_diff_histograms.png'));

fprintf('任务 b 完成。\n\n');


% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
% c) 自动面部双眼定位与尺寸估算 (使用工具箱进行人脸检测，眼部定位)
% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
fprintf('--- 任务 c: 面部检测与双眼定位 ---\n');
% 指定中文字体
chineseFont = 'SimSun';

% 步骤 c.1: 人脸检测 (保留 vision.CascadeObjectDetector)
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
    saveas(gcf, fullfile(outputDir, 'custom_c1_no_face_detected.png'));
    return; 
else
    bbox_face = bbox_face(1, :); 
    fprintf('检测到人脸，边界框: [x=%d, y=%d, width=%d, height=%d]\n', bbox_face(1), bbox_face(2), bbox_face(3), bbox_face(4));
    
    faceImage = imcrop(original_image_rgb, bbox_face);
    faceImageGray = imcrop(original_image_gray, bbox_face); % 使用原始灰度图的人脸部分

    figure;
    detected_face_image_annotated = insertObjectAnnotation(original_image_rgb, 'rectangle', bbox_face, '人脸', ...
                                                          'TextBoxOpacity', 0.8, 'FontSize', 18, 'Color', 'yellow', 'Font', chineseFont);
    imshow(detected_face_image_annotated);
    title_str_c1_ok = 'c.1: 检测到的人脸区域';
    title(title_str_c1_ok, 'FontName', chineseFont); 
    saveas(gcf, fullfile(outputDir, 'custom_c1_detected_face_area.png'));
    
    % 定义眼部搜索区域 (在人脸区域上半部分)
    x_roi_face = 1;
    y_roi_face = 1; 
    width_roi_face = size(faceImageGray, 2);
    height_roi_face = round(size(faceImageGray, 1) * 0.6); % 通常眼睛在脸的上半部分
    eyeSearchRegionGray = imcrop(faceImageGray, [x_roi_face, y_roi_face, width_roi_face, height_roi_face]);
    
    figure;
    imshow(eyeSearchRegionGray);
    title_str_c2_roi = 'c.2: 眼部搜索区域 (灰度)';
    title(title_str_c2_roi, 'FontName', chineseFont);
    saveas(gcf, fullfile(outputDir, 'custom_c2_eye_search_region_gray.png'));
end

% --- 步骤 c.2: 眼部定位 ---
fprintf('执行眼部定位...\n');

% c.2.1: 数值微分 (Sobel 算子) 获取边缘信息
fprintf('  c.2.1: 应用Sobel算子进行数值微分...\n');
eyeSearchRegionDouble = double(eyeSearchRegionGray);

% Sobel 算子核
Gx = [-1 0 1; -2 0 2; -1 0 1]; % x方向梯度
Gy = Gx';                      % y方向梯度 (Gx的转置)

% 使用 conv2 进行卷积，实现Sobel滤波
Ix = conv2(eyeSearchRegionDouble, Gx, 'same');
Iy = conv2(eyeSearchRegionDouble, Gy, 'same');

gradient_magnitude = sqrt(Ix.^2 + Iy.^2);

figure;
subplot(1,2,1); imshow(eyeSearchRegionGray); title('眼部搜索区域', 'FontName', chineseFont);
subplot(1,2,2); imshow(gradient_magnitude, []); title('Sobel梯度幅值', 'FontName', chineseFont);
sgtitle('c.2.1: Sobel算子边缘检测', 'FontName', chineseFont);
saveas(gcf, fullfile(outputDir, 'custom_c2_1_sobel_edges.png'));

% c.2.2: 候选瞳孔区域检测与简化圆形拟合
fprintf('  c.2.2: 检测候选瞳孔区域并进行简化圆形拟合...\n');
% 瞳孔是暗区，先对图像进行反相，使瞳孔变亮
inverted_eye_region = imcomplement(eyeSearchRegionGray); 

% 调整阈值策略：使用百分位数，选取反相后图像中非常亮的区域
% 例如，选取亮度在前5%或10%的像素作为候选。这个百分比可能需要根据图像调整。
brightness_percentile = 95; % 例如，选取最亮的5%的像素
threshold_val = prctile(inverted_eye_region(:), brightness_percentile); 
binary_pupils_initial = inverted_eye_region > threshold_val;

figure;
subplot(1,2,1); imshow(binary_pupils_initial); title(sprintf('初始二值化 (前%.0f%%亮度)', 100-brightness_percentile), 'FontName', chineseFont);

% 形态学操作：
% 1. 开运算：移除小的噪点，断开细小连接（比如瞳孔可能与眼角或睫毛阴影的微弱连接）
%    结构元的大小需要根据图像中瞳孔和干扰物的大小调整
se_open_radius = 1; % 开运算结构元半径，可尝试 1 或 2
se_open = strel('disk', se_open_radius);
binary_pupils_opened = imopen(binary_pupils_initial, se_open);

% 2. 闭运算：填充瞳孔内部可能存在的小洞
se_close_radius = 2; % 闭运算结构元半径，可尝试 2 或 3
se_close = strel('disk', se_close_radius);
binary_pupils_morph = imclose(binary_pupils_opened, se_close);

% 移除小的噪点区域 (在形态学操作后再次进行，确保清理)
min_blob_area_after_morph = 15; % 调整此值
binary_pupils = bwareaopen(binary_pupils_morph, min_blob_area_after_morph); 

subplot(1,2,2); imshow(binary_pupils); title('形态学处理后二值图', 'FontName', chineseFont);
sgtitle('c.2.2: 瞳孔候选区域提取过程', 'FontName', chineseFont);
saveas(gcf, fullfile(outputDir, 'custom_c2_2_binary_pupils_detailed.png'));

% 获取连通组件 (blobs)
cc = bwconncomp(binary_pupils);
% 增加 'Eccentricity' 用于形状筛选，瞳孔应接近圆形 (低偏心率)
stats = regionprops(cc, 'Centroid', 'Area', 'BoundingBox', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity');

potential_eyes = [];
% 参数调整：这些值非常依赖图像分辨率和具体人脸特征
min_pupil_area = 20;    % 最小瞳孔面积 (像素) - 根据图像中实际瞳孔大小调整
max_pupil_area = 300;   % 最大瞳孔面积 (像素) - 避免过大区域
max_eccentricity = 0.75; % 最大偏心率 (0为圆, 1为线段) - 瞳孔应较圆
min_aspect_ratio = 0.6; % 最小长宽比 (BoundingBox 宽度/高度)
max_aspect_ratio = 1.4; % 最大长宽比

for k = 1:length(stats)
    area = stats(k).Area;
    bbox = stats(k).BoundingBox;
    aspect_ratio = bbox(3) / bbox(4); % 宽度/高度
    eccentricity = stats(k).Eccentricity;
    
    % 几何约束筛选：面积、长宽比、偏心率
    if area >= min_pupil_area && area <= max_pupil_area && ...
       aspect_ratio >= min_aspect_ratio && aspect_ratio <= max_aspect_ratio && ...
       eccentricity < max_eccentricity
        
        center_x = stats(k).Centroid(1);
        center_y = stats(k).Centroid(2);
        % 简化圆形拟合：使用质心作为圆心，基于面积估算半径
        radius_est = sqrt(area / pi); 
        
        potential_eyes = [potential_eyes; struct('center', [center_x, center_y], 'radius', radius_est, 'metric', area * (1 - eccentricity))]; % metric考虑面积和圆度
        fprintf('  找到候选眼: 中心(%.1f, %.1f), 估算半径%.1f, 面积%.0f, 偏心率%.2f\n', center_x, center_y, radius_est, area, eccentricity);
    end
end

if isempty(potential_eyes)
    fprintf('未能通过方法找到候选眼部区域。\n');
    return;
end

% c.2.3: 双眼配对与筛选 
fprintf('  c.2.3: 筛选和配对双眼...\n');
num_potential_eyes = length(potential_eyes);
eye_centers_face_coords = []; % 存储最终确定的双眼在眼部搜索区域内的坐标
final_radii_pair = [];

if num_potential_eyes >= 2
    % 按metric（这里用面积）降序排序候选眼
    metrics = [potential_eyes.metric];
    [~, sort_idx] = sort(metrics, 'descend');
    potential_eyes_sorted = potential_eyes(sort_idx);
    
    num_to_consider = min(num_potential_eyes, 5); % 只考虑最可能的几个
    best_pair_score = -1;
    final_eye1_center_face = [];
    final_eye2_center_face = [];

    if num_to_consider >=2
        possible_pairs_indices = nchoosek(1:num_to_consider, 2);
        for k_pair = 1:size(possible_pairs_indices,1)
            idx1 = possible_pairs_indices(k_pair,1);
            idx2 = possible_pairs_indices(k_pair,2);
            
            eye1 = potential_eyes_sorted(idx1);
            eye2 = potential_eyes_sorted(idx2);
            
            c1 = eye1.center;
            c2 = eye2.center;
            r1 = eye1.radius;
            r2 = eye2.radius;
            
            % 几何约束 (与原代码类似)
            y_diff_eyes = abs(c1(2) - c2(2));
            % 适当放宽Y坐标差异约束，或基于半径大小调整
            allowed_y_diff = mean([r1, r2]) * 1.2 + height_roi_face * 0.05; % 结合相对和绝对差异
            
            x_diff_eyes = abs(c1(1) - c2(1));
            min_x_sep_eyes = (r1 + r2) * 1.2; % 最小眼间距，略微调整
            max_x_sep_eyes = width_roi_face * 0.85; % 最大眼间距
            
            radius_similarity = min(r1,r2) / max(r1,r2); % 半径相似度
            
            if y_diff_eyes < allowed_y_diff && ...
               x_diff_eyes > min_x_sep_eyes && x_diff_eyes < max_x_sep_eyes && ...
               radius_similarity > 0.45 % 两眼大小不能差异过大，略微放宽
           
                current_score = eye1.metric + eye2.metric; % 使用面积作为评分
                if current_score > best_pair_score
                    best_pair_score = current_score;
                    % 确保左眼在前
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
        fprintf('未能从检测结果中筛选出符合几何约束的一对眼睛。\n');
    end
    
elseif num_potential_eyes == 1
    fprintf('只找到一个候选眼，无法构成双眼。\n');
else
    fprintf('未能找到足够的候选眼区域。\n');
end

% 后续处理与显示 (与原代码类似，但基于 eye_centers_face_coords)
if size(eye_centers_face_coords, 1) < 2
    fprintf('自动眼部定位失败。\n');
    figure; imshow(eyeSearchRegionGray); hold on;
    if ~isempty(potential_eyes) % 显示所有找到的候选眼
        for k_eye = 1:length(potential_eyes)
            viscircles(potential_eyes(k_eye).center, potential_eyes(k_eye).radius, 'EdgeColor','r','LineWidth',0.5, 'LineStyle',':');
        end
    end
    hold off;
    title_str_c2_fail_custom = 'c.2: 眼部定位失败 (或未配对成功)';
    title(title_str_c2_fail_custom, 'FontName', chineseFont);
    saveas(gcf, fullfile(outputDir, 'custom_c2_custom_eye_detection_fail.png'));
    return;
else
    % 将眼部搜索区域内的坐标转换回人脸图像坐标
    eye_centers_in_face_image_coords = eye_centers_face_coords + [x_roi_face-1, y_roi_face-1];
    
    % 将人脸图像坐标转换回全局图像坐标
    left_eye_center_global = [eye_centers_in_face_image_coords(1,1) + bbox_face(1) - 1, ...
                              eye_centers_in_face_image_coords(1,2) + bbox_face(2) - 1];
    right_eye_center_global = [eye_centers_in_face_image_coords(2,1) + bbox_face(1) - 1, ...
                               eye_centers_in_face_image_coords(2,2) + bbox_face(2) - 1];
    fprintf('定位 - 左眼中心 (全局坐标): (%.1f, %.1f)\n', left_eye_center_global(1), left_eye_center_global(2));
    fprintf('定位 - 右眼中心 (全局坐标): (%.1f, %.1f)\n', right_eye_center_global(1), right_eye_center_global(2));
    
    figure;
    imshow(detected_face_image_annotated); % 这是带有人脸框的原始彩色图
    hold on;
    plot(left_eye_center_global(1), left_eye_center_global(2), 'b+', 'MarkerSize', 15, 'LineWidth', 2);
    text(left_eye_center_global(1)+10, left_eye_center_global(2), '左眼(自)', 'Color', 'blue', 'FontSize', 14, 'FontName', chineseFont);
    plot(right_eye_center_global(1), right_eye_center_global(2), 'b+', 'MarkerSize', 15, 'LineWidth', 2);
    text(right_eye_center_global(1)+10, right_eye_center_global(2), '右眼(自)', 'Color', 'blue', 'FontSize', 14, 'FontName', chineseFont);
    title_str_c2_2_custom = 'c.2.2: 定位的双眼中心';
    title(title_str_c2_2_custom, 'FontName', chineseFont);
    hold off;
    saveas(gcf, fullfile(outputDir, 'custom_c2_2_detected_eyes.png'));
    
    % 在眼部搜索区域显示检测到的双眼
    if exist('eyeSearchRegionGray','var') && ~isempty(final_radii_pair)
        figure; imshow(eyeSearchRegionGray); hold on;
        viscircles(eye_centers_face_coords(1,:), final_radii_pair(1),'EdgeColor','b'); 
        viscircles(eye_centers_face_coords(2,:), final_radii_pair(2),'EdgeColor','b'); 
        title_str_c2_3_custom = 'c.2.3: 方法定位的双眼 (在眼部搜索区域)';
        title(title_str_c2_3_custom, 'FontName', chineseFont);
        hold off;
        saveas(gcf, fullfile(outputDir, 'custom_c2_3_eyes_in_roi.png'));
    end
    
    inter_pupillary_distance_pixels = norm(left_eye_center_global - right_eye_center_global);
    fprintf('两眼之间的像素距离 (方法): %.2f 像素\n', inter_pupillary_distance_pixels);
    
    % 参考尺寸计算部分保持不变
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
    saveas(gcf, fullfile(outputDir, 'custom_d1_1_face_for_LBP.png'));

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
                saveas(gcf, fullfile(outputDir, 'custom_d1_2_LBP_example.png'));
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