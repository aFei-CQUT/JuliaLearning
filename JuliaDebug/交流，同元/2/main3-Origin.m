clear all
close all
%正交采样仿真——三种方法的性能比较
%波形参数
N = 1024 * 8;
N2 = N/2;
N4 = N/4;  %信号采样点数
N1 = 64;
f0 = 60e6;  %中心频率60MHz
B = 2e6;  %频偏,即信号带宽
m = 8;
fs = 4 * f0/(2 * m - 1);  %采样速率,16MHz(M=8)
Ts = 1/fs;  %采样间隔
tts = 0:Ts:((N + N1 -1) * Ts);
quantize_en = 0;  %是否添加量化噪声标志,1——量化
%滤波器设计
Nf = 63;  %滤波器的阶数
ff =[0 0.4 0.60 1];
aa =[1 1 0 0];
bb_lp = remez(Nf, ff, aa);  %remez法,低通滤波法
bb_mp = fir1(Nf, 0.25, kaiser(Nf + 1, 15));  %Kaiser窗函数,多相滤波法
if quantize_en == 0
    bb_lp = round(bb_lp .* 2^15/max(bb_lp));  %normalize 16bit
    bb_mp = round(bb_mp .* 2^15/max(bb_mp));  %normalize 16bit
end
figure;
freqz(bb_lp)
title("Remez方法设计的低通滤波器的幅相特性")
figure;
freqz(bb_mp)
title("Kaiser窗设计的低通滤波器的幅相特性")
b1 = bb_lp(1:2:Nf + 1);
b2 = bb_lp(2:2:Nf + 1);  %低通滤波法的系数
b3 = bb_mp(3:4:Nf + 1);
b4 = bb_mp(1:4:Nf + 1);  %多相滤波法的系数
%模拟信号产生、符号变换
fd = 1.0e6;  %信号的多普勒频率
ss = 1000 * cos(2 * pi * (f0 + fd) * tts);  %模拟输入信号
figure;
freqz(ss)
title("模拟输入信号")
ii1 = ss(1:2:N + N1);  %2倍抽取
qq1 = ss(2:2:N + N1);
if rem(m, 2) == 0
    sa = ss .* kron(ones(1, (N + N1)/4), [1 1 -1 -1]);  %m=偶数 符号修正
else
    sa = ss .* kron(ones(1, (N + N1)/4), [-1 1 1 -1]);  %m=奇数 符号修正
end
ii1 = ii1 .* kron(ones(1, (N + N1)/4), [1 -1]);
qq1 = qq1 .* kron(ones(1, (N + N1)/4), [1 -1]);  %m=偶数,[1 -1];m=奇数,[-1 1]
%低通滤波法，得到基带I、Q信号
ii = filter(b2, 1, ii1);
qq = filter(b1, 1, qq1);  %低通滤波法,两路滤波器从同一个滤波器中抽取
Z1 = ii((N1/2):((N + N1)/2 - 1)) + 1j * qq((N1/2):((N + N1)/2 - 1));
Z1f = db(fftshift(fft(Z1, N2)));  %正交采样后的信号频谱
fff = (-N2/2:N2/2 - 1) * fs/N2 * 1e-6;
figure;
freqz(Z1f)
title("低通滤波法得到的基带信号")
%多相滤波法,得到基带I、Q信号
ii = filter(b3, 1, ii1);
qq = filter(b4, 1, qq1);  %多相滤波法,两路滤波器从同一个滤波器中抽取
Z2 = ii((N1/2):((N + N1)/2 - 1)) + 1j * qq((N1/2):((N + N1)/2 - 1));
Z2f = db(fftshift(fft(Z2, N2)));  %正交采样后的信号频谱
figure;
freqz(Z2f)
title("多相滤波法得到的基带信号")
%Bessel插值法  %8阶,16点Bessel插值,得到基带I、Q信号
W_Bessel = [-5, 49, -245, 1225, 1225, -245, 49, -5]/2048;
ii_bessel = sa(8:2:end);
qq1 = sa(1:2:end);
qq2 = filter(W_Bessel, 1, qq1);
qq_bessel = qq2((1:N2) + 7);
Z3 = qq_bessel(1:N2) + 1j * ii_bessel(1:N2);
Z3f = db(fftshift(fft(Z3, N2)));  %正交采样后的信号频谱
figure;
freqz(Z3f)
title("Bessel插值法得到的基带信号")