# method4.jl
using TyBase
using TyMath
using TyPlot

function power_aperture_method4(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
    omega = az_angle * el_angle / (57.296^2)
    num1 = 10 * log10(4.0 * pi * 1.38e-23 * 290 * omega) + NF + L + snr
    num2 = sigma .+ 10 * log10(tsc)
    
    PAP4 = zeros(length(sigma), length(range))
    
    for i in eachindex(sigma)
        for j in eachindex(range)
            PAP4[i,j] = num1 - num2[i] + 40 * log10(range[j] * 1000)
        end
    end

    # 画图
    figure()
    hold("on")
    grid("on")

    for i in axes(PAP4, 1)
        plot(range, PAP4[i, :])
    end

    title("方法4: 使用循环")
    xlabel("探测距离/km")
    ylabel("功率孔径积/dB")

    return PAP4
end

# 主程序
range = collect(20:1:250)
sigma = [-20, -10, 0]
tsc = 2
az_angle = 180
el_angle = 135
L = 6
NF = 8
snr = 20

PAP4 = power_aperture_method4(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
