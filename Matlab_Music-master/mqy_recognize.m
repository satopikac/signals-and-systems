function A = mqy_recognize(music_f, music_A)  
% recognize: 处理频率列表，得到信息  
% music_f: 各声波频率  
% music_A: 对应幅度  
% A: 每四行储存信息为（音调（0——11），对应几次谐波，谐波分量强度，频率值）  
  
A = []; % 初始化结果矩阵 A 为空  
base_freqs = []; % 存储已经找到的基频和幅度  
  
for i = 1:length(music_f)  
    if music_f(i) == 0  
        continue; % 跳过零频率  
    end  


    if(isempty(base_freqs)) %未有数据 第一次查找
        base_freqs(1:2,1)=[music_f(i),music_A(i)];
         A(1:4,1) = [mqy_translate(music_f(i));1;1;music_f(i)];
         %基波 音调 1次谐波 幅度定为1 
    else
       %先判断是否为基波的谐波分量
       is_mul = 0;      %判断是否谐波标志
       cor = 0;         %对应基波的index
       for k=1:length(base_freqs)
           sim = music_f(i)/base_freqs(k); %当前频率除以基频
           if(abs(sim-round(sim)) < 0.1)%若计算出为谐波分量
               is_mul = 1;   
               cor = k;     %能整除
               break;
           end
       end

       if(is_mul == 1)  %如果的确为谐波分量
           [r,c] = size(A);
           write_col = 0;
           %确定写入A的第几列
           for j = 1:c
               if(A(4*(cor-1)+2,j) == 0)
                    write_col = j;
                    break;
               end
           end

           if(write_col == 0)
               write_col = c+1;
           end

           %写入信息
           %write_col

           A(4*cor-3:4*cor,write_col) = ...
               [mqy_translate(base_freqs(1,cor));...
               round(music_f(i)/base_freqs(cor));...
               music_A(i)/base_freqs(2,cor);...
               music_f(i)];
       else %不是谐波 就是基频
      
           base_freqs(1:2,end+1) = [mqy_translate(music_f(i));music_A(i)];
           [r,c] = size(base_freqs);
           A(4*c+1:4*c+4,1) = [mqy_translate(music_f(i));1;1;music_f(i)];          
       end
    end



      




    % % 尝试找到当前频率对应的基频  
    % base_found = false;  
    % for k = 1:length(base_freqs)  
    %     ratio = music_f(i) / base_freqs(k);  
    %     if abs(ratio - round(ratio)) < 0.01 % 判断是否为整数比，即是否为谐波  
    %         base_found = true;  
    %         break;  
    %     end  
    % end  
    % 
    % if ~base_found % 如果没有找到基频，则认为它是新的基频  
    %     base_freqs(end+1) = music_f(i); % 将当前频率添加到基频列表中  
    %     % 将基频的信息添加到结果矩阵 A 中  
    %     A(end+1:end+4,:) = [mqy_translate(music_f(i)), 1, music_A(i), music_f(i)];  
    % else  
    %     % 找到了基频，则当前频率是某个基频的谐波  
    %     % 确定是哪一个基频的谐波  
    %     base_index = k;  
    % 
    %     % 找到结果矩阵 A 中对应基频的下一列（用于存储谐波信息）  
    %     col_index = size(A, 2) + 1;  
    %     while any(A(4*(base_index-1)+2, 1:col_index-1) ~= 0)  
    %         col_index = col_index + 1;  
    %     end  
    % 
    %     % 将谐波的信息添加到结果矩阵 A 中  
    %     A(4*(base_index-1)+1:4*base_index, col_index) = [  
    %         A(4*(base_index-1)+1, 1), % 音调（与基频相同）  
    %         round(ratio), % 谐波次数  
    %         music_A(i), % 谐波分量强度  
    %         music_f(i) % 频率值  
    %     ];  
    % end  
end  