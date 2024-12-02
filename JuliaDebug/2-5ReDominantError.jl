using TyMath
using TyBase
using TyPlot

function hprf_req(pt, freq, G, sigma, ti, range, NF, L, dt)
    c = 3.0e+8
    lamda = c / freq
    
    # 使用元素级操作符 .* 和 .+ 来避免维度不匹配的问题
    num1 = 10 .* log10.(pt * 1000.0 * lamda^2 * sigma * ti .* dt) .+ 2 .* G
    num2 = 10 .* log10.((4.0 * pi)^3 * 1.38e-23 * 290 .* (range .* 1000).^4) .+ NF .+ L
    
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
