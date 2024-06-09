function[w,tw]=conv1(u,tu,v,tv)
%这个函数用来计算连续时间卷积
%输入：u v两个序列 tu tv表示抽样时间
%输出：w tw表示卷积结果和抽样时间

T=tu(2)-tu(1);
w=T*conv(u,v);
tw=tu(1)+tv(1)+T*(0:length(u)+length(v)-2)';
