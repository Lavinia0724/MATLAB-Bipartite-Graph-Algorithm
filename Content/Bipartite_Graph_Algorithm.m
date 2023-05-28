clc
clear
close all

global M
global N
global Map
global p
global visited

M = 6;
N = 7;
Map = [1 1 0 1 0 0 0;
		0 1 0 0 1 0 0;
		1 0 0 1 0 0 1;
		0 0 1 0 0 1 0;
		0 0 0 1 0 0 0;
		0 0 0 1 0 0 0];

p = zeros(N, 1);

visited = zeros(N, 1);
cnt = Hungarian();

function cnt = Hungarian()
global M
global N
global Map
global p
global visited

graph_num = 1;
cnt = 0;
display_graph(graph_num, 'Original Bipartite Graph');
for i = 1: M
	visited = zeros(N, 1);
	if match(i)
		cnt = cnt + 1;
	end
	graph_num = graph_num + 1;
	display_graph(graph_num, ['Step ' num2str(i)]);
end
graph_num = graph_num + 1;
display_graph(graph_num, 'Final Result ');
end

function result = match(i)
global M
global N
global Map
global p
global visited
for j = 1: N
	if Map(i, j) && ~visited(j)
		visited(j) = 1;
		if p(j) == 0 || match(p(j))
			p(j) = i;
			result = true;
			return;
		end
	end
end
result = false;
return;
end

function display_graph(graph_num, title_name)
global M
global N
global Map
global p
global visited

max_num = max(M, N);
temp = max_num - 1;
figure(graph_num);
cla
set(gca, 'XTick', [], 'YTick', []);
set(gca, 'TickLength', [0 0]);
box on
hold on
xlim([-1, 2]);
ylim([-max_num, 1]);

[row, col] = find(Map);
for j = 1: length(row)
	plot([0, 1], [(row(j) - 1) * -temp/(M-1), (col(j) - 1) * -temp/(N-1)], 'k', 'LineWidth', 1);
end
for j = 1: length(p)
	if p(j) ~= 0
		plot([0, 1], [(p(j) - 1) * -temp/(M-1), (j-1) * -temp/(N-1)], 'r', 'LineWidth', 2);
	end
end

scatter(zeros(1, M), 0:-temp/(M-1):-temp, 20, [217/255 83/255 25/255], 'filled');
scatter(ones(1, N), 0:-temp/(N-1):-temp, 20, [0 114/255 189/255], 'filled');
for j = 1: M
	text(-0.2, (j-1) * -temp/(M-1), ['x_' num2str(j)]);
end
for j = 1: N
	text(1.1, (j-1) * -temp/(N-1), ['y_' num2str(j)]);
end
title(title_name);

set(gcf, 'Renderer', 'painters');
saveas(gcf, [title_name '.png']);

end