using TyMath
using TyBase
using TyPlot

function hprf_req(pt, freq, G, sigma, ti, range, NF, L, dt)
    c = 3.0e+8
    lamda = c / freq

    num1_inside = pt * 1000.0 * lamda^2 * sigma * ti .* dt
    num1 = 10 .* log10.(num1_inside) .+ 2 .* G

    num2_inside = log10.((4.0 * pi)^3 * 1.38e-23 * 290) .+ 4 .* log10.(range .* 1000)
    num2 = 10 .* num2_inside .+ NF .+ L
    
    # 方法1：使用广播
    snr1 = num1 .* ones(1, length(range)) .- ones(length(dt), 1) .* num2'

    # 方法2：使用循环
    snr2 = zeros(length(dt), length(range))
    for i in 1:length(dt)
        for j in 1:length(range)
            snr2[i, j] = num1[i] - num2[j]
        end
    end

    # 方法3：使用网格进行广播运算
    num1_grid = reshape(num1, :, 1)  # 将 num1 转换为列向量
    num2_grid = reshape(num2, 1, :)  # 将 num2 转换为行向量
    snr3 = num1_grid .- num2_grid    # 广播减法操作

    # 方法4：列表推导式
    snr4 = [num1[i] .- num2 for i in 1:length(dt)]

    # 画图
    figure()
    subplot(2,2,1)
    hold("on")
    grid("on")
    plot(range, snr1')
    title("方法1: 使用广播")
    xlabel("距离/km")
    ylabel("SNR/dB")

    subplot(2,2,2)
    hold("on")
    grid("on")
    plot(range, snr2')
    title("方法2: 使用循环")
    xlabel("距离/km")
    ylabel("SNR/dB")

    subplot(2,2,3)
    hold("on")
    grid("on")
    plot(range, snr3')
    title("方法3: 使用网格进行广播运算")
    xlabel("距离/km")
    ylabel("SNR/dB")

    subplot(2,2,4)
    hold("on")
    grid("on")
    for i in 1:length(dt)
        plot(range, snr4[i])
    end
    title("方法4: 列表推导式")
    xlabel("距离/km")
    ylabel("SNR/dB")

    return snr1, snr2, snr3, snr4
end

# 主程序部分
pt = 100
freq = 5.6e9
G = 20
sigma = 0.01
ti = 2
L = 6
NF = 4
range = [10:1:100;]
dt = [0.3, 0.2, 0.1]

snr1, snr2, snr3, snr4 = hprf_req(pt, freq, G, sigma, ti, range, NF, L, dt);
