% 创建 x 坐标和对应的 y 坐标数据

% 
% 使用 plot 函数绘制平滑连接的折线图
plot(x, a, '-o', 'MarkerFaceColor', 'green');
hold on;
plot(x, b, '-o', 'MarkerFaceColor', 'red');
plot(x, c, '-o', 'MarkerFaceColor', 'yellow');
plot(x, d, '-o', 'MarkerFaceColor', 'blue');
% 添加标题和坐标轴标签
title('平滑连接的折线图示例')
xlabel('月份')
ylabel('平均效率')


% figure();
% sz=25;
% scatter (unnamed(:,1),unnamed(:,2),'filled');
% axis equal
% c = colorbar;
% c.Label.String = '截断效率';
% title('镜场截断效率     3月21日 10:30', 'FontSize', 12);
% xlabel('X', 'FontSize', 10);
% ylabel('Y', 'FontSize', 10);
