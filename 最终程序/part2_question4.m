
%这部分是6.2.2 用傅里叶级数合成音乐的问题4

[fmt,fs]=audioread("fmt.wav");
t = linspace(0,(length(fmt)-1)/fs,length(fmt));
%去掉两端音量比较小的部分（即静音）
std=0.005;
A=find(fmt>std);%返回索引
fmt=fmt(A(1):A(end-1));
%其实差别也不是特别的大

%计算向量 y 中连续 step 长度的子段的能量（即子段中所有元素的平方和），
% 并将这些能量值存储在一个名为 energy 的向量中。
% 如果子段超出了向量 y 的长度 L，则只计算到 y 的末尾。

y=fmt;
step = 25;                      %计算能量步长为25
L = length(y);         
time = ceil(L/step);      %计算次数
energy = zeros(1, L);  % 初始化 energy 为一个长度为 L 的零向量  

for i = 1:time  
    start_idx = (i-1)*step + 1;  
    end_idx = min(i*step, L);  % 确保不超出 y 的长度  
    sum_e = sum(y(start_idx:end_idx).^2);  
    energy(start_idx:end_idx) = sum_e;  % 直接赋值
end 



%找到信号的极大值尖峰段 就是一个音的开始
% 假设 x 是信号能量，N 是每个区间的长度，threshold 是最小峰值幅度  
x = energy; % 信号数据  
N = 750; % 每个区间的长度  
threshold = 0.1; % 最小峰值幅度  

real_point=mqy_find_peak(x,N,threshold);

% 绘制信号和峰值点  
% num = length(real_point);  
% plot(1:length(x), x); % 绘制信号  
% hold on;  
% scatter(real_point, x(real_point), 'r*', 'DisplayName', 'Peak Points'); % 绘制峰值点  
% xlabel('Index');  
% ylabel('Energy');  
% title(['Signal with ' num2str(num) ' Peak Points']);  
% legend show;


time_p=real_point/fs; %确定峰值点的时间位置

time_point=[real_point,length(x)];%求两个冲激点的时间间隔
diff_t=diff(time_point); %差分求出采样点差值
step=round(diff_t/min(diff_t));        %算出节拍数
one_step=median(diff_t); %一拍用中位数代替
time_step=one_step/fs %单拍时间近似

index = find(diff_t == median(diff_t));
jiepai = step/step(index(1))%           得到节拍







%音调的求解
%对上面划分出的每一个音符所在音乐进行傅里叶变换
%找到频率

%通过求解自相关系数获得周期等信息
message = string();
guitar_info = zeros(12,28);     

len=length(real_point);
% 对每一个音符进行操作
T_note=[];
for i_rp=1:len-1
% for i_rp=10:10
   l_note=real_point(i_rp+1)-real_point(i_rp);
    %一个音符音乐四分，取中间两段进行自相关分析 求出周期
    note = fmt(real_point(i_rp)+ceil(l_note/4):real_point(i_rp+1)-ceil(l_note/4));
    % L2=real_point(2)-real_point(1);
    % note=fmt(real_point(1)+ceil(L2/4):real_point(2)-ceil(L2/4));
    [a,b] = xcorr(note,'unbiased');
    corr=a(b>=0);
    lag=b(b>=0);
    maxp=corr(lag==0); %此处自相关系数最大 以其0.3倍作为阈值
    threshold2 = maxp*0.3; % 假设阈值是最大幅度的30%
  
    % 找到超过阈值的峰值  
     index= mqy_find_peak(corr,10,threshold2);
    % plot(lag,corr);


    x_d=diff(index);
    T=sum(x_d)/length(x_d);  %不一定是整数
    T_note=[T_note,T];%每一个音符的周期
     [fourier_f,f] = mqy_fft_and_cleanwave(note,T,fs);%进行fourier变换
     fourier_f = fourier_f(f>=0);    %保留正频率部分
     f = f(f>=0); 
   % plot(f, fourier_f)
    f_index = mqy_find_peak(fourier_f,50,0.01*max(fourier_f));
    %找到极值点的索引
    %阈值 0.01*max(fourier_f)
   
   %  figure(55555);
   %  subplot(ceil(len/2),2,i_rp);
   %  plot(f,fourier_f);
   %  title(num2str(i_rp));
   %  xlabel('');
   %  ylabel('');
   % 
   %  hold on;                        
   %  scatter(f(f_index),fourier_f(f_index));
   %  hold off;
    %分析出了每一个音符中出现的基波和多次谐波
    %分析音调
    %将信息进一步提取出来
    
   A = mqy_recognize(f(f_index),fourier_f(f_index)); %传入极值点的频率和幅度
   %将信息储存到可调用的矩阵中
   %得到每一个音符内 基频和谐波的频率和幅度信息

   note_msg = "第"+string(num2str(i_rp))+"个音"+"的拍数是:"+string(num2str(jiepai(i_rp))) + ' ';
   message = [message;note_msg;mqy_read_music_msg(A)];

   %以上的message存储了每一个音符的音调和节拍信息 可以直接使用
   %下面会将其导出






   %下面另将此种乐器的特征傅里叶谐波信息储存起来 供后面任务合成音乐用

if(A(4,1) >= 174.61*0.98 && A(4,1) <= 329.63*1.02)
        %认为在需要的频率范围内
        n = round(log2(A(4,1)/174.61)*12+1);
        if(guitar_info(n,1)==0)
            y =mqy_write_xiebo(A);
            guitar_info(n,:) = [y,zeros(1,28-length(y))];
        end
 end

end
file = fopen('mqy_msg.txt','w+');  %把获取的音符信息写入txt文件
fprintf(file,'%s',message);

save('guitar_info.mat', 'guitar_info'); %音色的傅里叶信息储存在guitar_info文件
%数据集不全 需要后续调整
