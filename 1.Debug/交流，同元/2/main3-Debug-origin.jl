using TyMath
using TyBase
using TyPlot
using TySignalProcessing

# 正交采样仿真——三种方法的性能比较

# 波形参数
N = 1024 * 8        # 总采样点数
N2 = N ÷ 2          # 总采样点数的一半
N4 = N ÷ 4          # 总采样点数的四分之一
N1 = 64             # 额外的采样点数，用于滤波器初始化
f0 = 60e6           # 中心频率 60MHz
B = 2e6             # 频偏，即信号带宽
m = 8               # 下采样因子
fs = 4 * f0 / (2 * m - 1)       # 采样速率，16MHz (M=8)
Ts = 1 / fs                     # 采样间隔
tts = 0:Ts:((N + N1 - 1) * Ts)  # 时间序列
quantize_en = 0                 # 是否添加量化噪声标志，1——量化，0——不量化

# 滤波器设计
Nf = 63                         # 滤波器阶数

# Remez 算法设计低通滤波器
bands = [0, 0.2, 0.3, 0.5]      # 频带范围限制在 0 到 0.5
desired = [1, 0]                # 期望的频率响应
bb_lp = remez(Nf + 1, bands, desired)

# Kaiser 窗设计
w = kaiser(Nf + 1, 15.0)
bb_mp = fir1(Nf, 0.25, w)

# 如果不进行量化，则将滤波器系数归一化到16位整数
if quantize_en == 0
    bb_lp = round.(Int, bb_lp .* 2^15 ./ maximum(bb_lp))  # normalize 16bit
    bb_mp = round.(Int, bb_mp .* 2^15 ./ maximum(bb_mp))  # normalize 16bit
end

# 绘制滤波器的频率响应
TySignalProcessing.freqz(bb_lp, [1]; plotfig = true)
title("Remez算法设计的低通滤波器的幅相特性")

TySignalProcessing.freqz(bb_mp, [1]; plotfig = true)
title("Kaiser窗设计的低通滤波器的幅相特性")

# 提取滤波器系数
b1 = bb_lp[1:2:end]
b2 = bb_lp[2:2:end]                               # 低通滤波法的系数
b3 = bb_mp[3:4:end]
b4 = bb_mp[1:4:end]                               # 多相滤波法的系数

# 模拟信号产生、符号变换
fd = 1.0e6                                        # 信号的多普勒频率
ss = 1000 .* cos.(2.0 .* pi .* (f0 + fd) .* tts)  # 模拟输入信号

# 绘制模拟输入信号的频谱
TySignalProcessing.freqz(ss, [1]; plotfig = true)
title("模拟输入信号频谱")

# 信号采样和预处理
ii1 = ss[1:2:N+N1]  # 2倍抽取
qq1 = ss[2:2:N+N1]

# 符号修正
if rem(m, 2) == 0
    sa = ss .* repeat([1, 1, -1, -1], outer=(N + N1) ÷ 4)  # m=偶数 符号修正
else
    sa = ss .* repeat([-1, 1, 1, -1], outer=(N + N1) ÷ 4)  # m=奇数 符号修正
end

ii1 = ii1 .* repeat([1, -1], outer=(N + N1) ÷ 4)
qq1 = qq1 .* repeat([1, -1], outer=(N + N1) ÷ 4)           # m=偶数,[1, -1];m=奇数,[-1, 1]

# 低通滤波法，得到基带I、Q信号
ii, = filter1(b2, [1], ii1)
qq, = filter1(b1, [1], qq1)
Z1 = ii[(N1÷2):((N+N1)÷2-1)] + im * qq[(N1÷2):((N+N1)÷2-1)]
Z1f = db.(fftshift(fft(Z1)))                               # 正交采样后的信号频谱
fff = (-N2÷2:N2÷2-1) * fs / N2 * 1e-6

# 绘制低通滤波法得到的基带信号频谱
TySignalProcessing.freqz(Z1f, [1]; plotfig=true)
title("低通滤波法得到的基带信号")

# 多相滤波法，得到基带I、Q信号
ii, = filter1(b3, [1], ii1)
qq, = filter1(b4, [1], qq1)
Z2 = ii[(N1÷2):((N+N1)÷2-1)] + im * qq[(N1÷2):((N+N1)÷2-1)]
Z2f = db.(fftshift(fft(Z2)))                              # 正交采样后的信号频谱

# 绘制多相滤波法得到的基带信号频谱
TySignalProcessing.freqz(Z2f, [1]; plotfig=true)
title("多相滤波法得到的基带信号")

# Bessel插值法 - 8阶，16点Bessel插值，得到基带I、Q信号
W_Bessel = [-5, 49, -245, 1225, 1225, -245, 49, -5] ./ 2048
ii_bessel = sa[8:2:end]
qq1 = sa[1:2:end]
qq2, = filter1(W_Bessel, [1], qq1)
qq_bessel = qq2[(1:N2).+7]
Z3 = qq_bessel[1:N2] + im * ii_bessel[1:N2]
Z3f = db.(fftshift(fft(Z3)))                             # 正交采样后的信号频谱

# 绘制Bessel插值法得到的基带信号频谱
TySignalProcessing.freqz(Z3f, [1]; plotfig=true)
title("Bessel插值法得到的基带信号");
