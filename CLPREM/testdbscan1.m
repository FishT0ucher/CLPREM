clc,clear,close all;

traffic = load('all.mat'); 
tcp_traffic = load('tcp.mat'); 
udp_traffic = load('udp.mat');

a = load('all1.mat'); 

traffic = traffic.all_cluster';
tcp_traffic = tcp_traffic.tcp_cluster';
udp_traffic = udp_traffic.udp_cluster';
% traffic = traffic(1:112);
% save('D:\pythonProject\traffic.mat','traffic');
% tcp_traffic = tcp_traffic(1:112);
% udp_traffic = udp_traffic(1:112);
scatter3(tcp_traffic,udp_traffic,traffic,'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75])
% view(-30,10)


 
X = [tcp_traffic(100:500),traffic(100:500),udp_traffic(100:500)] * 10;   %
epsilon= 7;
MinPts= 15;
IDX1=DBSCAN(X,epsilon,MinPts);
cluster1 = [];
cluster2 = [];
cluster3 = [];
for i = 1:length(IDX1)
    if IDX1(i) == 1
        cluster1 = [cluster1;X(i,:)];
        cluster2 = [cluster2;[0,0,0]];
        cluster3 = [cluster3;[0,0,0]];
    elseif IDX1(i) == 2
        cluster2 = [cluster2;X(i,:)];
        cluster1 = [cluster1;[0,0,0]];
        cluster3 = [cluster3;[0,0,0]];
    else
        cluster3 = [cluster3;X(i,:)];
        cluster2 = [cluster2;[0,0,0]];
        cluster1 = [cluster1;[0,0,0]];
    end
end
% save('C:\Users\admin\Desktop\2.mat','i','num')
save('D:\pythonProject\cluster1.mat','cluster1');
save('D:\pythonProject\cluster2.mat','cluster2');
save('D:\pythonProject\cluster3.mat','cluster3');

sum1 = 0;
for i = 1:length(cluster1)
    if cluster1(i) ~= 0
        sum1 = sum1 + 1;
    end
end
sum1 = sum1/length(cluster1);

sum2 = 0;
for i = 1:length(cluster2)
    if cluster2(i) ~= 0
        sum2 = sum2 + 1;
    end
end
sum2 = sum2/length(cluster2);

sum3 = 0;
for i = 1:length(cluster3)
    if cluster3(i) ~= 0
        sum3 = sum3 + 1;
    end
end
sum3 = sum3/length(cluster3);





%%  DBSCAN
function [IDX, isnoise]=DBSCAN(X,epsilon,MinPts)
C=0;   %
n=size(X,1);
IDX=zeros(n,1);
D = pdist2(X,X);  % 互相之间的距离
 
visited=false(n,1);
isnoise=false(n,1);
 
for i=1:n
    if ~visited(i)
        visited(i)=true;
        
        Neighbors=RegionQuery(i);   % 找出小于半径的值  返回 ID
        if numel(Neighbors)<MinPts  % 如果元素个数小于邻域中数据对象数目阈值 判定为噪点
            % X(i,:) is NOISE
            isnoise(i)=true;
        else
            C = C+1;    % 定为一个簇
            ExpandCluster(i,Neighbors,C);  % 扩展群集
        end
        
    end
    
end
 
    function ExpandCluster(i,Neighbors,C)
        IDX(i)=C;
        
        k = 1;
        while true
            j = Neighbors(k);
            
            if ~visited(j)
                visited(j)=true;
                Neighbors2=RegionQuery(j);
                if numel(Neighbors2)>=MinPts
                    Neighbors=[Neighbors Neighbors2];   %#ok
                end
            end
            if IDX(j)==0
                IDX(j)=C;
            end
            
            k = k + 1;
            if k > numel(Neighbors)
                break;
            end
        end
    end
 
    function Neighbors=RegionQuery(i)
        Neighbors=find(D(i,:)<=epsilon);
    end
    
    % 画图
    PlotClusterinResult(X, IDX)
 
end
 
function PlotClusterinResult(X, IDX)
 
k=max(IDX);
 
Colors=hsv(k);
 
Legends = {};
for i=0:k
    Xi=X(IDX==i,:);
    if i~=0
        Style = 'o';
        MarkerSize = 4;
        Color = Colors(i,:);
        Legends{end+1} = ['Cluster #' num2str(i)];
    else
        Style = 'o';
        MarkerSize = 4;
        Color = [0 0 0];
        if ~isempty(Xi)
            Legends{end+1} = 'Cluster #3';
        end
    end
    if ~isempty(Xi)
        
h = plot3(Xi(:,1),Xi(:,2),Xi(:,3),Style,'MarkerSize',MarkerSize,'Color',Color,'LineWidth',2);     
    end
    hold on;
end
xlabel('TCP Traffic MBps','fontweight','bold')
ylabel('Traffic MBps','fontweight','bold')
zlabel('UDP Traffic MBps','fontweight','bold')
hold off;
axis equal;
grid on;
legend(Legends);
legend('Location', 'NorthEastOutside');
g = get(h,'Parent');
set(g,'LineWidth',3) 
set(gca,'FontSize',15)
end