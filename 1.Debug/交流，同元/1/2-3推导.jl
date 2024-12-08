# method1.jl
using TyBase
using TyMath
using TyPlot

function power_aperture_method1(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
    omega = az_angle * el_angle / (57.296^2)
    num1 = 10 * log10(4.0 * pi * 1.38e-23 * 290 * omega) + NF + L + snr
    num2 = sigma .+ 10 * log10(tsc)

    PAP1 = [num1 .- num2[i] .+ 40 * log10.(range * 1000) for i in eachindex(sigma)]

    # 画图
    figure()
    hold("on")
    grid("on")

    for i in eachindex(sigma)
        plot(range, PAP1[i])
    end
    
    title("方法1: 列表推导式")
    xlabel("探测距离/km")
    ylabel("功率孔径积/dB")

    return PAP1
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

PAP1 = power_aperture_method1(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
