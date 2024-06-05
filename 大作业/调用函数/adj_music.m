function adj_song= adj_music(music,begin_t,last_t,t)
%把一段音乐进行包络调整
%   乘以课本上提供的折线型包络
%music 需要调整的音乐
%begin_t end_t 音乐的起时间 持续时间
%t 音乐的时长序列
% 保证调整后音乐时长加上原本的音乐时长不过界

T = t(length(t)) ;   %音乐的总时长
if(begin_t + last_t > T)
    end_t = T ;%过界了，音乐的右界就是最终时长
else 
    end_t = begin_t + last_t;      
end

time = end_t - begin_t;  %音乐持续时间
gate = (t>=begin_t & t<begin_t+time/6).*(6/time*(t-begin_t)) + ...
                (t>=begin_t+time/6 & t<begin_t+time/3).*(-1.2/time*(t-begin_t-time/6)+1) + ...
                (t>=begin_t+time/3 & t<begin_t+time*2/3).*(0.8) + ...
                (t>=end_t-time/3 & t<end_t).*(-2.4/time*(t-end_t)); %包络
plot(gate)

adj_song=music.*gate;
end