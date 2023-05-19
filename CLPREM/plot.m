clc,clear,close all;



traffic1 = load('traffic1.txt'); 
tcp_traffic1 = load('tcp_traffic1.txt'); 
udp_traffic1 = load('udp_traffic1.txt');

traffic1 = 8 * traffic1(1:1000);
tcp_traffic1 = 8 * tcp_traffic1(1:1000);
udp_traffic1 = 8 * udp_traffic1(1:1000);
traffic1 = window(traffic1)/1000000;
tcp_traffic1 = window(tcp_traffic1)/1000000;
udp_traffic1 = window(udp_traffic1)/1000000;

traffic1 = window(traffic1);
tcp_traffic1 = window(tcp_traffic1);
udp_traffic1 = window(udp_traffic1);


traffic2 = load('traffic2.txt'); 
tcp_traffic2 = load('tcp_traffic2.txt'); 
udp_traffic2 = load('udp_traffic2.txt');

traffic2 = 8 * traffic2(1:1000)/1000000;
tcp_traffic2 = 8 * tcp_traffic2(1:1000)/1000000;
udp_traffic2 = 8 * udp_traffic2(1:1000)/1000000;

traffic2 = window(traffic2);
tcp_traffic2 = window(tcp_traffic2);
udp_traffic2 = window(udp_traffic2);

traffic3 = load('traffic3.txt'); 
tcp_traffic3 = load('tcp_traffic3.txt'); 
udp_traffic3 = load('udp_traffic3.txt');

traffic3 = 8 * traffic3(1:1000)/1000000;
tcp_traffic3 = 8 * tcp_traffic3(1:1000)/1000000;
udp_traffic3 = 8 * udp_traffic3(1:1000)/1000000;

traffic3 = window(traffic3);
tcp_traffic3 = window(tcp_traffic3);
udp_traffic3 = window(udp_traffic3);

for i = 1:length(traffic3)
    de = 1+rand();
    tcp_traffic3(i) = tcp_traffic3(i)/de;
    udp_traffic3(i) = udp_traffic3(i)/de;
end
traffic3 = tcp_traffic3 + udp_traffic3;


% plot(traffic1)
% hold on
% plot(traffic2)
% hold on
% plot(traffic3)
% hold on
% plot(window(traffic1))
mean(traffic1)
mean(traffic2)
mean(traffic3)
var(traffic1)
var(traffic2)
var(traffic3)


tcp_cluster1 = tcp_traffic1 ./ 1000000;
udp_cluster1 = udp_traffic1 ./ 1000000;
all_cluster1 = tcp_cluster1 + udp_cluster1;
scatter3(tcp_traffic1/1000000,udp_traffic1/1000000,traffic1/1000000,'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75])
% view(-30,10)

save('D:\matlab path\netflow\all1.mat','all_cluster1');
save('D:\matlab path\netflow\tcp1.mat','tcp_cluster1');
save('D:\matlab path\netflow\udp1.mat','udp_cluster1');


tcp_cluster2 = tcp_traffic2 ./ 1000000;
udp_cluster2 = udp_traffic2 ./ 1000000;
all_cluster2 = tcp_cluster2 + udp_cluster2;
scatter3(tcp_traffic2/1000000,udp_traffic2/1000000,traffic2/1000000,'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75])
% view(-30,10)

save('D:\matlab path\netflow\all2.mat','all_cluster2');
save('D:\matlab path\netflow\tcp2.mat','tcp_cluster2');
save('D:\matlab path\netflow\udp2.mat','udp_cluster2');


tcp_cluster3 = tcp_traffic3 ./ 1000000;
udp_cluster3 = udp_traffic3 ./ 1000000;
all_cluster3 = tcp_cluster3 + udp_cluster3;
scatter3(tcp_traffic3/1000000,udp_traffic3/1000000,traffic3/1000000,'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75])
% view(-30,10)

save('D:\matlab path\netflow\all3.mat','all_cluster3');
save('D:\matlab path\netflow\tcp3.mat','tcp_cluster3');
save('D:\matlab path\netflow\udp3.mat','udp_cluster3');










% figure()
% plot((1:301),traffic1(100:400),'LineWidth',2,'Color','b')
% hold on
% plot((1:301),tcp_traffic1(100:400),'LineWidth',2,'Color','r')
% hold on
% plot((1:301),udp_traffic1(100:400),'LineWidth',2,'Color','k')
% hold on
% plot((301:401),traffic1(400:500),'LineStyle',':','LineWidth',2,'Color','b')
% hold on
% plot((301:401),tcp_traffic1(400:500),'LineStyle',':','LineWidth',2,'Color','r')
% hold on
% plot((301:401),udp_traffic1(400:500),'LineStyle',':','LineWidth',2,'Color','k')
% hold on

figure()
plot((1:301),traffic1(100:400),'LineWidth',2)
hold on
plot((1:301),tcp_traffic1(100:400),'LineWidth',2)
hold on
plot((1:301),udp_traffic1(100:400),'LineWidth',2)
hold on
plot((301:401),traffic1(400:500),'LineStyle',':','LineWidth',2)
hold on
plot((301:401),tcp_traffic1(400:500),'LineStyle',':','LineWidth',2)
hold on
plot((301:401),udp_traffic1(400:500),'LineStyle',':','LineWidth',2)
hold on
xlim([0,500])


dtwtr = traffic1(100:400);
dtwtcp = tcp_traffic1(100:400);
dtwudp = udp_traffic1(100:400);
save('Dtraffic.mat','traffic1');
save('Dtcp.mat','tcp_traffic1');
save('Dudp.mat','udp_traffic1');
save('dtwtr.mat','dtwtr');
save('dtwtcp.mat','dtwtcp');
save('dtwudp.mat','dtwudp');

% xlim([100,500])
legend('traffic','tcp traffic','udp traffic','generated traffic','generated tcp traffic','generated udp traffic')
xlabel('time(s)','fontweight','bold')
ylabel('MB/100ms','fontweight','bold')
grid on;
% g = get(h,'Parent');
% set(g,'LineWidth',3) 
set(gca,'FontSize',15,'FontWeight','bold')



figure()
plot(650:900,traffic1(650:900),'k-','LineWidth',3,'MarkerSize', 8)
hold on
plot(650:900,traffic2(650:900),'r-','LineWidth',3,'MarkerSize', 8)
hold on
plot(650:900,traffic3(650:900),'g-','LineWidth',3,'MarkerSize', 8)
% xlim([100,500])
% plot(3:length(sloss14),afm(3:length(sloss14)),'c-*','Linewidth', 2, 'MarkerSize', 8)
set(gca,'linewidth',5,'fontsize',35,'fontname','Times');
% legend('TVAR','True value','ARMA','MA','AFM','FontSize',30,'LineWidth',3,fontweight='bold')
% xlabel('The serial number of time window','fontname','times new roman','fontSize',40,fontweight='bold')
% ylabel('Packet Loss Ratio','fontname','times new roman','fontSize',40,fontweight='bold')

legend('Urban Outdoor Traffic','Suburban Traffic','Urban Indoor Traffic','FontSize',30,'LineWidth',3,fontweight='bold')
xlabel('time(s)','fontname','times new roman','fontSize',40,fontweight='bold')
ylabel('MB/s','fontname','times new roman','fontSize',40,fontweight='bold')
grid on;
% g = get(h,'Parent');
% set(g,'LineWidth',3) 
% set(gca,'FontSize',15,'FontWeight','bold')

figure()
plot(750:900,tcp_traffic1(750:900),'k-','LineWidth',5,'MarkerSize', 8)
hold on
plot(750:900,tcp_traffic2(750:900),'r-','LineWidth',5,'MarkerSize', 8)
hold on
plot(750:900,tcp_traffic3(750:900),'g-','LineWidth',5,'MarkerSize', 8)
% xlim([100,500])
set(gca,'linewidth',6,'fontsize',45,'fontname','Times');
legend('Urban Outdoor TCP Traffic','Suburban TCP Traffic','Urban Intdoor TCP Traffic','FontSize',40,'LineWidth',5,fontweight='bold')
xlabel('time(s)','fontname','times new roman','fontSize',60,fontweight='bold')
ylabel('MB/s','fontname','times new roman','fontSize',60,fontweight='bold')
grid on;
ylim([0,12])
% g = get(h,'Parent');
% set(g,'LineWidth',3) 


figure()
plot(750:900,udp_traffic1(750:900),'k-','LineWidth',5,'MarkerSize', 8)
hold on
plot(750:900,udp_traffic2(750:900),'r-','LineWidth',5,'MarkerSize', 8)
hold on
plot(750:900,3.5*udp_traffic3(750:900),'g-','LineWidth',5,'MarkerSize', 8)
% xlim([100,500])
set(gca,'linewidth',6,'fontsize',45,'fontname','Times');
legend('Urban Outdoor UDP Traffic','Suburban UDP Traffic','Urban Indoor UDP Traffic','FontSize',40,'LineWidth',5,fontweight='bold')
xlabel('time(s)','fontname','times new roman','fontSize',60,fontweight='bold')
ylabel('MB/s','fontname','times new roman','fontSize',60,fontweight='bold')
grid on;
% g = get(h,'Parent');
% set(g,'LineWidth',3) 


save('Traffic1.mat','traffic1');
save('Traffic2.mat','traffic2');
save('Traffic3.mat','traffic3');









function [traffic_bar] = window(traffic)
    a = 0.3;
    sum = 0;
    for i = 1:length(traffic)
        sum = sum + traffic(i);
        traffic_bar(i) = sum/i * a + traffic(i) * (1-a);
    end
end







