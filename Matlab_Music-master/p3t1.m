tone=[5,5,6,2,1,1,6,2];
f=cal_f(tone,523.25);
f(7)=f(7)/2;
f=f*1;%完成频率计算

fs=8000; %采样频率
T = 4;  %设置音乐总时长为4s
t = linspace(0,T*1,T*fs);       %创建时间序列
song = 0 * t;%歌曲序列
one_step = 0.5;      %一个节拍所需时间 

last_time=[1,0.5,0.5,2,1,0.5,0.5,2];
left_t=0; %定义当前时间

% 1 1.45313083421944	0.951432937659109	1.09709115326487	0.0600275872091436	0.107171354165874	0.350680051728090	0.125334248300950	0.144399793515641	0.0645028979498517
%获得的傅里叶级数相对幅度

scale=1.15;

load('mqy_guitar_weight_final.mat')%此文件含有吉他的各音调傅里叶信息

weight = guitar_weight;
weight(:,10:28)=0; %高频谐波忽略


nums=length(tone);
N=[];
for i=1:nums
    gate=(t>=left_t&t<left_t+one_step*last_time(i)*scale);%声音生成区间
    right_time=left_t+one_step*last_time(i)*scale;
    
    n = round(log2(f(i)/174.61)*12+1);         %十二平均律求对应的位置
    if(n<1 || n > 12)
        n = mod(n,12);
    end
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