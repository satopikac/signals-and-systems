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

scale=1.1;
weight = [1,1.45313083421944,0.951432937659109,1.09709115326487,0.0600275872091436,0.107171354165874];    %1-6各谐波分量权重
nums=length(tone);
for i=1:nums
    gate=(t>=left_t&t<left_t+one_step*last_time(i)*scale);
   song_of_single_key= gate.* ( (weight(1))*sin( 2*pi*f(i)*(t-left_t)) + (weight(2))*sin( 4*pi*f(i)*(t-left_t)) +  (weight(3))*sin( 6*pi*f(i)*(t-left_t))+(weight(4))*sin( 8*pi*f(i)*(t-left_t))+(weight(5))*sin( 10*pi*f(i)*(t-left_t))+(weight(6))*sin( 12*pi*f(i)*(t-left_t))); 
    sosk_adj=adj_music(song_of_single_key,left_t,one_step*last_time(i)*scale,t);
    song=sosk_adj+song;
    left_t=left_t+one_step*last_time(i);
end
sound(song,fs)
plot(song)