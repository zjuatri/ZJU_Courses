import cupy as cp
import numpy as np

class Conv2d:
    def __init__(self, in_channels: int, out_channels: int, kernel_size: int, 
                 stride: int = 1, padding: int = 0, dtype = None):
        # ------------------------------请完成此部分内容------------------------------
        self.in_channels = in_channels
        self.out_channels = out_channels
        self.kernel_size = kernel_size
        self.stride = stride
        self.padding = padding
        
        # Xavier初始化权重 - 使用CuPy
        self.weight = cp.random.normal(0, cp.sqrt(2.0 / (in_channels * kernel_size * kernel_size)), 
                                     (out_channels, in_channels, kernel_size, kernel_size)).astype(cp.float32)
        self.bias = cp.zeros((out_channels,), dtype=cp.float32)
        
        # 存储前向传播的输入，用于反向传播
        self.x = None
        # ---------------------------------------------------------------------------

    def forward(self, x):
        """
        x - shape (N, C, H, W)
        return the result of Conv2d with shape (N, O, H', W')
        """
        self.x = x
        N, C, H, W = x.shape
        
        # 添加padding - 使用CuPy
        if self.padding > 0:
            x_padded = cp.pad(x, ((0, 0), (0, 0), (self.padding, self.padding), (self.padding, self.padding)), mode='constant')
        else:
            x_padded = x
            
        # 计算输出尺寸
        H_out = (H + 2 * self.padding - self.kernel_size) // self.stride + 1
        W_out = (W + 2 * self.padding - self.kernel_size) // self.stride + 1
        
        # 初始化输出 - 使用CuPy
        out = cp.zeros((N, self.out_channels, H_out, W_out), dtype=cp.float32)
        
        # 优化的卷积运算 - 减少循环层数
        for n in range(N):
            for h in range(H_out):
                for w in range(W_out):
                    h_start = h * self.stride
                    w_start = w * self.stride
                    # 提取输入区域 (C, kernel_size, kernel_size)
                    x_region = x_padded[n, :, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size]
                    # 向量化计算所有输出通道
                    for o in range(self.out_channels):
                        out[n, o, h, w] = cp.sum(x_region * self.weight[o]) + self.bias[o]
        
        return out

    def backward(self, dy, lr):
        """
        dy - the gradient of last layer with shape (N, O, H', W')
        lr - learning rate
        """
        N, C, H, W = self.x.shape
        N, O, H_out, W_out = dy.shape
        
        # 添加padding
        if self.padding > 0:
            x_padded = cp.pad(self.x, ((0, 0), (0, 0), (self.padding, self.padding), (self.padding, self.padding)), mode='constant')
        else:
            x_padded = self.x
            
        # 计算权重梯度 - 优化版本
        dw = cp.zeros_like(self.weight)
        for n in range(N):
            for h in range(H_out):
                for w in range(W_out):
                    h_start = h * self.stride
                    w_start = w * self.stride
                    x_region = x_padded[n, :, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size]
                    # 向量化计算权重梯度
                    for o in range(O):
                        dw[o] += dy[n, o, h, w] * x_region
        
        # 计算偏置梯度
        db = cp.sum(dy, axis=(0, 2, 3))
        
        # 简化的输入梯度计算
        dx = cp.zeros_like(self.x)
        for n in range(N):
            for h in range(H_out):
                for w in range(W_out):
                    h_start = h * self.stride
                    w_start = w * self.stride
                    for o in range(O):
                        # 累加梯度到对应的输入位置
                        h_end = min(h_start + self.kernel_size, H + 2 * self.padding)
                        w_end = min(w_start + self.kernel_size, W + 2 * self.padding)
                        
                        # 计算有效区域
                        dx_h_start = max(0, h_start - self.padding)
                        dx_w_start = max(0, w_start - self.padding)
                        dx_h_end = min(H, h_end - self.padding)
                        dx_w_end = min(W, w_end - self.padding)
                        
                        if dx_h_start < dx_h_end and dx_w_start < dx_w_end:
                            # 计算权重区域
                            w_h_start = dx_h_start - (h_start - self.padding)
                            w_w_start = dx_w_start - (w_start - self.padding)
                            w_h_end = w_h_start + (dx_h_end - dx_h_start)
                            w_w_end = w_w_start + (dx_w_end - dx_w_start)
                            
                            dx[n, :, dx_h_start:dx_h_end, dx_w_start:dx_w_end] += \
                                dy[n, o, h, w] * self.weight[o, :, w_h_start:w_h_end, w_w_start:w_w_end]
        
        # 更新权重和偏置
        self.weight -= lr * dw
        self.bias -= lr * db
        
        return dx

class ReLU:
    def forward(self, x):
        self.x = x
        return cp.maximum(0, x)
      
    def backward(self, dy):
        return dy * (self.x > 0)

class Tanh:
    def forward(self, x):
        self.output = cp.tanh(x)
        return self.output

    def backward(self, dy):
        return dy * (1 - self.output ** 2)
        
class Sigmoid:
    def forward(self, x):
        self.output = 1 / (1 + cp.exp(-cp.clip(x, -500, 500)))  # 防止溢出
        return self.output
       
    def backward(self, dy):
        return dy * self.output * (1 - self.output)
       
class MaxPool2d:
    def __init__(self, kernel_size: int, stride = None, padding = 0):
        self.kernel_size = kernel_size
        self.stride = stride if stride is not None else kernel_size
        self.padding = padding

    def forward(self, x):
        """
        x - shape (N, C, H, W)
        return the result of MaxPool2d with shape (N, C, H', W')
        """
        self.x = x
        N, C, H, W = x.shape
        
        H_out = (H - self.kernel_size) // self.stride + 1
        W_out = (W - self.kernel_size) // self.stride + 1
        
        out = cp.zeros((N, C, H_out, W_out), dtype=cp.float32)
        self.mask = cp.zeros_like(x)
        
        # 优化的池化操作
        for n in range(N):
            for c in range(C):
                for h in range(H_out):
                    for w in range(W_out):
                        h_start = h * self.stride
                        w_start = w * self.stride
                        pool_region = x[n, c, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size]
                        max_val = cp.max(pool_region)
                        out[n, c, h, w] = max_val
                        
                        # 记录最大值位置用于反向传播
                        max_mask = (pool_region == max_val)
                        self.mask[n, c, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size] = max_mask
        
        return out

    def backward(self, dy):
        """
        dy - shape (N, C, H', W')
        return the result of gradient dx with shape (N, C, H, W)
        """
        N, C, H_out, W_out = dy.shape
        dx = cp.zeros_like(self.x)
        
        # 优化的反向传播
        for n in range(N):
            for c in range(C):
                for h in range(H_out):
                    for w in range(W_out):
                        h_start = h * self.stride
                        w_start = w * self.stride
                        dx[n, c, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size] += \
                            dy[n, c, h, w] * self.mask[n, c, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size]
        
        return dx

class AvgPool2d:
    def __init__(self, kernel_size: int, stride = None, padding = 0):
        self.kernel_size = kernel_size
        self.stride = stride if stride is not None else kernel_size
        self.padding = padding
       
    def forward(self, x):
        """
        x - shape (N, C, H, W)
        return the result of AvgPool2d with shape (N, C, H', W')
        """
        self.x = x
        N, C, H, W = x.shape
        
        H_out = (H - self.kernel_size) // self.stride + 1
        W_out = (W - self.kernel_size) // self.stride + 1
        
        out = cp.zeros((N, C, H_out, W_out), dtype=cp.float32)
        
        # 优化的池化操作
        for n in range(N):
            for c in range(C):
                for h in range(H_out):
                    h_start = h * self.stride
                    for w in range(W_out):
                        w_start = w * self.stride
                        pool_region = x[n, c, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size]
                        out[n, c, h, w] = cp.mean(pool_region)
        
        return out

    def backward(self, dy):
        """
        dy - shape (N, C, H', W')
        return the result of gradient dx with shape (N, C, H, W)
        """
        N, C, H_out, W_out = dy.shape
        dx = cp.zeros_like(self.x)
        
        # 优化的反向传播
        for n in range(N):
            for c in range(C):
                for h in range(H_out):
                    h_start = h * self.stride
                    for w in range(W_out):
                        w_start = w * self.stride
                        # 平均池化的梯度平均分配到每个位置
                        dx[n, c, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size] += \
                            dy[n, c, h, w] / (self.kernel_size * self.kernel_size)
        
        return dx

class Linear:
    def __init__(self, in_features: int, out_features: int, bias: bool = True):
        self.in_features = in_features
        self.out_features = out_features
        self.use_bias = bias
        
        # Xavier初始化 - 使用CuPy
        self.weight = cp.random.normal(0, cp.sqrt(2.0 / in_features), (in_features, out_features)).astype(cp.float32)
        if bias:
            self.bias = cp.zeros((out_features,), dtype=cp.float32)

    def forward(self, x):
        """
        x - shape (N, C)
        return the result of Linear layer with shape (N, O)
        """
        # 如果输入是4D张量，需要展平
        if len(x.shape) == 4:
            N, C, H, W = x.shape
            x = x.reshape(N, C * H * W)
        
        self.x = x
        out = cp.dot(x, self.weight)
        if self.use_bias:
            out += self.bias
        return out

    def backward(self, dy, lr):
        """
        dy - shape (N, O)
        return the result of gradient dx with shape (N, C)
        """
        # 计算权重梯度 - 使用CuPy
        dw = cp.dot(self.x.T, dy)
        
        # 计算偏置梯度
        if self.use_bias:
            db = cp.sum(dy, axis=0)
            self.bias -= lr * db
        
        # 计算输入梯度
        dx = cp.dot(dy, self.weight.T)
        
        # 更新权重
        self.weight -= lr * dw
        
        return dx

class CrossEntropyLoss:
    def __call__(self, x, label):
        # Softmax - 使用CuPy
        exp_x = cp.exp(x - cp.max(x, axis=1, keepdims=True))  # 防止溢出
        self.probs = exp_x / cp.sum(exp_x, axis=1, keepdims=True)
        
        # 交叉熵损失
        N = x.shape[0]
        loss = -cp.sum(cp.log(self.probs[cp.arange(N), label] + 1e-15)) / N  # 添加小值防止log(0)
        
        # 计算梯度
        self.grad = self.probs.copy()
        self.grad[cp.arange(N), label] -= 1
        self.grad /= N
        
        return float(loss)  # 转换为Python标量
    
    def backward(self):
        return self.grad