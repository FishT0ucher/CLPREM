clc,clear,close all;



%生成两个有明显平移性质的时间序列
% x = zeros(1,50);
% for i = 1:50
%     x(i) = sin(i*2*pi/50)+2;
% end
% y = zeros(1,50);
% for i = 1:50
%     y(i) = sin(i*2*pi/50 + pi/6)+2;
% end

dtwtcp = load('dtwtcp.mat');
dtwtcp = dtwtcp.dtwtcp;
dtwudp = load('dtwudp.mat');
dtwudp = dtwudp.dtwudp;
dtwtr = load('dtwtr.mat');
dtwtr = dtwtr.dtwtr;

Dtcp = load('Dtcp.mat');
Dtcp = Dtcp.tcp_traffic1(100:400);
Dudp = load('Dudp.mat');
Dudp = Dudp.udp_traffic1(100:400);
Dtr = load('Dtraffic.mat');
Dtr = Dtr.traffic1(100:400);



x = dtwudp;
% x = gan(x);
y = Dudp;


figure()
plot(x)
hold on
plot(gan(x))
% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];



figure()

x_len = length(x);
y_len = length(y);
plot(1:x_len,x,'-*r');hold on
plot(1:y_len,y,'-^g');hold on
%计算两序列每个特征点的距离矩阵
distance = zeros(x_len,y_len);
for i = 1:x_len
    for j=1:y_len
        distance(i,j) = (x(i)-y(j)).^2;
    end
end
%计算两个序列
DP = zeros(x_len,y_len);
DP(1,1) = distance(1,1);
for i=2:x_len
    DP(i,1) = distance(i,1)+DP(i-1,1);
end
for j=2:y_len
    DP(1,j) = distance(1,j)+DP(1,j-1);
end
for i=2:x_len
    for j=2:y_len
        DP(i,j) = distance(i,j) + GetMin(DP(i-1,j),DP(i,j-1),DP(i-1,j-1));
    end
end
%回溯，找到各个特征点之间的匹配关系
i = x_len;
j = y_len;
while(~((i == 1)&&(j==1)))
    plot([i,j],[x(i),y(j)],'b');hold on %画出匹配之后的特征点之间的匹配关系
    if(i==1)
        index_i = 1;
        index_j = j-1;
    elseif(j==1)
        index_i = i-1;
        index_j = 1;
    else
    [index_i,index_j] = GetMinIndex(DP(i-1,j-1),DP(i-1,j),DP(i,j-1),i,j);
    end
    i = index_i;
    j = index_j;  
end 


% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];

dis = 0;
for i = 1:length(x)
    for j = 1:length(y)
        dis = dis + (x(i)^2+y(j)^2)^(1/2);
    end
end
figure()

plot(1:length(x),x,'marker','o','markerfacecolor','r','LineWidth',1);
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('f(x)',fontweight='bold')
title('')
% set(gca,'FontSize',30,'Fontname', 'Times New Roman',fontweight='bold');

figure()
plot(1:length(y),y,'marker','o','markerfacecolor','r','LineWidth',1)
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('g(x)',fontweight='bold')
title('')
dis







x = dtwudp;
x = gan(x);
y = Dudp;


figure()
plot(x)
hold on
plot(gan(x))
% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];



figure()

x_len = length(x);
y_len = length(y);
plot(1:x_len,x,'-*r');hold on
plot(1:y_len,y,'-^g');hold on
%计算两序列每个特征点的距离矩阵
distance = zeros(x_len,y_len);
for i = 1:x_len
    for j=1:y_len
        distance(i,j) = (x(i)-y(j)).^2;
    end
end
%计算两个序列
DP = zeros(x_len,y_len);
DP(1,1) = distance(1,1);
for i=2:x_len
    DP(i,1) = distance(i,1)+DP(i-1,1);
end
for j=2:y_len
    DP(1,j) = distance(1,j)+DP(1,j-1);
end
for i=2:x_len
    for j=2:y_len
        DP(i,j) = distance(i,j) + GetMin(DP(i-1,j),DP(i,j-1),DP(i-1,j-1));
    end
end
%回溯，找到各个特征点之间的匹配关系
i = x_len;
j = y_len;
while(~((i == 1)&&(j==1)))
    plot([i,j],[x(i),y(j)],'b');hold on %画出匹配之后的特征点之间的匹配关系
    if(i==1)
        index_i = 1;
        index_j = j-1;
    elseif(j==1)
        index_i = i-1;
        index_j = 1;
    else
    [index_i,index_j] = GetMinIndex(DP(i-1,j-1),DP(i-1,j),DP(i,j-1),i,j);
    end
    i = index_i;
    j = index_j;  
end 


% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];

dis = 0;
for i = 1:length(x)
    for j = 1:length(y)
        dis = dis + (x(i)^2+y(j)^2)^(1/2);
    end
end
figure()

plot(1:length(x),x,'marker','o','markerfacecolor','r','LineWidth',1);
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('f(x)',fontweight='bold')
title('')
% set(gca,'FontSize',30,'Fontname', 'Times New Roman',fontweight='bold');

figure()
plot(1:length(y),y,'marker','o','markerfacecolor','r','LineWidth',1)
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('g(x)',fontweight='bold')
title('')

dis





x = dtwtcp;
% x = gan(x);
y = Dtcp;


figure()
plot(x)
hold on
plot(gan(x))
% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];



figure()

x_len = length(x);
y_len = length(y);
plot(1:x_len,x,'-*r');hold on
plot(1:y_len,y,'-^g');hold on
%计算两序列每个特征点的距离矩阵
distance = zeros(x_len,y_len);
for i = 1:x_len
    for j=1:y_len
        distance(i,j) = (x(i)-y(j)).^2;
    end
end
%计算两个序列
DP = zeros(x_len,y_len);
DP(1,1) = distance(1,1);
for i=2:x_len
    DP(i,1) = distance(i,1)+DP(i-1,1);
end
for j=2:y_len
    DP(1,j) = distance(1,j)+DP(1,j-1);
end
for i=2:x_len
    for j=2:y_len
        DP(i,j) = distance(i,j) + GetMin(DP(i-1,j),DP(i,j-1),DP(i-1,j-1));
    end
end
%回溯，找到各个特征点之间的匹配关系
i = x_len;
j = y_len;
while(~((i == 1)&&(j==1)))
    plot([i,j],[x(i),y(j)],'b');hold on %画出匹配之后的特征点之间的匹配关系
    if(i==1)
        index_i = 1;
        index_j = j-1;
    elseif(j==1)
        index_i = i-1;
        index_j = 1;
    else
    [index_i,index_j] = GetMinIndex(DP(i-1,j-1),DP(i-1,j),DP(i,j-1),i,j);
    end
    i = index_i;
    j = index_j;  
end 


% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];

dis = 0;
for i = 1:length(x)
    for j = 1:length(y)
        dis = dis + (x(i)^2+y(j)^2)^(1/2);
    end
end
figure()

plot(1:length(x),x,'marker','o','markerfacecolor','r','LineWidth',1);
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('f(x)',fontweight='bold')
title('')
% set(gca,'FontSize',30,'Fontname', 'Times New Roman',fontweight='bold');

figure()
plot(1:length(y),y,'marker','o','markerfacecolor','r','LineWidth',1)
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('g(x)',fontweight='bold')
title('')

dis























x = dtwtcp;
x = gan(x);
y = Dtcp;


figure()
plot(x)
hold on
plot(gan(x))
% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];



figure()

x_len = length(x);
y_len = length(y);
plot(1:x_len,x,'-*r');hold on
plot(1:y_len,y,'-^g');hold on
%计算两序列每个特征点的距离矩阵
distance = zeros(x_len,y_len);
for i = 1:x_len
    for j=1:y_len
        distance(i,j) = (x(i)-y(j)).^2;
    end
end
%计算两个序列
DP = zeros(x_len,y_len);
DP(1,1) = distance(1,1);
for i=2:x_len
    DP(i,1) = distance(i,1)+DP(i-1,1);
end
for j=2:y_len
    DP(1,j) = distance(1,j)+DP(1,j-1);
end
for i=2:x_len
    for j=2:y_len
        DP(i,j) = distance(i,j) + GetMin(DP(i-1,j),DP(i,j-1),DP(i-1,j-1));
    end
end
%回溯，找到各个特征点之间的匹配关系
i = x_len;
j = y_len;
while(~((i == 1)&&(j==1)))
    plot([i,j],[x(i),y(j)],'b');hold on %画出匹配之后的特征点之间的匹配关系
    if(i==1)
        index_i = 1;
        index_j = j-1;
    elseif(j==1)
        index_i = i-1;
        index_j = 1;
    else
    [index_i,index_j] = GetMinIndex(DP(i-1,j-1),DP(i-1,j),DP(i,j-1),i,j);
    end
    i = index_i;
    j = index_j;  
end 


% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];

dis = 0;
for i = 1:length(x)
    for j = 1:length(y)
        dis = dis + (x(i)^2+y(j)^2)^(1/2);
    end
end
figure()

plot(1:length(x),x,'marker','o','markerfacecolor','r','LineWidth',1);
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('f(x)',fontweight='bold')
title('')
% set(gca,'FontSize',30,'Fontname', 'Times New Roman',fontweight='bold');

figure()
plot(1:length(y),y,'marker','o','markerfacecolor','r','LineWidth',1)
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('g(x)',fontweight='bold')
title('')
dis










x = dtwtr;
% x = gan(x);
y = Dtr;


figure()
plot(x)
hold on
plot(gan(x))
% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];



figure()

x_len = length(x);
y_len = length(y);
plot(1:x_len,x,'-*r');hold on
plot(1:y_len,y,'-^g');hold on
%计算两序列每个特征点的距离矩阵
distance = zeros(x_len,y_len);
for i = 1:x_len
    for j=1:y_len
        distance(i,j) = (x(i)-y(j)).^2;
    end
end
%计算两个序列
DP = zeros(x_len,y_len);
DP(1,1) = distance(1,1);
for i=2:x_len
    DP(i,1) = distance(i,1)+DP(i-1,1);
end
for j=2:y_len
    DP(1,j) = distance(1,j)+DP(1,j-1);
end
for i=2:x_len
    for j=2:y_len
        DP(i,j) = distance(i,j) + GetMin(DP(i-1,j),DP(i,j-1),DP(i-1,j-1));
    end
end
%回溯，找到各个特征点之间的匹配关系
i = x_len;
j = y_len;
while(~((i == 1)&&(j==1)))
    plot([i,j],[x(i),y(j)],'b');hold on %画出匹配之后的特征点之间的匹配关系
    if(i==1)
        index_i = 1;
        index_j = j-1;
    elseif(j==1)
        index_i = i-1;
        index_j = 1;
    else
    [index_i,index_j] = GetMinIndex(DP(i-1,j-1),DP(i-1,j),DP(i,j-1),i,j);
    end
    i = index_i;
    j = index_j;  
end 




dis = 0;
for i = 1:length(x)
    for j = 1:length(y)
        dis = dis + (x(i)^2+y(j)^2)^(1/2);
    end
end
figure()

plot(1:length(x),x,'marker','o','markerfacecolor','r','LineWidth',1);
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('f(x)',fontweight='bold')
title('')
% set(gca,'FontSize',30,'Fontname', 'Times New Roman',fontweight='bold');

figure()
plot(1:length(y),y,'marker','o','markerfacecolor','r','LineWidth',1)
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('g(x)',fontweight='bold')
title('')
dis









x = dtwtr;
x = gan(x);
y = Dtr;


figure()
plot(x)
hold on
plot(gan(x))
% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];



figure()

x_len = length(x);
y_len = length(y);
plot(1:x_len,x,'-*r');hold on
plot(1:y_len,y,'-^g');hold on
%计算两序列每个特征点的距离矩阵
distance = zeros(x_len,y_len);
for i = 1:x_len
    for j=1:y_len
        distance(i,j) = (x(i)-y(j)).^2;
    end
end
%计算两个序列
DP = zeros(x_len,y_len);
DP(1,1) = distance(1,1);
for i=2:x_len
    DP(i,1) = distance(i,1)+DP(i-1,1);
end
for j=2:y_len
    DP(1,j) = distance(1,j)+DP(1,j-1);
end
for i=2:x_len
    for j=2:y_len
        DP(i,j) = distance(i,j) + GetMin(DP(i-1,j),DP(i,j-1),DP(i-1,j-1));
    end
end
%回溯，找到各个特征点之间的匹配关系
i = x_len;
j = y_len;
while(~((i == 1)&&(j==1)))
    plot([i,j],[x(i),y(j)],'b');hold on %画出匹配之后的特征点之间的匹配关系
    if(i==1)
        index_i = 1;
        index_j = j-1;
    elseif(j==1)
        index_i = i-1;
        index_j = 1;
    else
    [index_i,index_j] = GetMinIndex(DP(i-1,j-1),DP(i-1,j),DP(i,j-1),i,j);
    end
    i = index_i;
    j = index_j;  
end 


% x = [1,3,4,2,5,7,0];
% y = [2,1,5,3,4,2,8,1];

dis = 0;
for i = 1:length(x)
    for j = 1:length(y)
        dis = dis + (x(i)^2+y(j)^2)^(1/2);
    end
end
dis

figure()

plot(1:length(x),x,'marker','o','markerfacecolor','r','LineWidth',1);
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('f(x)',fontweight='bold')
title('')
% set(gca,'FontSize',30,'Fontname', 'Times New Roman',fontweight='bold');

figure()
plot(1:length(y),y,'marker','o','markerfacecolor','r','LineWidth',1)
set(gca,'linewidth',2,'fontsize',15,'fontname','Times');

box on
grid on
xlabel('X-axis',fontweight='bold')
ylabel('g(x)',fontweight='bold')
title('')









% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% distr = [1267200, 1255500];
% distcp = [1008800, 991500];
% disudp = [324100, 312310];
% 
% figure()
% y=[distr;distcp;disudp];
% b=bar(y);
% grid on;
% ch = get(b,'children');
% set(gca,'XTickLabel',{'Traffic','TCP','UDP'},'FontSize',45,'Fontname', 'Times New Roman')
% % set(ch,'FaceVertexCData',[1 0 1;0 0 0;0.16,0.14,0.13])
% 
% legend('Before TimeGAN','After TimeGAN','FontSize',40,'LineWidth',5,fontweight='bold');
% ylabel('Dynamic time bending distance','fontname','times new roman','fontSize',60,fontweight='bold')






function min = GetMin(a,b,c)
if(a <= b && a <= c)
    min = a;
elseif(b <= a && b <= c)
    min = b;
elseif(c <= b && c <= a)
    min = c;
end
end

function [index_i,index_j] = GetMinIndex(a,b,c,i,j)

if(a <= b && a <= c)
    index_i = i-1;
    index_j = j-1;
elseif(b <= a && b <= c)
    index_i = i-1;
    index_j = j;
elseif(c <= b && c <= a)
    index_i = i;
    index_j = j-1;
end
end



function [in] = gan(in)
    ave = mean(in(200:300))/2;
    for i = 200 : 301
        x = rand();
        y = rand();
        in(i) = in(i) + (x - y) * ave;
    end
end








