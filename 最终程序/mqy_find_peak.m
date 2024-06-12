function index = mqy_find_peak(signal,step,threshold)
%计算峰值

x = signal; % 信号数据  
N = step; % 每个区间的长度  


% 初始化变量  
max_values = []; % 存储每个区间的最大值  
max_indices = []; % 存储每个区间最大值的索引  

% 确保N不大于信号长度  
if N > length(x)  
    error('N不能大于信号的长度');  
end    
% 计算区间数量  
num_intervals = ceil(length(x) / N);    

% 计算最后一个子区间的起始索引，避免在循环中重复检查  
last_start_idx = max(1, length(x) - N + 1);  
  
% 遍历所有子区间  
for i = 1:num_intervals  
    % 计算当前子区间的起始和结束索引  
    start_idx = max(1, (i-1)*N + 1);  
    end_idx = min(length(x), i*N);  
      
    % 在当前子区间内找到最大值和对应的索引  
    [this_max, this_max_index_relative] = max(x(start_idx:end_idx));  
      
    % 将相对索引转换为基于整个数组 x 的索引  
    this_max_index = this_max_index_relative + start_idx - 1;  
      
    % 将最大值和索引添加到结果数组中  
    max_values = [max_values, this_max];  
    max_indices = [max_indices, this_max_index];  
end
%选取合适的点
real_point = [];
if(max_values(1) > max_values(2) & max_values(1)>threshold)
    real_point = [real_point,max_indices(1)];
end
for i = 2:length(max_values)-1
    if(max_values(i)>max_values(i-1) & max_values(i)>max_values(i+1) &max_values(i)>threshold)
        real_point = [real_point,max_indices(i)];
    end
end
if(max_values(end)>max_values(end-1) && max_values(end)>threshold)
    real_point = [real_point,max_indices(end)];
end
index=real_point;
end