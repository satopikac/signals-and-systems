function [F1,f1] = mqy_fft_and_cleanwave(signal,T,fs)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
input_signal = repmat(mqy_wave_ana(signal,T),1,10);
L = length(input_signal);
T1 = 1/fs;
OMG = fs;
f1 = linspace(-OMG/2,OMG/2-OMG/L,L);
t1 = linspace(0,(L-1)/fs,L);

F = fft(input_signal);
F = fftshift(F);
F1 = abs(F)/L;


end