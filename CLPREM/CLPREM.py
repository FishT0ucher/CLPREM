import scipy.io as scio
import numpy as np
import torch
import pandas as pd
import matplotlib.pyplot as plt
from torch import nn
from torch.autograd import Variable
import torch.nn.utils.prune as prune
import torch.nn.functional as F
import math
import sys
import time

def normalize(arr):
    max_value = np.max(arr)  # 获得最大值
    min_value = np.min(arr)  # 获得最小值
    scalar = max_value - min_value  # 获得间隔数量
    dataset = list(map(lambda x: x / scalar, arr))  # 归一化
    return dataset


def create_dataset(dataset, look_back=5):
    datax = []
    for i in range(len(dataset) - look_back):
        a = dataset[i:(i + look_back)]
        datax.append(a)
    return np.array(datax)

class lplstm(nn.Module):
    def __init__(self, input_size=5, hidden_size=10, output_size=5, num_layer=2):           #如果你使用8个自变量来预测3个因变量，那么input_size=8，output_size=3
        super(lplstm, self).__init__()
        self.linear0 = nn.Linear(45, 15)
        self.lstm1 = nn.LSTM(input_size, hidden_size, num_layer)
        self.lstm2 = nn.LSTM(input_size, hidden_size, num_layer)
        self.lstm3 = nn.LSTM(input_size, hidden_size, num_layer)
        self.linear1 = nn.Linear(hidden_size, output_size)
        self.linear2 = nn.Linear(hidden_size, output_size)
        self.linear3 = nn.Linear(hidden_size, output_size)
        self.linear = nn.Linear(15, output_size)
        self.elu = nn.ELU()

    def forward(self, a, b, c):
        x = torch.cat([a, b, c], dim=2)
        seq, _, _ = x.size()
        xtest2 = x
        x = x.view(seq, -1)

        xtest = x.view(seq, -1)
        x = self.linear0(x)
        x = x.view(seq, -1, 5)
        list_of_tensor =torch.split(x, 1, dim=1)
        a = list_of_tensor[0]
        b = list_of_tensor[1]
        c = list_of_tensor[2]
        a, (hn, cn) = self.lstm1(a)
        seq, batch, hidden = a.size()
        a = a.view(seq * batch, hidden)
        a = self.linear1(a)
        a = self.elu(a)
        a = a.view(seq, batch, -1)

        b, (hn, cn) = self.lstm2(b, (hn, cn))
        seq, batch, hidden = b.size()
        b = b.view(seq * batch, hidden)
        b = self.linear2(b)
        b = self.elu(b)
        b = b.view(seq, batch, -1)

        c, (hn, cn) = self.lstm3(c, (hn, cn))
        seq, batch, hidden = c.size()
        c = c.view(seq * batch, hidden)
        c = self.linear3(c)
        c = self.elu(c)
        c = c.view(seq, batch, -1)

        x = torch.cat([a, b, c], dim=1)
        x = x.view(seq, -1)
        x = self.linear(x)
        x = x.view(seq, -1, 5)
        return x


path1 = r'D:\pythonProject\cluster1.mat'
x1 = scio.loadmat(path1)
path2 = r'D:\pythonProject\cluster2.mat'
x2 = scio.loadmat(path2)
path3 = r'D:\pythonProject\cluster3.mat'
x3 = scio.loadmat(path3)
pathy = r'D:\pythonProject\traffic.mat'
y = scio.loadmat(pathy)

x1 = np.array(x1['cluster1'])
x2 = np.array(x2['cluster2'])
x3 = np.array(x3['cluster3'])
y = np.array(y['traffic'])
y = y.reshape(-1, 1)

x1 = x1.astype('float32')
x2 = x2.astype('float32')
x3 = x3.astype('float32')
y = y.astype('float32')

max_value = np.max(y)  # 获得最大值
min_value = np.min(y)
scalar = max_value - min_value

x1 = normalize(x1)
x2 = normalize(x2)
x3 = normalize(x3)
y = normalize(y)

x1 = create_dataset(x1)
x2 = create_dataset(x2)
x3 = create_dataset(x3)
# y = y[5:]
y = create_dataset(y)
y = np.array(y)


train_size = int(len(y) * 0.7)
test_size = len(y) - train_size
train_X1 = x1[:train_size]
test_X1 = x1[train_size:]
train_X2 = x2[:train_size]
test_X2 = x2[train_size:]
train_X3 = x3[:train_size]
test_X3 = x3[train_size:]
train_Y = y[:train_size]
test_Y = y[train_size:]

train_X1 = train_X1.reshape(-1, 3, 5)
test_X1 = test_X1.reshape(-1, 3, 5)
train_X2 = train_X2.reshape(-1, 3, 5)
test_X2 = test_X2.reshape(-1, 3, 5)
train_X3 = train_X3.reshape(-1, 3, 5)
test_X3 = test_X3.reshape(-1, 3, 5)
train_Y = train_Y.reshape(-1, 1, 5)
test_Y = test_Y.reshape(-1, 1, 5)

train_x1 = torch.from_numpy(train_X1)
test_x1 = torch.from_numpy(test_X1)
train_x2 = torch.from_numpy(train_X2)
test_x2 = torch.from_numpy(test_X2)
train_x3 = torch.from_numpy(train_X3)
test_x3 = torch.from_numpy(test_X3)
train_y = torch.from_numpy(train_Y)
test_y = torch.from_numpy(test_Y)

y = y[:, 0, :]


model = lplstm(5, 10, 5, 2)

parameters_to_prune = (
    (model.linear1, 'weight'),
    (model.linear2, 'weight'),
    (model.linear3, 'weight'),
    (model.linear0, 'weight'),
    (model.linear, 'weight'),

)

start_time = 0
ebd_time = 0

criterion = nn.MSELoss()
optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)

# 开始训练
for e in range(500):
    start_time = time.time()
    var_x1 = Variable(train_x1)
    var_x2 = Variable(train_x2)
    var_x3 = Variable(train_x3)
    var_y = Variable(train_y)
    # 前向传播
    out = model(var_x1, var_x2, var_x3)
    loss = criterion(out, var_y)
    # 反向传播
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    end_time = time.time()
    print(end_time - start_time)
    # if (e + 1) % 100 == 0:  # 每 100 次输出结果
    #     print('Epoch: {}, Loss: {:.5f}'.format(e + 1, loss.item()))

#
# prune.global_unstructured(
#     parameters_to_prune,
#     pruning_method=prune.RandomUnstructured,
#     amount=0,
# )
#
#
# for e in range(500):
#     var_x1 = Variable(train_x1)
#     var_x2 = Variable(train_x2)
#     var_x3 = Variable(train_x3)
#     var_y = Variable(train_y)
#     # 前向传播
#     out = model(var_x1, var_x2, var_x3)
#     loss = criterion(out, var_y)
#     # 反向传播
#     optimizer.zero_grad()
#     loss.backward()
#     optimizer.step()
#     if (e + 1) % 100 == 0:  # 每 100 次输出结果
#         print('Epoch: {}, Loss: {:.5f}'.format(e + 1, loss.item()))
#







model = model.eval() # 转换成测试模式


x1 = x1.reshape(-1, 3, 5)
x1 = torch.from_numpy(x1)
var_datax1 = Variable(x1)
x2 = x2.reshape(-1, 3, 5)
x2 = torch.from_numpy(x2)
var_datax2 = Variable(x2)
x3 = x3.reshape(-1, 3, 5)
x3 = torch.from_numpy(x3)
var_datax3 = Variable(x3)


pred_test = model(var_datax1, var_datax2, var_datax3,) # 测试集的预测结果
# 改变输出的格式
pred_test = pred_test.view(-1, 5).data.numpy()
pred_test = pred_test[:, 0]
pred_test = pred_test.reshape(-1, 1)
# 画出实际结果和预测的结果
pred_test = pred_test * scalar
y = y * scalar
# mse = np.sum((y - pred_test) ** 2) / len(pred_test)
# rmse = math.sqrt(mse)
#
# #原生实现
# # 衡量线性回归的MSE 、 RMSE、 MAE、r2
#
# mae = np.sum(np.absolute(y - pred_test)) / len(pred_test)
# print("mae:", mae, "mse:", mse, "rmse:", rmse)


plt.plot(pred_test, 'r', label='prediction')
plt.plot(y, 'b', label='real')
plt.legend(loc='best')
plt.show()


