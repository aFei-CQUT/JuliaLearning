using TyMath
using TyBase
using TyPlot

function hprf_req(pt, freq, G, sigma, ti, range, NF, L, dt)
    c = 3.0e+8
    lamda = c / freq
    
    # 使用对数加法来避免溢出
    log_pt = log10(pt * 1000.0)
    log_lamda = 2 * log10(lamda)
    log_sigma = log10(sigma)
    log_ti = log10(ti)
    log_dt = log10.(dt)
    
    num1 = 10 .* (log_pt .+ log_lamda .+ log_sigma .+ log_ti .+ log_dt) .+ 2 .* G
    
    log_range = 4 .* log10.(range .* 1000)
    log_const = log10((4.0 * pi)^3 * 1.38e-23 * 290)
    
    num2 = 10 .* (log_const .+ log_range) .+ NF .+ L
    
    # 使用广播操作来计算 snr
    snr = num1 .- num2'
    
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
