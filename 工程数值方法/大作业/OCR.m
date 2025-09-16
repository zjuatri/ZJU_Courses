fprintf('d.2: 字母识别 (OCR) 尝试\n');

% 定义输出目录
outputDir = 'output';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
    fprintf('已创建输出目录: %s\n', outputDir);
end

% 指定中文字体
chineseFont = 'SimSun'; 

% 尝试从当前文件夹加载photo.jpeg
photoPath = fullfile(pwd, 'photo.jpg');
if exist(photoPath, 'file')
    try
        photo_image = imread(photoPath);
        fprintf('已成功加载photo.jpeg作为输入图片\n');
        
        % 将加载的图片转换为必要的格式
        if size(photo_image, 3) == 3  % 彩色图像
            photo_image_rgb = photo_image;
            photo_image_gray = rgb2gray(photo_image);
        else  % 灰度图像
            photo_image_gray = photo_image;
            photo_image_rgb = repmat(photo_image, [1, 1, 3]);
        end
        
        % 使用加载的图片替代原始图片
        original_image_rgb = photo_image_rgb;
        original_image_gray = photo_image_gray;
        fprintf('已使用photo.jpeg替代原始图片进行OCR\n');
    catch ME_read
        fprintf('读取photo.jpeg时出错: %s\n使用原始图片继续\n', ME_read.message);
    end
else
    fprintf('未找到photo.jpeg，使用原始图片继续\n');
end

try
    fprintf('对整个灰度图像进行OCR...\n');
    
    % 图像预处理 - 针对游戏界面优化
    processed_image = original_image_gray;
    
    % 1. 首先尝试多种预处理方案
    fprintf('尝试多种预处理方案...\n');
    
    % 方案1：标准预处理
    proc1 = imadjust(processed_image);
    proc1 = medfilt2(proc1, [3 3]);
    sharp_filter = [0 -1 0; -1 5 -1; 0 -1 0];
    proc1 = imfilter(proc1, sharp_filter, 'replicate');
    proc1 = im2uint8(proc1);
    
    % 方案2：增强对比度
    proc2 = adapthisteq(processed_image, 'ClipLimit', 0.02);
    proc2 = imadjust(proc2, stretchlim(proc2), []);
    proc2 = im2uint8(proc2);
    
    % 方案3：二值化处理
    proc3 = imbinarize(processed_image, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.4);
    proc3 = uint8(proc3) * 255;
    
    % 方案4：反相二值化
    proc4 = imbinarize(processed_image, 'adaptive', 'ForegroundPolarity', 'bright', 'Sensitivity', 0.4);
    proc4 = uint8(proc4) * 255;
    
    % 保存预处理结果用于调试
    figure;
    subplot(2,2,1); imshow(proc1); title('标准预处理', 'FontName', chineseFont);
    subplot(2,2,2); imshow(proc2); title('增强对比度', 'FontName', chineseFont);
    subplot(2,2,3); imshow(proc3); title('暗文字二值化', 'FontName', chineseFont);
    subplot(2,2,4); imshow(proc4); title('亮文字二值化', 'FontName', chineseFont);
    sgtitle('OCR预处理方案对比', 'FontName', chineseFont, 'FontSize', 16);
    saveas(gcf, fullfile(outputDir, 'd2_0_preprocessed_comparison.png'));
    fprintf('已保存预处理对比图: d2_0_preprocessed_comparison.png\n');
    
    % 扩展字符集 - 包含数字、字母和常见符号
    expectedChars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,!?;:()[]{}+-*/=@#$%^&_|~`"''<>\ ';
    
    % 对每种预处理方案尝试OCR
    allValidWords = {};
    allValidBoxes = [];
    allValidConfidences = [];
    
    preprocess_methods = {proc1, proc2, proc3, proc4};
    method_names = {'标准预处理', '增强对比度', '暗文字二值化', '亮文字二值化'};
    
    for method_idx = 1:length(preprocess_methods)
        fprintf('\n=== 尝试%s ===\n', method_names{method_idx});
        current_image = preprocess_methods{method_idx};
        
        try
            % 尝试基础OCR识别
            ocrResults = ocr(current_image, 'Model', 'english', 'CharacterSet', expectedChars);
            
            fprintf('原始OCR识别结果分析 (%s):\n', method_names{method_idx});
            if ~isempty(ocrResults.Words)
                for i = 1:length(ocrResults.Words)
                    word = ocrResults.Words{i};
                    confidence = ocrResults.WordConfidences(i);
                    bbox = ocrResults.WordBoundingBoxes(i,:);
                    
                    fprintf('单词 %d: "%s" (置信度: %.2f)\n', i, word, confidence);
                    
                    wordTrimmed = strtrim(word);
                    % 调整置信度门槛到0.5，特别针对游戏界面
                    if ~isempty(wordTrimmed) && ...
                       length(wordTrimmed) >= 1 && length(wordTrimmed) <= 50 && ...
                       confidence > 0.5 && ... % 置信度要求到.5
                       bbox(3) > 3 && bbox(4) > 3
                        
                        fprintf('  -> 识别到有效文本: "%s" (置信度: %.2f)\n', wordTrimmed, confidence);
                        allValidWords{end+1} = wordTrimmed; 
                        allValidBoxes = [allValidBoxes; bbox];
                        allValidConfidences = [allValidConfidences; confidence];
                    else
                        if ~isempty(wordTrimmed) && confidence <= 0.5
                            fprintf('  -> 置信度过低，已过滤: "%s" (置信度: %.2f)\n', wordTrimmed, confidence);
                        end
                    end
                end
            else
                fprintf('此方法未识别到任何文字\n');
            end
            
            % 如果标准OCR失败，尝试更宽松的参数
            if isempty(ocrResults.Words)
                fprintf('尝试更宽松的OCR参数...\n');
                relaxedResults = ocr(current_image);
                if ~isempty(relaxedResults.Words)
                    for i = 1:length(relaxedResults.Words)
                        word = relaxedResults.Words{i};
                        confidence = relaxedResults.WordConfidences(i);
                        bbox = relaxedResults.WordBoundingBoxes(i,:);
                        
                        wordTrimmed = strtrim(word);
                        if ~isempty(wordTrimmed) && confidence > 0.5
                            fprintf('  -> 宽松模式识别: "%s" (置信度: %.2f)\n', wordTrimmed, confidence);
                            allValidWords{end+1} = wordTrimmed;
                            allValidBoxes = [allValidBoxes; bbox];
                            allValidConfidences = [allValidConfidences; confidence];
                        end
                    end
                end
            end
            
        catch ME_method
            fprintf('预处理方法 %s 出错: %s\n', method_names{method_idx}, ME_method.message);
        end
    end

    % 汇总所有结果并去重
    if ~isempty(allValidWords)
        fprintf('\n=== 原始识别结果汇总 ===\n');
        for i = 1:length(allValidWords)
            fprintf('- "%s" (置信度: %.2f)\n', allValidWords{i}, allValidConfidences(i));
        end
        
        % 去重处理：对于相同的文本，只保留置信度最高的一个
        fprintf('\n=== 去重处理 ===\n');
        uniqueWords = {};
        uniqueBoxes = [];
        uniqueConfidences = [];
        
        % 获取所有唯一的文本
        [sortedWords, sortIdx] = sort(allValidWords);
        sortedConfidences = allValidConfidences(sortIdx);
        sortedBoxes = allValidBoxes(sortIdx, :);
        
        i = 1;
        while i <= length(sortedWords)
            currentWord = sortedWords{i};
            maxConfidence = sortedConfidences(i);
            bestIdx = i;
            
            % 查找所有相同的文本，找出置信度最高的
            j = i + 1;
            while j <= length(sortedWords) && strcmp(sortedWords{j}, currentWord)
                if sortedConfidences(j) > maxConfidence
                    maxConfidence = sortedConfidences(j);
                    bestIdx = j;
                end
                fprintf('发现重复文本 "%s"，置信度 %.2f（已合并）\n', sortedWords{j}, sortedConfidences(j));
                j = j + 1;
            end
            
            % 保留置信度最高的那个
            uniqueWords{end+1} = sortedWords{bestIdx};
            uniqueConfidences = [uniqueConfidences; sortedConfidences(bestIdx)];
            uniqueBoxes = [uniqueBoxes; sortedBoxes(bestIdx, :)];
            
            fprintf('保留 "%s" (最高置信度: %.2f)\n', currentWord, maxConfidence);
            
            i = j; % 跳过所有相同的文本
        end
        
        fprintf('\n=== 去重后的最终识别结果 ===\n');
        for i = 1:length(uniqueWords)
            fprintf('- "%s" (置信度: %.2f)\n', uniqueWords{i}, uniqueConfidences(i));
        end
        
        % 使用去重后的结果显示，修复字体警告
        try
            recognizedImage = insertObjectAnnotation(original_image_rgb, ...
                                'rectangle', uniqueBoxes, ...
                                uniqueWords, ...
                                'TextBoxOpacity', 0.9, 'FontSize', 24, ...
                                'TextColor', 'black', 'Color', 'yellow', 'LineWidth', 4, ... 
                                'Font', 'Arial'); % 指定字体以避免警告
        catch ME_font
            % 如果指定字体失败，使用默认设置但不显示中文字符
            fprintf('字体设置失败，使用默认字体: %s\n', ME_font.message);
            recognizedImage = insertObjectAnnotation(original_image_rgb, ...
                                'rectangle', uniqueBoxes, ...
                                uniqueWords, ...
                                'TextBoxOpacity', 0.9, 'FontSize', 24, ... 
                                'TextColor', 'black', 'Color', 'yellow', 'LineWidth', 4); 
        end
        fprintf('已标注 %d 个去重后的文本区域\n', length(uniqueWords));
        
        % 保存原始图像用于对比
        figure('Position', [100, 100, 1200, 600]);
        subplot(1,2,1);
        imshow(original_image_rgb);
        title('原始图像', 'FontName', chineseFont, 'FontSize', 14);
        
        subplot(1,2,2);
        imshow(recognizedImage);
        title('OCR识别结果 (去重后)', 'FontName', chineseFont, 'FontSize', 14);
        
        sgtitle(sprintf('OCR处理前后对比 - 识别到%d个文本', length(uniqueWords)), ...
                'FontName', chineseFont, 'FontSize', 16);
        saveas(gcf, fullfile(outputDir, 'd2_1_before_after_comparison.png'));
        fprintf('已保存处理前后对比图: d2_1_before_after_comparison.png\n');
        
    else
        fprintf('\n=== 所有预处理方法都未识别到有效文本（置信度>0.5） ===\n');
        fprintf('可能的原因：\n');
        fprintf('1. 图像中的文字使用了特殊字体或效果\n');
        fprintf('2. 文字与背景对比度不够\n');
        fprintf('3. 文字可能是渲染的图形而非标准字符\n');
        fprintf('4. 图像分辨率或质量不适合OCR识别\n');
        fprintf('5. 置信度门槛设置为0.5，可能过滤了一些低置信度结果\n');
        
        % 尝试手动分析图像特征
        fprintf('\n图像特征分析：\n');
        fprintf('图像尺寸: %d x %d\n', size(original_image_gray, 2), size(original_image_gray, 1));
        fprintf('图像类型: %s\n', class(original_image_gray));
        fprintf('亮度范围: %d - %d\n', min(original_image_gray(:)), max(original_image_gray(:)));
        
        recognizedImage = original_image_rgb;
        uniqueWords = {};
        
        % 即使没有识别到文本，也保存处理过程图
        figure('Position', [100, 100, 1200, 600]);
        subplot(1,2,1);
        imshow(original_image_rgb);
        title('原始图像', 'FontName', chineseFont, 'FontSize', 14);
        
        subplot(1,2,2);
        imshow(original_image_rgb);
        title('OCR识别结果 (未检测到文本)', 'FontName', chineseFont, 'FontSize', 14);
        
        sgtitle('OCR处理前后对比 - 未识别到有效文本', 'FontName', chineseFont, 'FontSize', 16);
        saveas(gcf, fullfile(outputDir, 'd2_1_before_after_comparison.png'));
        fprintf('已保存处理前后对比图: d2_1_before_after_comparison.png\n');
    end
    
    % 显示最终结果
    figure;
    imshow(recognizedImage);
    title_str_d2_1 = 'd.2.1: OCR识别结果 (去重后, 置信度>0.5) - 框标识文本位置';
    title(title_str_d2_1, 'FontName', chineseFont);
    
    % 添加说明文字
    if ~isempty(uniqueWords)
        legend_str = sprintf('黄色框: 识别到 %d 个唯一文本区域', length(uniqueWords));
    else
        legend_str = '未检测到文本区域 (置信度>0.5)';
    end
    
    text(10, 30, legend_str, 'Color', 'white', 'FontSize', 16, ... 
         'BackgroundColor', 'black', 'FontName', chineseFont);
    
    saveas(gcf, fullfile(outputDir, 'd2_1_OCR_results.png'));
    fprintf('已保存最终OCR结果图: d2_1_OCR_results.png\n');
    
    % 输出最终的OCR完整结果
    if exist('uniqueWords', 'var') && ~isempty(uniqueWords)
        fprintf('\n最终OCR完整结果: %s\n', strjoin(uniqueWords, ' '));
    end
    
    % 输出所有生成的图片文件列表
    fprintf('\n=== 生成的图片文件 ===\n');
    fprintf('1. d2_0_preprocessed_comparison.png - 预处理方案对比\n');
    fprintf('2. d2_1_before_after_comparison.png - 处理前后对比\n');
    fprintf('3. d2_1_OCR_results.png - 最终OCR识别结果\n');
    
catch ME_ocr
    fprintf('执行OCR时出错: %s\n', ME_ocr.message);
end