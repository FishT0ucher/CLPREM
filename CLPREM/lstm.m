clc,clear,close all;

loss1 = load('14.txt'); 
loss2 = load('16.txt'); 
loss3 = load('40.txt'); 

% loss14 = minusp(loss1)/(946/4);
% loss16 = minusp(loss2)/(946/8);
% loss40 = minusp(loss3)/(946/4);





mux14 = mean(smooth(loss14));    %求均值 
sigx14 = std(smooth(loss14));      %求均差 

muy14 = mean(smooth(loss14));    %求均值 
sigy14 = std(smooth(loss14));      %求均差 

estval14 = (smooth(loss14)-mux14)/sigx14;
trueval14 = (smooth(loss14)-muy14)/sigy14;

dataXTrain14 = estval14(1:60);
dataXTest14 = estval14(60:96); 

dataYTrain14 = trueval14(2:61);
dataYTest14 = trueval14(61:97); 
X14 = [dataXTrain14,dataXTest14];

numFeatures = 1;   %特征为一维
numResponses = 1;  %输出也是一维
numHiddenUnits = 15;   %创建LSTM回归网络，指定LSTM层的隐含单元个数200。可调


layers = [ ...
    sequenceInputLayer(numFeatures)    %输入层
    lstmLayer(numHiddenUnits)  % lstm层，如果是构建多层的LSTM模型，可以修改。
    fullyConnectedLayer(numResponses)    %为全连接层,是输出的维数。
    regressionLayer];      %其计算回归问题的半均方误差模块 。即说明这不是在进行分类问题。


options = trainingOptions('adam', ...
    'MaxEpochs',300, ...
    'GradientThreshold',0.5, ...
    'InitialLearnRate',0.01, ...      
    'LearnRateSchedule','piecewise', ...%每当经过一定数量的时期时，学习率就会乘以一个系数。
    'LearnRateDropPeriod',100, ...      %乘法之间的纪元数由" LearnRateDropPeriod"控制。可调
    'LearnRateDropFactor',0.5, ...      %乘法因子由参" LearnRateDropFactor”控制，可调
    'Verbose',0,  ...  %如果将其设置为true，则有关训练进度的信息将被打印到命令窗口中。默认值为true。
    'Plots','training-progress');    %构建曲线图 将'training-progress'替换为none
[net,info] = trainNetwork(dataXTrain14,dataYTrain14,layers,options); 

for i = 1:96  %从第二步开始，这里进行191次单步预测(191为用于验证的预测值，100为往后预测的值。一共291个）
    [net,YPred14(:,i+1)] = predictAndUpdateState(net,X14(:,i),'ExecutionEnvironment','cpu');  %predictAndUpdateState函数是一次预测一个值并更新网络状态
end
YPred14 = sigy14*YPred14 + muy14;
figure()
plot(1:97,YPred14,'b-o','Linewidth', 2, 'MarkerSize', 8)

set(gca,'linewidth',5,'fontsize',35,'fontname','Times');
legend('TVAR','origin','ARMA','LSTM','FontSize',30,'LineWidth',3,fontweight='bold')
xlabel('The serial number of time window','fontname','times new roman','fontSize',40,fontweight='bold')
ylabel('Packet Loss Ratio','fontname','times new roman','fontSize',40,fontweight='bold')
grid on
loss14 = smooth(loss14);
LSTM_rmse14 = rmse(YPred14(20:97),loss14(20:97))
save('lstm14.mat','YPred14');









mux16 = mean(smooth(loss16));    %求均值 
sigx16 = std(smooth(loss16));      %求均差 

muy16 = mean(smooth(loss16));    %求均值 
sigy16 = std(smooth(loss16));      %求均差 

estval16 = (smooth(loss16)-mux16)/sigx16;
trueval16 = (smooth(loss16)-muy16)/sigy16;

dataXTrain16 = estval16(1:60);
dataXTest16 = estval16(60:96); 

dataYTrain16 = trueval16(2:61);
dataYTest16 = trueval16(61:97); 
X16 = [dataXTrain16,dataXTest16];

numFeatures = 1;   %特征为一维
numResponses = 1;  %输出也是一维
numHiddenUnits = 15;   %创建LSTM回归网络，指定LSTM层的隐含单元个数200。可调


layers = [ ...
    sequenceInputLayer(numFeatures)    %输入层
    lstmLayer(numHiddenUnits)  % lstm层，如果是构建多层的LSTM模型，可以修改。
    fullyConnectedLayer(numResponses)    %为全连接层,是输出的维数。
    regressionLayer];      %其计算回归问题的半均方误差模块 。即说明这不是在进行分类问题。


options = trainingOptions('adam', ...
    'MaxEpochs',500, ...
    'GradientThreshold',0.5, ...
    'InitialLearnRate',0.01, ...      
    'LearnRateSchedule','piecewise', ...%每当经过一定数量的时期时，学习率就会乘以一个系数。
    'LearnRateDropPeriod',100, ...      %乘法之间的纪元数由" LearnRateDropPeriod"控制。可调
    'LearnRateDropFactor',0.5, ...      %乘法因子由参" LearnRateDropFactor”控制，可调
    'Verbose',0);  %如果将其设置为true，则有关训练进度的信息将被打印到命令窗口中。默认值为true。
        %构建曲线图 将'training-progress'替换为none
[net,info] = trainNetwork(dataXTrain16,dataYTrain16,layers,options); 

for i = 1:96  %从第二步开始，这里进行191次单步预测(191为用于验证的预测值，100为往后预测的值。一共291个）
    [net,YPred16(:,i+1)] = predictAndUpdateState(net,X16(:,i),'ExecutionEnvironment','cpu');  %predictAndUpdateState函数是一次预测一个值并更新网络状态
end
YPred16 = sigy16*YPred16 + muy16;
figure()
plot(1:97,YPred16,'b-o','Linewidth', 2, 'MarkerSize', 8)

set(gca,'linewidth',5,'fontsize',35,'fontname','Times');
legend('TVAR','origin','ARMA','LSTM','FontSize',30,'LineWidth',3,fontweight='bold')
xlabel('The serial number of time window','fontname','times new roman','fontSize',40,fontweight='bold')
ylabel('Packet Loss Ratio','fontname','times new roman','fontSize',40,fontweight='bold')
grid on
loss16 = smooth(loss16);
LSTM_rmse16 = rmse(YPred16(20:97),loss16(20:97))
save('lstm16.mat','YPred16');






mux40 = mean(smooth(loss40));    %求均值 
sigx40 = std(smooth(loss40));      %求均差 

muy40 = mean(smooth(loss40));    %求均值 
sigy40 = std(smooth(loss40));      %求均差 

estval40 = (smooth(loss40)-mux40)/sigx40;
trueval40 = (smooth(loss40)-muy40)/sigy40;

dataXTrain40 = estval40(1:60);
dataXTest40 = estval40(60:96); 

dataYTrain40 = trueval40(2:61);
dataYTest40 = trueval40(61:97); 
X40 = [dataXTrain40,dataXTest40];

numFeatures = 1;   %特征为一维
numResponses = 1;  %输出也是一维
numHiddenUnits = 15;   %创建LSTM回归网络，指定LSTM层的隐含单元个数200。可调


layers = [ ...
    sequenceInputLayer(numFeatures)    %输入层
    lstmLayer(numHiddenUnits)  % lstm层，如果是构建多层的LSTM模型，可以修改。
    fullyConnectedLayer(numResponses)    %为全连接层,是输出的维数。
    regressionLayer];      %其计算回归问题的半均方误差模块 。即说明这不是在进行分类问题。


options = trainingOptions('adam', ...
    'MaxEpochs',500, ...
    'GradientThreshold',0.5, ...
    'InitialLearnRate',0.01, ...      
    'LearnRateSchedule','piecewise', ...%每当经过一定数量的时期时，学习率就会乘以一个系数。
    'LearnRateDropPeriod',100, ...      %乘法之间的纪元数由" LearnRateDropPeriod"控制。可调
    'LearnRateDropFactor',0.5, ...      %乘法因子由参" LearnRateDropFactor”控制，可调
    'Verbose',0,  ...  %如果将其设置为true，则有关训练进度的信息将被打印到命令窗口中。默认值为true。
    'Plots','training-progress');    %构建曲线图 将'training-progress'替换为none
[net,info] = trainNetwork(dataXTrain40,dataYTrain40,layers,options); 

for i = 1:96  %从第二步开始，这里进行191次单步预测(191为用于验证的预测值，100为往后预测的值。一共291个）
    [net,YPred40(:,i+1)] = predictAndUpdateState(net,X40(:,i),'ExecutionEnvironment','cpu');  %predictAndUpdateState函数是一次预测一个值并更新网络状态
end
YPred40 = sigy40*YPred40 + muy40;
figure()
plot(1:97,YPred40,'b-o','Linewidth', 2, 'MarkerSize', 8)

set(gca,'linewidth',5,'fontsize',35,'fontname','Times');
legend('TVAR','origin','ARMA','LSTM','FontSize',30,'LineWidth',3,fontweight='bold')
xlabel('The serial number of time window','fontname','times new roman','fontSize',40,fontweight='bold')
ylabel('Packet Loss Ratio','fontname','times new roman','fontSize',40,fontweight='bold')
grid on
loss40 = smooth(loss40);
LSTM_rmse40 = rmse(YPred40(20:97),loss40(20:97))
save('lstm40.mat','YPred40');





























function [loss] = minusp(losso)
    loss(1) = losso(1);
    for i = 2:length(losso)
        loss(i) = losso(i) - losso(i-1);
    end
end


function [out] = smooth(in)
    out(1) = 2/3 *in(1) + 1/3 * in(2);
    for i = 2:length(in)-1
    out(i) = 1/4 * (in(i-1)+in(i+1)) + 1/2*in(i);  
    end
    out(length(in)) = 2/3 *in(length(in)) + 1/3 *in(length(in)-1);
end

function [rmse] = rmse(x,y)
    rmse = sqrt(mean((x-y).^2));
end




