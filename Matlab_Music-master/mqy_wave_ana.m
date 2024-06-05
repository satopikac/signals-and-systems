function cleanwave = mqy_wave_ana(signal,T)
%去除波段中的噪声
%signal 传入的信号 T 该段信号的周期
%平均值滤波
L = length(signal);
nums = ceil(L/T)-1; %信号中有几个整周期信号
if(nums >= 10) 
    nums = 10;   
end   %取不超过十个周期进行分析
signal = signal(1:ceil(nums*T)-1);  %取整数个周期进行分析


newsignal = resample(signal,10,1);     %乘10采样
%figure
%plot(newsignal);
f = zeros(1,ceil(10*T)-1);           %生成空单周期
power = ones(1,nums);           %幅度因子 把每一个周期的幅度归一化
                                     %存储让每个周期的信号归一化需要乘的权值
one_cycle = ceil(10*T)-1;            %10倍采样后单周期点数
%计算每个周期的修正因子
for k = 1:nums
    last = k*one_cycle;
    if(last > length(newsignal))
        last = length(newsignal);
    end
    power(k) = max(newsignal((k-1)*one_cycle+1:last))/ max(newsignal(1:one_cycle));
end
%归一因子 使各个周期的平均值与第一个周期相近

for k = 1:ceil(10*T)-1
    for i = 0:nums-1
        if(i*(ceil(10*T)-1)+k > length(newsignal))
            f(k) = f(k) + newsignal(length(newsignal))/power(i+1);
            break;
        else
            f(k) = f(k) + newsignal(i*(ceil(10*T)-1)+k)/power(i+1);
        end 
    end
    f(k) = f(k)/nums;
end
%得到单周期序列f

new_f = repmat(f,1,nums);
cleanwave = resample(new_f,1,10);
%figure
%plot(cleanwave);

end