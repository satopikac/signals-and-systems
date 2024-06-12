load dfh_song_tone.mat
load dfh_last_time.mat

tone=dfh_song_tone;
f=[];
for i=1:length(tone)
    tones=tone(i);
    f1=cal_f(tones,523.25);
    if(f1>0)
     f=[f,f1];
    end
end
f=f*1;%完成频率计算
% 只考虑一个八度内的音乐

fs=8000; %采样频率
last_time=dfh_last_time;
one_step = 0.5;      %一个节拍所需时间 

t_max = sum(last_time * one_step);
t = linspace(0,t_max,t_max*fs);  
song = 0 * t;%歌曲序列

left_t=0; %定义当前时间

scale=1.15;

load('mqy_guitar_weight_final.mat')%此文件含有吉他的各音调傅里叶信息

weight = guitar_weight;
weight(:,10:28)=0; %高频谐波忽略


nums=length(tone);
N=[];
for i=1:nums-2
    gate=(t>=left_t&t<left_t+one_step*last_time(i)*scale);%声音生成区间
    right_time=left_t+one_step*last_time(i)*scale;
   
    n = round(log2(f(i)/174.61)*12+1);         %十二平均律求对应的位置
    if(n<1 || n > 12)
        n = mod(n,12);
    end 
    if(n==0)continue;end
  

    N=[N,n];

    [r,c] = size(weight);
    y=0*t;
    for j= 1:c
        if(weight(n,j)~=0)
            y = y + weight(n,j)*sin(2*pi*j*f(i)*(t-left_t));
        end
    end
    if(i==5)
        plot(y)
    end
    song_of_single_key= gate.*y;   
    sosk_adj=adj_music(song_of_single_key,left_t,one_step*last_time(i)*scale,t);
    song=sosk_adj+song;
    left_t=left_t+one_step*last_time(i);
end
sound(song,fs)
plot(song)