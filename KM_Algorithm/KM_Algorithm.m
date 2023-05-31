% 清空命令窗口內容
clc
% 清空工作空間所有變量
clear
% 關閉所有 figure 視窗
close all

global N
global adj_matrix
global label_left
global label_right
global match_right
global visited_left
global visited_right

% 宣告有 N 個 process 和 Edge Server
N = 5;
% Process 與 Edge Server 配對的優先狀況
adj_matrix = [3 4 6 4 9;
				6 4 5 3 8;
				7 5 3 4 2;
				6 3 2 2 5;
				8 4 5 4 7];

% 初始化 label_left 每一行的最大值的 row vector
label_left = max(adj_matrix, [], 2);
% 初始化 label_right 為 N * 1 個 0 的 vector
label_right = zeros(N, 1);

% 創立一個 N * 1 個 nan 的 vector
% (透過先創立 N * 1 個 1 的 vector 再乘以 nan 所以全部是 nan)
match_right = ones(N, 1) * nan;

% 初始化 visited 為 N * 1 個 false 的 vector
visited_left = ones(N, 1) * false;
visited_right = ones(N, 1) * false;

% 呼叫 Hungarian function 並接收 return 回傳的 res 變數
res = KM();

% 宣告 KM 演算法 function
function res = KM()
global N
global adj_matrix
global label_left
global label_right
global match_right
global visited_left
global visited_right

graph_num = 1;

% 呼叫 display_graph function 畫圖
display_graph(graph_num, 'Original KM Bipartite Graph')

% 對 process 依序進行處理
for i = 1: N
	while 1
		% 將所有 visited 預設為 0 (未被拜訪過)
		visited_left = ones(N, 1) * false;
		visited_right = ones(N, 1) * false;

		% 利用深度優先查詢尋找可匹配的解法
		if dfs(i)
			break;
		end

		% 宣告一個常數 d
		d = Inf;

		% 已被匹配過的 process 透過修改 d 來重新尋找目前現以匹配的連線是否能擴大
		% 取 process 其他可連線的匹配優先權與當前 process 匹配連線的優先權中相差最小的兩條邊
		% 使得當前優先權加總值最大
		for j = 1: N
			if visited_left(j)
				for k = 1: N
					if ~visited_right(k)
						d = min(d, label_left(j) + label_right(k) - adj_matrix(j, k));
					end
				end
			end
		end
		for k = 1: N
			if visited_left(k)
				label_left(k) = label_left(k) - d;
			end
			if visited_right(k)
				label_right(k) = label_right(k) + d;
			end
		end
	end
	graph_num = graph_num + 1;
	display_graph(graph_num, ['KM Bipartite Graph Step ' num2str(i)]);
end

% 輸出最終配對結果
graph_num = graph_num + 1;
display_graph(graph_num, 'KM Bipartite Graph Final Result ');

% 加總最後的優先權總和
res = 0;
for j = 1: N
	if match_right(j) >= 0 && match_right(j) < N
		res = res + adj_matrix(match_right(j), j);
	end
end
end

% 宣告 function 來利用深度優先查詢尋找可匹配的解法
function result = dfs(i)
global N
global adj_matrix
global label_left
global label_right
global match_right
global visited_left
global visited_right

visited_left(i) = true;
for j = 1: length(adj_matrix(i, :))
	match_weight = adj_matrix(i, j);
	if visited_right(j)
		% 如果 Edge Server 已被匹配就提前結束
		continue;
	end

	gap = label_left(i) + label_right(j) - match_weight;
	if gap == 0
		% 記錄此連接已被訪問
		visited_right(j) = true;
		% 如果 j 這個 Edge Server 還未被匹配 process 
		% 或 j 原所匹配的 process 可找到新的匹配
		% 則讓其去匹配其他 Edge Server，而 j Edge Server 匹配 i process
		if isnan(match_right(j)) || dfs(match_right(j))
			match_right(j) = i;
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
global N
global adj_matrix
global label_left
global label_right
global match_right
global visited_left
global visited_right

figure(graph_num);

% 設置 gcf 中的左邊界、下邊界、上邊界、右邊界
set(gcf, 'Position', [100, 100, 1000, 500]);

% 創建一個 1 * 2 的網格視窗區並在 1 的位置創造座標區
subplot(1, 2, 1);

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
ylim([-N, 1]);

temp = N - 1;

% 繪製 process 與 edge server 之間的連線狀態的邊
for j = 1: length(match_right)
	if ~isnan(match_right(j))
		plot([0, 1], [(match_right(j) - 1) * -temp/(N-1), (j - 1) * -temp/(N-1)], 'r', 'LineWidth', 2);
	end
end

% 繪製點
scatter(zeros(1, N), 0: -temp/(N-1): -temp, 20, [217/255 83/255 25/255], 'filled');
scatter(ones(1, N), 0: -temp/(N-1): -temp, 20, [0 114/255 189/255], 'filled');
for j = 1: N
	text(-0.2, (j - 1) * -temp/(N-1), ['P_' num2str(j)]);
end
for j = 1: N
	text(1.1, (j - 1) * -temp/(N-1), ['E_' num2str(j)]);
end
for j = 1: N
	text(-0.5, (j - 1) * -temp/(N-1), num2str(label_left(j)), 'Color', [217/255 83/255 25/255], 'FontSize', 15);
end
for j = 1: N
	text(1.4, (j - 1) * -temp/(N-1), num2str(label_right(j)), 'Color', [0 114/255 189/255], 'FontSize', 15);
end

% 圖片標題
title(title_name);

% 繪製優先權重表格
subplot(1, 2, 2);
cla
set(gca, 'XTick', [], 'YTick', []);
set(gca, 'TickLength', [0 0]);
box on
hold on
xlim([-1, N]);
ylim([-N, 1]);

for j = 0: N-1
	plot([j, j], [-N, 1], 'k');
end
for j = -N+1: 0
	plot([-1, N], [j, j], 'k');
end
for j = 1: N
	display_text(j, 0, ['P_' num2str(j)], 0);
end
for j = 1: N
	display_text(0, j, ['E_' num2str(j)], 0);
end
for i = 1: N
	for j = 1: N
		if match_right(j) == i
			display_text(i, j, num2str(adj_matrix(i, j)), 1);
		else
			display_text(i, j, num2str(adj_matrix(i, j)), 0);
		end
	end
end
 
% 儲存圖片
set(gcf, 'Renderer', 'painters');
saveas(gcf, [title_name '.png']);
end

% 在 row = x, col = y 顯示文本 t
function display_text(x, y, t, bold)
if bold
	text(y - 0.5, -x + 0.5, t, 'FontSize', 15, 'FontWeight', 'bold', 'Color', 'r');
else
	text(y - 0.5, -x + 0.5, t, 'FontSize', 15, 'FontWeight', 'normal', 'Color', 'k');
end
end
