using TySignalProcessing
using TyMath
using TyPlot

function xtg(N)
    # 参数设置
    Fs = 1000  # 采样频率
    T = 1 / Fs   # 采样间隔
    Tp = N * T   # 信号持续时间
    # 时间向量
    t = 0:T:(N-1)*T
    # 载波频率和调制频率
    fc = Fs / 10
    f0 = fc / 10
    # 产生调制信号和载波信号
    mt = cos.(2 * π * f0 .* t)  # 单频正弦波调制信号
    ct = cos.(2 * π * fc .* t)  # 载波信号
    # 生成调制信号
    xt = mt .* ct
    # 产生随机噪声，确保它是一维数组
    nt = 2 * rand(N) .- 1  # 生成一维随机噪声
    # 设计高通滤波器
    fp = 150.0  # 通带频率
    fs = 200.0  # 阻带频率
    Rp = 0.1    # 通带波动
    As = 70.0   # 阻带衰减
    # 计算remezord函数所需参数
    fb = [fp, fs]
    m = [0, 1]
    dev = [10^(-As / 20), (10^(Rp / 20) - 1) / (10^(Rp / 20) + 1)]
    n, fo, mo, W = firpmord(fb, m, dev, Fs)
    hn = firpm(n, fo, mo, W)
    # 应用高通滤波器
    yt = filter1(hn[1], 1, nt)  # 这里的nt是噪声信号
    xt = xt + yt[1]              # 噪声加信号
    # 计算频谱
    fst = fft(xt)
    k = 0:N-1
    f = k / Tp
    # 绘制信号和频谱
    subplot(3, 1, 1)
    plot(t, xt)
    xlabel("时间 (s)")
    ylabel("幅值")
    title("(a) 信号加噪声波形")
    xlim(0, Tp / 5)
    ylim(minimum(xt), maximum(xt))

    subplot(3, 1, 2)
    plot(f, abs.(fst) ./ maximum(abs.(fst)))
    xlabel("频率 (Hz)")
    ylabel("幅度")
    title("(b) 信号加噪声的频谱")
    xlim(0, Fs / 2)
    ylim(0, 1.2)
end

# 示例调用
xtg(1000)
tightlayout()