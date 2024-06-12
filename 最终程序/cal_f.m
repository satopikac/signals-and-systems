function fre = cal_f(tone,basic_fre)
%由简谱中数字来计算各个音符对应的频率
% tone 是0-8数字 basic_fre指基频
%   使用十二平均律
pow=[0,2,4,5,7,9,11,12];% 全半全半全全半 八度内C D E F G A B C_

if(tone==0)
    fre=0;
else
    fre=basic_fre*(2.^(pow(tone)/12));
end