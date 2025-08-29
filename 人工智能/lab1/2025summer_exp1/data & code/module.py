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
        
        # Xavier初始化权重
        self.weight = np.random.normal(0, np.sqrt(2.0 / (in_channels * kernel_size * kernel_size)), 
                                     (out_channels, in_channels, kernel_size, kernel_size))
        self.bias = np.zeros((out_channels,))
        
        # 存储前向传播的输入，用于反向传播
        self.x = None
        # ---------------------------------------------------------------------------

    def forward(self, x):
        """
        x - shape (N, C, H, W)
        return the result of Conv2d with shape (N, O, H', W')
        """
       # ------------------------------请完成此部分内容------------------------------
        self.x = x
        N, C, H, W = x.shape
        
        # 添加padding
        if self.padding > 0:
            x_padded = np.pad(x, ((0, 0), (0, 0), (self.padding, self.padding), (self.padding, self.padding)), mode='constant')
        else:
            x_padded = x
            
        # 计算输出尺寸
        H_out = (H + 2 * self.padding - self.kernel_size) // self.stride + 1
        W_out = (W + 2 * self.padding - self.kernel_size) // self.stride + 1
        
        # 初始化输出
        out = np.zeros((N, self.out_channels, H_out, W_out))
        
        # 卷积运算
        for n in range(N):
            for o in range(self.out_channels):
                for h in range(H_out):
                    for w in range(W_out):
                        h_start = h * self.stride
                        w_start = w * self.stride
                        x_slice = x_padded[n, :, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size]
                        out[n, o, h, w] = np.sum(x_slice * self.weight[o]) + self.bias[o]
        
        return out
        # ---------------------------------------------------------------------------

    def backward(self, dy, lr):
        """
        dy - the gradient of last layer with shape (N, O, H', W')
        lr - learning rate
        calculate self.w_grad to update self.weight,
        calculate self.b_grad to update self.bias,
        return the result of gradient dx with shape (N, C, H, W)
        """
       # ------------------------------请完成此部分内容------------------------------
        N, C, H, W = self.x.shape
        N, O, H_out, W_out = dy.shape
        
        # 添加padding
        if self.padding > 0:
            x_padded = np.pad(self.x, ((0, 0), (0, 0), (self.padding, self.padding), (self.padding, self.padding)), mode='constant')
        else:
            x_padded = self.x
            
        # 计算权重梯度
        dw = np.zeros_like(self.weight)
        for o in range(O):
            for c in range(C):
                for kh in range(self.kernel_size):
                    for kw in range(self.kernel_size):
                        for n in range(N):
                            for h in range(H_out):
                                for w in range(W_out):
                                    h_start = h * self.stride
                                    w_start = w * self.stride
                                    dw[o, c, kh, kw] += dy[n, o, h, w] * x_padded[n, c, h_start+kh, w_start+kw]
        
        # 计算偏置梯度
        db = np.sum(dy, axis=(0, 2, 3))
        
        # 计算输入梯度
        dx = np.zeros_like(self.x)
        for n in range(N):
            for c in range(C):
                for h in range(H):
                    for w in range(W):
                        for o in range(O):
                            for kh in range(self.kernel_size):
                                for kw in range(self.kernel_size):
                                    h_out = (h + self.padding - kh) // self.stride
                                    w_out = (w + self.padding - kw) // self.stride
                                    if (0 <= h_out < H_out and 0 <= w_out < W_out and 
                                        (h + self.padding - kh) % self.stride == 0 and
                                        (w + self.padding - kw) % self.stride == 0):
                                        dx[n, c, h, w] += dy[n, o, h_out, w_out] * self.weight[o, c, kh, kw]
        
        # 更新权重和偏置
        self.weight -= lr * dw
        self.bias -= lr * db
        
        return dx
        # ---------------------------------------------------------------------------

class ReLU:
    def forward(self, x):
        self.x = x
        return np.maximum(0, x)
      
    def backward(self, dy):
        return dy * (self.x > 0)

class Tanh:
    def forward(self, x):
        self.output = np.tanh(x)
        return self.output

    def backward(self, dy):
        return dy * (1 - self.output ** 2)
        
class Sigmoid:
    def forward(self, x):
        self.output = 1 / (1 + np.exp(-np.clip(x, -500, 500)))  # 防止溢出
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
        
        out = np.zeros((N, C, H_out, W_out))
        self.mask = np.zeros_like(x)
        
        for n in range(N):
            for c in range(C):
                for h in range(H_out):
                    for w in range(W_out):
                        h_start = h * self.stride
                        w_start = w * self.stride
                        pool_region = x[n, c, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size]
                        max_val = np.max(pool_region)
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
        dx = np.zeros_like(self.x)
        
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
        
        out = np.zeros((N, C, H_out, W_out))
        
        for n in range(N):
            for c in range(C):
                for h in range(H_out):
                    for w in range(W_out):
                        h_start = h * self.stride
                        w_start = w * self.stride
                        pool_region = x[n, c, h_start:h_start+self.kernel_size, w_start:w_start+self.kernel_size]
                        out[n, c, h, w] = np.mean(pool_region)
        
        return out

    def backward(self, dy):
        """
        dy - shape (N, C, H', W')
        return the result of gradient dx with shape (N, C, H, W)
        """
        N, C, H_out, W_out = dy.shape
        dx = np.zeros_like(self.x)
        
        for n in range(N):
            for c in range(C):
                for h in range(H_out):
                    for w in range(W_out):
                        h_start = h * self.stride
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
        
        # Xavier初始化
        self.weight = np.random.normal(0, np.sqrt(2.0 / in_features), (in_features, out_features))
        if bias:
            self.bias = np.zeros((out_features,))

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
        out = np.dot(x, self.weight)
        if self.use_bias:
            out += self.bias
        return out

    def backward(self, dy, lr):
        """
        dy - shape (N, O)
        return the result of gradient dx with shape (N, C)
        """
        # 计算权重梯度
        dw = np.dot(self.x.T, dy)
        
        # 计算偏置梯度
        if self.use_bias:
            db = np.sum(dy, axis=0)
            self.bias -= lr * db
        
        # 计算输入梯度
        dx = np.dot(dy, self.weight.T)
        
        # 更新权重
        self.weight -= lr * dw
        
        return dx

class CrossEntropyLoss:
    def __call__(self, x, label):
        # Softmax
        exp_x = np.exp(x - np.max(x, axis=1, keepdims=True))  # 防止溢出
        self.probs = exp_x / np.sum(exp_x, axis=1, keepdims=True)
        
        # 交叉熵损失
        N = x.shape[0]
        loss = -np.sum(np.log(self.probs[np.arange(N), label] + 1e-15)) / N  # 添加小值防止log(0)
        
        # 计算梯度
        self.grad = self.probs.copy()
        self.grad[np.arange(N), label] -= 1
        self.grad /= N
        
        return loss
    
    def backward(self):
        return self.grad

