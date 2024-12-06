using TyMath
using TyBase
using TyPlot
using TySignalProcessing
using TyDSPSystem

# 正交采样仿真——三种方法的性能比较
# 波形参数
N = 1024 * 8
N2 = N ÷ 2
N4 = N ÷ 4  # 信号采样点数
N1 = 64
f0 = 60e6  # 中心频率60MHz
B = 2e6  # 频偏,即信号带宽
m = 8
fs = 4 * f0 / (2 * m - 1)  # 采样速率,16MHz(M=8)
Ts = 1 / fs  # 采样间隔
tts = 0:Ts:((N + N1 - 1) * Ts)
quantize_en = 0  # 是否添加量化噪声标志,1——量化

# 滤波器设计
Nf = 63  # 滤波器的阶数
ff = [0, 0.4, 0.60, 1]
aa = [1, 1, 0, 0]
bb_lp = zeros(Nf + 1, 1)

for k = 0:Nf
    sum = 0
    for i = eachindex(ff)
        sum += aa[i] * cos(2 * pi * k * ff[i])
    end
    bb_lp[k+1] = sum
end  # remez法,低通滤波法

w = kaiser(N, 15.0)  # 创建Kaiser窗
bb_mp = fir1(N-1, 0.25, w)  # Kaiser窗函数,多相滤波法

if quantize_en == 0
    bb_lp = round.(Int, bb_lp .* 2^15 ./ maximum(bb_lp))  # normalize 16bit
    bb_mp = round.(Int, bb_mp .* 2^15 ./ maximum(bb_mp))  # normalize 16bit
end

# 绘制Remez方法设计的低通滤波器的幅相特性
f_lp = dsp_FIRFilter(Numerator = bb_lp)
freqz(f_lp; plotfig = true)
title("Remez方法设计的低通滤波器的幅相特性")

# 绘制Kaiser窗设计的低通滤波器的幅相特性
f_mp = dsp_FIRFilter(Numerator = bb_mp)
freqz(f_mp; plotfig = true)
title("Kaiser窗设计的低通滤波器的幅相特性")

b1 = bb_lp[1:2:end]
b2 = bb_lp[2:2:end]  # 低通滤波法的系数
b3 = bb_mp[3:4:end]
b4 = bb_mp[1:4:end]  # 多相滤波法的系数

# 模拟信号产生、符号变换
fd = 1.0e6  # 信号的多普勒频率
ss = 1000 .* cos.(2.0 .* pi .* (f0 + fd) .* tts)  # 模拟输入信号

# 绘制模拟输入信号的频谱
f_ss = dsp_FIRFilter(Numerator = ss)
freqz(f_ss; plotfig = true)
title("模拟输入信号频谱")

ii1 = ss[1:2:N+N1]  # 2倍抽取
qq1 = ss[2:2:N+N1]

if rem(m, 2) == 0
    sa = ss .* repeat([1, 1, -1, -1], outer=(N+N1)÷4)  # m=偶数 符号修正
else
    sa = ss .* repeat([-1, 1, 1, -1], outer=(N+N1)÷4)  # m=奇数 符号修正
end

ii1 = ii1 .* repeat([1, -1], outer=(N+N1)÷4)
qq1 = qq1 .* repeat([1, -1], outer=(N+N1)÷4)  # m=偶数,[1, -1];m=奇数,[-1, 1]

# 低通滤波法，得到基带I、Q信号
ii, = filter1(b2, [1], ii1)
qq, = filter1(b1, [1], qq1)
Z1 = ii[(N1÷2):((N+N1)÷2-1)] + im * qq[(N1÷2):((N+N1)÷2-1)]
f_Z1 = dsp_FIRFilter(Numerator = Z1)
freqz(f_Z1; plotfig = true)
title("低通滤波法得到的基带信号")

# 多相滤波法,得到基带I、Q信号
ii, = filter1(b3, [1], ii1)
qq, = filter1(b4, [1], qq1)
Z2 = ii[(N1÷2):((N+N1)÷2-1)] + im * qq[(N1÷2):((N+N1)÷2-1)]
f_Z2 = dsp_FIRFilter(Numerator = Z2)
freqz(f_Z2; plotfig = true)
title("多相滤波法得到的基带信号")

# Bessel插值法  # 8阶,16点Bessel插值,得到基带I、Q信号
W_Bessel = [-5, 49, -245, 1225, 1225, -245, 49, -5] ./ 2048
ii_bessel = sa[8:2:end]
qq1 = sa[1:2:end]
qq2, = filter1(W_Bessel, [1], qq1)
qq_bessel = qq2[(1:N2) .+ 7]
Z3 = qq_bessel[1:N2] + im * ii_bessel[1:N2]
f_Z3 = dsp_FIRFilter(Numerator = Z3)
freqz(f_Z3; plotfig = true)
title("Bessel插值法得到的基带信号");
