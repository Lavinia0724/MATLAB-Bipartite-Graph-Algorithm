% 清空命令窗口內容
clc
% 清空工作空間所有變量
clear
% 關閉所有 figure 視窗
close all

% 宣告全域變數 M、N、Map、p、visited
% M 是 process、N 是 Edge server
global M
global N
global Map
global p
global visited

M = 6;
N = 7;
% Process 與 Edge Server 連線狀況
Map = [1 1 0 1 0 0 0;
	0 1 0 0 1 0 0;
	1 0 0 1 0 0 1;
	0 0 1 0 0 1 0;
	0 0 0 1 0 0 0;
	0 0 0 1 0 0 0];

% 紀錄 Edge Server 對應的 Process
p = zeros(N, 1);

% 紀錄 Edge Server 是否已被拜訪過
% zeros(N, 1) 創建一個 N * 1 個 0 的 vector
visited = zeros(N, 1);

% 呼叫 Hungarian function 並接收 return 回傳的 cnt 變數
cnt = Hungarian();

% 宣告 Hungarian 匈牙利演算法 function
function cnt = Hungarian()
global M
global N
global Map
global p
global visited

% 紀錄成功匹配的線路有多少條
cnt = 0;
graph_num = 1;

% 呼叫 display_graph function 畫圖
display_graph(graph_num, 'Original Hungarian Bipartite Graph');
for i = 1: M
	% 將所有 visited 預設為 0 (未被拜訪過)
	visited = zeros(N, 1);
	
	% 如果匹配成功，cnt + 1
	if match(i)
		cnt = cnt + 1;
	end
	
	graph_num = graph_num + 1;
	display_graph(graph_num, ['Hungarian Bipartite Graph Step ' num2str(i)]);
end

% 輸出最終配對結果
graph_num = graph_num + 1;
display_graph(graph_num, 'Hungarian Bipartite Graph Final Result ');
end

% 宣告 match 匹配 function
function result = match(i)
global M
global N
global Map
global p
global visited

% 根據 Edge Server 的數量跑 j
for j = 1: N
	% 如果 i j 之間連接著，且此連接未被訪問過
	if Map(i, j) && ~visited(j)
		% 記錄此連接已被訪問
		visited(j) = 1;
		% 如果 j 這個 Edge Server 還未被匹配 process 
		% 或 j 原所匹配的 process 可找到新的匹配
		% 則讓其去匹配其他 Edge Server，而 j Edge Server 匹配 i process
		if p(j) == 0 || match(p(j))
			p(j) = i;
			% 回傳匹配成功
			result = true;
			return;
		end
	end
end
% 遍歷過所有線路，無法匹配，回傳失敗
result = false;
return;
end

% 宣告 display_graph 繪製當前二分圖匹配狀態 figure
function display_graph(graph_num, title_name)
global M
global N
global Map
global p
global visited

max_num = max(M, N);
temp = max_num - 1;

figure(graph_num);

% 清除當前座標
cla
set(gca, 'XTick', [], 'YTick', []);
set(gca, 'TickLength', [0 0]);

% 將座標區的屬性設置為 on
box on
% 保留當前座標區的 figure
hold on

% 當前座標區的 X Y 軸範圍
xlim([-1, 2]);
ylim([-max_num, 1]);

% 繪製 process 與 edge server 之間的連線狀態的邊
[row, col] = find(Map);
for j = 1: length(row)
	plot([0, 1], [(row(j) - 1) * -temp/(M-1), (col(j) - 1) * -temp/(N-1)], 'k', 'LineWidth', 1);
end
for j = 1: length(p)
	if p(j) ~= 0
		plot([0, 1], [(p(j) - 1) * -temp/(M-1), (j-1) * -temp/(N-1)], 'r', 'LineWidth', 2);
	end
end

% 繪製點
scatter(zeros(1, M), 0:-temp/(M-1):-temp, 20, [217/255 83/255 25/255], 'filled');
scatter(ones(1, N), 0:-temp/(N-1):-temp, 20, [0 114/255 189/255], 'filled');
for j = 1: M
	text(-0.2, (j-1) * -temp/(M-1), ['P_' num2str(j)]);
end
for j = 1: N
	text(1.1, (j-1) * -temp/(N-1), ['E_' num2str(j)]);
end
title(title_name);

% 儲存圖片
set(gcf, 'Renderer', 'painters');
saveas(gcf, [title_name '.png']);

end