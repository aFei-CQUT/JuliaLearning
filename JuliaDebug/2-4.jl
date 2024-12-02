using TyMath
using TyBase
using TyPlot

function lprf_req(pt, freq, G, sigma, tao, NF, L, range, np)
    c = 3.0e+8
    lamda = c / freq
    num1 = 10 * log10(pt * 1.0e3 * tao * lamda^2 * sigma) + 2 * G
    num2 = 10 * log10((4.0 * pi)^3 * 1.38e-23 * 290) + NF + L
    range_db = 40 * log10.(range * 1000.0)
    
    # 方法1：列表推导式
    snr1 = [num1 .+ 10 * log10(np[i]) .- num2 .- range_db for i in eachindex(np)]
    
    # 方法2：使用广播
    np_log = 10 .* log10.(np)
    snr2 = num1 .+ np_log .- num2 .- range_db'
    
    # 方法3：使用网格进行广播运算
    np_grid = reshape(np, :, 1)
    range_grid = reshape(range, 1, :)
    snr3 = num1 .+ 10 * log10.(np_grid) .- num2 .- 40 * log10.(range_grid * 1000.0)
    
    # 方法4：使用循环
    snr4 = zeros(length(np), length(range))
    for i in eachindex(np)
        for j in eachindex(range)
            snr4[i,j] = num1 + 10 * log10(np[i]) - num2 - range_db[j]
        end
    end
    
    # 画图
    figure()
    subplot(2,2,1)
    hold("on")
    grid("on")
    for i in eachindex(np)
        plot(range, snr1[i])
    end
    title("方法1: 列表推导式")
    xlabel("距离/km")
    ylabel("SNR/dB")

    subplot(2,2,2)
    hold("on")
    grid("on")
    for i in axes(snr2, 1)
        plot(range, snr2[i,:])
    end
    title("方法2: 使用广播")
    xlabel("距离/km")
    ylabel("SNR/dB")

    subplot(2,2,3)
    hold("on")
    grid("on")
    for i in axes(snr3, 1)
        plot(range, snr3[i,:])
    end
    title("方法3: 使用网格进行广播运算")
    xlabel("距离/km")
    ylabel("SNR/dB")

    subplot(2,2,4)
    hold("on")
    grid("on")
    for i in axes(snr4, 1)
        plot(range, snr4[i,:])
    end
    title("方法4: 使用循环")
    xlabel("距离/km")
    ylabel("SNR/dB")
    
    return snr1, snr2, snr3, snr4
end

# 主程序
pt = 1.500
freq = 5.6e9
G = 45
sigma = 0.1
Te = 100e-6
b = 1/Te
L = 6
NF = 3
range = [25:5:300;] 
np = [1, 10, 100]

snr1, snr2, snr3, snr4 = lprf_req(pt, freq, G, sigma, Te, NF, L, range, np);
