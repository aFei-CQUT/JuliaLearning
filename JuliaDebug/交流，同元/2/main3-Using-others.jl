using DSP
using FFTW
using Plots

# 设置中文字体（请确保您的系统中有这个字体，如果没有，请替换为您系统中可用的中文字体）
default(fontfamily="Microsoft YaHei", legendfontsize=10, guidefontsize=12, tickfontsize=10)

# 波形参数
N = 1024 * 8
N2 = N ÷ 2
N4 = N ÷ 4
N1 = 64
f0 = 60e6
B = 2e6
m = 8
fs = 4 * f0 / (2 * m - 1)
Ts = 1 / fs
tts = 0:Ts:((N+N1-1)*Ts)
quantize_en = 0

# 滤波器设计
Nf = 63
bb_lp = remez(Nf, [(0.0, 0.4) => 1, (0.6, 1.0) => 0], Hz=2)
bb_mp = DSP.kaiser(Nf + 1, 15)

if quantize_en == 0
    bb_lp = round.(Int, bb_lp .* 2^15 ./ maximum(abs.(bb_lp)))
    bb_mp = round.(Int, bb_mp .* 2^15 ./ maximum(abs.(bb_mp)))
end

# 绘制滤波器特性
w = range(0, π, length=1000)
h_lp = DSP.Filters.freqresp(DSP.PolynomialRatio(bb_lp, [1.0]), w)
plot(w ./ π, 20 * log10.(abs.(h_lp)), xlabel="归一化频率", ylabel="幅度 (dB)", title="Remez方法设计的低通滤波器的幅相特性")
display(plot!())

h_mp = DSP.Filters.freqresp(DSP.PolynomialRatio(bb_mp, [1.0]), w)
plot(w ./ π, 20 * log10.(abs.(h_mp)), xlabel="归一化频率", ylabel="幅度 (dB)", title="Kaiser窗设计的低通滤波器的幅相特性")
display(plot!())

b1 = bb_lp[1:2:end]
b2 = bb_lp[2:2:end]
b3 = bb_mp[3:4:end]
b4 = bb_mp[1:4:end]

# 模拟信号产生、符号变换
fd_val = 1.0e6
ss = 1000 .* cos.(2π * (f0 + fd_val) .* tts)

plot(tts[1:1000], ss[1:1000], xlabel="时间 (s)", ylabel="幅度", title="模拟输入信号")
display(plot!())

ii1 = ss[1:2:N+N1]
qq1 = ss[2:2:N+N1]

if iseven(m)
    sa = ss .* repeat([1, 1, -1, -1], outer=(N + N1) ÷ 4)
else
    sa = ss .* repeat([-1, 1, 1, -1], outer=(N + N1) ÷ 4)
end

ii1 = ii1 .* repeat([1, -1], outer=(N + N1) ÷ 4)
qq1 = qq1 .* repeat([1, -1], outer=(N + N1) ÷ 4)

# 低通滤波法
ii = filt(b2, [1.0], ii1)
qq = filt(b1, [1.0], qq1)
Z1 = ii[(N1÷2+1):((N+N1)÷2)] + im * qq[(N1÷2+1):((N+N1)÷2)]
Z1f = 20 * log10.(abs.(fftshift(fft(Z1))))
fff = (-N2÷2:N2÷2-1) * fs / N2 * 1e-6
plot(fff, Z1f, xlabel="频率 (MHz)", ylabel="幅度 (dB)", title="低通滤波法得到的基带信号")
display(plot!())

# 多相滤波法
ii = filt(b3, [1.0], ii1)
qq = filt(b4, [1.0], qq1)
Z2 = ii[(N1÷2+1):((N+N1)÷2)] + im * qq[(N1÷2+1):((N+N1)÷2)]
Z2f = 20 * log10.(abs.(fftshift(fft(Z2))))
plot(fff, Z2f, xlabel="频率 (MHz)", ylabel="幅度 (dB)", title="多相滤波法得到的基带信号")
display(plot!())

# Bessel插值法
W_Bessel = [-5, 49, -245, 1225, 1225, -245, 49, -5] ./ 2048
ii_bessel = sa[8:2:end]
qq1 = sa[1:2:end]
qq2 = filt(W_Bessel, [1.0], qq1)
qq_bessel = qq2[(1:N2).+7]
Z3 = qq_bessel[1:N2] + im * ii_bessel[1:N2]
Z3f = 20 * log10.(abs.(fftshift(fft(Z3))))
plot(fff, Z3f, xlabel="频率 (MHz)", ylabel="幅度 (dB)", title="Bessel插值法得到的基带信号")
display(plot!())
