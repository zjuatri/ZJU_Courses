import numpy as np
import cupy as cp
from module import Conv2d, Sigmoid, MaxPool2d, AvgPool2d, Linear, ReLU, Tanh, CrossEntropyLoss
import struct
import glob
import tqdm
import cv2

def load_mnist(path, kind='train'):
    image_path = glob.glob('./%s*3-ubyte' % (kind))[0]
    label_path = glob.glob('./%s*1-ubyte' % (kind))[0]

    with open(label_path, "rb") as lbpath:
        magic, n = struct.unpack('>II', lbpath.read(8))
        labels = np.fromfile(lbpath, dtype=np.uint8)

    with open(image_path, "rb") as impath:
        magic, num, rows, cols = struct.unpack('>IIII', impath.read(16))
        images = np.fromfile(impath, dtype=np.uint8).reshape(len(labels), 28*28)

    return images, labels

class LeNet5:
    def __init__(self):
        
        self.conv1 = Conv2d(1, 6, 5, 1, 2)
        self.relu1 = Sigmoid()
        self.pool1 = AvgPool2d(2)
        self.conv2 = Conv2d(6, 16, 5)
        self.relu2 = Sigmoid()
        self.pool2 = AvgPool2d(2)
        self.fc1 = Linear(16*5*5, 120)
        self.relu3 = Sigmoid()
        self.fc2 = Linear(120, 84)
        self.relu4 = Sigmoid()
        self.fc3 = Linear(84, 10)

    def forward(self, x):
        x = self.conv1.forward(x)
        x = self.relu1.forward(x)
        x = self.pool1.forward(x)
        x = self.conv2.forward(x)
        x = self.relu2.forward(x)
        x = self.pool2.forward(x)
        x = self.fc1.forward(x)
        x = self.relu3.forward(x)
        x = self.fc2.forward(x)
        x = self.relu4.forward(x)
        x = self.fc3.forward(x)
        return x

    def backward(self, dy, lr):
        dy = self.fc3.backward(dy, lr)
        dy = self.relu4.backward(dy)
        dy = self.fc2.backward(dy, lr)
        dy = self.relu3.backward(dy)
        dy = self.fc1.backward(dy, lr)
        dy = self.pool2.backward(dy)
        dy = self.relu2.backward(dy)
        dy = self.conv2.backward(dy, lr)
        dy = self.pool1.backward(dy)
        dy = self.relu1.backward(dy)
        dy = self.conv1.backward(dy, lr)

if __name__ == '__main__':
    
    train_images, train_labels = load_mnist("mnist_dataset", kind="train")
    test_images, test_labels = load_mnist("mnist_dataset", kind="t10k")

    train_images = train_images.astype(np.float32) / 255.0  # 改为float32并正确归一化
    test_images = test_images.astype(np.float32) / 255.0
    # ----------------------------请完成网络的训练和测试----------------------------
    
    # 初始化模型和损失函数
    model = LeNet5()
    criterion = CrossEntropyLoss()
    
    # 训练参数
    batch_size = 32
    epochs = 10
    learning_rate = 0.01
    
    # 将图像reshape为(N, C, H, W)格式
    train_images = train_images.reshape(-1, 1, 28, 28)
    test_images = test_images.reshape(-1, 1, 28, 28)
    
    # 训练循环
    print("开始训练...")
    for epoch in range(epochs):
        total_loss = 0
        correct = 0
        total = 0
        
        # 打乱训练数据
        indices = np.random.permutation(len(train_images))
        train_images_shuffled = train_images[indices]
        train_labels_shuffled = train_labels[indices]
        
        # 批量训练
        num_batches = len(train_images) // batch_size
        progress_bar = tqdm.tqdm(range(num_batches), desc=f'Epoch {epoch+1}/{epochs}')
        
        for i in progress_bar:
            start_idx = i * batch_size
            end_idx = start_idx + batch_size
            
            batch_images = train_images_shuffled[start_idx:end_idx]
            batch_labels = train_labels_shuffled[start_idx:end_idx]
            
            # 前向传播
            outputs = model.forward(batch_images)
            
            # 计算损失
            loss = criterion(outputs, batch_labels)
            total_loss += loss
            
            # 计算准确率
            predictions = np.argmax(outputs, axis=1)
            correct += np.sum(predictions == batch_labels)
            total += len(batch_labels)
            
            # 反向传播
            grad = criterion.backward()
            model.backward(grad, learning_rate)
            
            # 更新进度条
            progress_bar.set_postfix({
                'Loss': f'{loss:.4f}',
                'Acc': f'{correct/total:.4f}'
            })
        
        # 打印epoch结果
        avg_loss = total_loss / num_batches
        train_acc = correct / total
        print(f'Epoch {epoch+1}/{epochs}, Loss: {avg_loss:.4f}, Train Acc: {train_acc:.4f}')
        
        # 每个epoch后在测试集上评估
        if (epoch + 1) % 2 == 0:  # 每2个epoch测试一次
            print("在测试集上评估...")
            test_correct = 0
            test_total = 0
            test_batches = len(test_images) // batch_size
            
            for i in range(test_batches):
                start_idx = i * batch_size
                end_idx = start_idx + batch_size
                
                batch_images = test_images[start_idx:end_idx]
                batch_labels = test_labels[start_idx:end_idx]
                
                # 前向传播（测试时不需要反向传播）
                outputs = model.forward(batch_images)
                predictions = np.argmax(outputs, axis=1)
                
                test_correct += np.sum(predictions == batch_labels)
                test_total += len(batch_labels)
            
            test_acc = test_correct / test_total
            print(f'Test Accuracy: {test_acc:.4f}')
    
    # 最终测试
    print("\n最终测试结果:")
    test_correct = 0
    test_total = 0
    class_correct = np.zeros(10)
    class_total = np.zeros(10)
    
    test_batches = len(test_images) // batch_size
    
    for i in tqdm.tqdm(range(test_batches), desc='Final Testing'):
        start_idx = i * batch_size
        end_idx = start_idx + batch_size
        
        batch_images = test_images[start_idx:end_idx]
        batch_labels = test_labels[start_idx:end_idx]
        
        outputs = model.forward(batch_images)
        predictions = np.argmax(outputs, axis=1)
        
        test_correct += np.sum(predictions == batch_labels)
        test_total += len(batch_labels)
        
        # 统计各类别准确率
        for j in range(len(batch_labels)):
            label = batch_labels[j]
            class_total[label] += 1
            if predictions[j] == label:
                class_correct[label] += 1
    
    final_accuracy = test_correct / test_total
    print(f'\n最终测试准确率: {final_accuracy:.4f}')
    
    # 打印各数字的识别准确率
    print("\n各数字识别准确率:")
    for i in range(10):
        if class_total[i] > 0:
            acc = class_correct[i] / class_total[i]
            print(f'数字 {i}: {acc:.4f} ({int(class_correct[i])}/{int(class_total[i])})')
    
    # ---------------------------------------------------------------------------







