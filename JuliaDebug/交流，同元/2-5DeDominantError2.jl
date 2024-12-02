using TyMath
using TyBase
using TyPlot

function hprf_req(pt, freq, G, sigma, ti, range, NF, L, dt)
    c = 3.0e+8
    lamda = c / freq

    # 计算 num1，使用对数加法避免溢出
    log_num1_inside = log10(pt) + log10(1000.0) + 2*log10(lamda) + log10(sigma) + log10(ti) .+ log10.(dt)
    num1 = 10 .* log_num1_inside .+ 2 .* G

    # 计算 num2，使用对数加法避免溢出
    log_num2_inside = log10((4.0 * pi)^3) + log10(1.38e-23) + log10(290) .+ 4 .* log10.(range .* 1000)
    num2 = 10 .* log_num2_inside .+ NF .+ L
    
    # 使用广播操作来计算 snr
    snr = num1 .- num2'

    # 画图
    plot(range, snr')
    xlabel("距离/km")
    ylabel("SNR/dB")
    grid("on")
    
    return snr
end

# 主程序
pt = 100
freq = 5.6e9
G = 20
sigma = 0.01
ti = 2
L = 6
NF = 4
range = [10:1:100;]
dt = [0.3, 0.2, 0.1]

snr = hprf_req(pt, freq, G, sigma, ti, range, NF, L, dt)
