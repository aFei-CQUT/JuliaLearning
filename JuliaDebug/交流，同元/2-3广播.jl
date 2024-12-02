# method2.jl
using TyBase
using TyMath
using TyPlot

function power_aperture_method2(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
    omega = az_angle * el_angle / (57.296^2)
    num1 = 10 * log10(4.0 * pi * 1.38e-23 * 290 * omega) + NF + L + snr
    num2 = sigma .+ 10 * log10(tsc)

    range_log = 40 .* log10.(range .* 1000)
    PAP2 = num1 .- num2 .+ range_log'

    # 画图
    figure()
    hold("on")
    grid("on")

    for i in axes(PAP2, 1)
        plot(range, PAP2[i, :])
    end
    
    title("方法2: 使用广播")
    xlabel("探测距离/km")
    ylabel("功率孔径积/dB")

    return PAP2
end

# 主程序
range = [20:1:250;]
sigma = [-20, -10, 0]
tsc = 2
az_angle = 180
el_angle = 135
L = 6
NF = 8
snr = 20

PAP2 = power_aperture_method2(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
