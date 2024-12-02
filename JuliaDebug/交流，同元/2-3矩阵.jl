# method3.jl
using TyBase
using TyMath
using TyPlot

function power_aperture_method3(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
    omega = az_angle * el_angle / (57.296^2)
    num1 = 10 * log10(4.0 * pi * 1.38e-23 * 290 * omega) + NF + L + snr
    num2 = sigma .+ 10 * log10(tsc)
    
    range_reshape = reshape(range, 1, :)
    sigma_reshape = reshape(num2, :, 1)  # 将 num2 重新整形为列向量
    
    # 计算 PAP3，结合 num1 和 sigma_reshape
    PAP3 = num1 .- sigma_reshape .+ 40 * log10.(range_reshape * 1000)
    
    # 画图
    figure()
    hold("on")
    grid("on")

    for i in axes(PAP3, 1)
        plot(range, PAP3[i, :])
    end

    title("方法3: 使用矩阵进行广播运算")
    xlabel("探测距离/km")
    ylabel("功率孔径积/dB")

    return PAP3
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

PAP3 = power_aperture_method3(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
