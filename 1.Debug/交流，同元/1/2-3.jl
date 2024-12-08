using TyMath
using TyBase
using TyPlot

function power_aperture(range, snr, sigma, tsc, az_angle, el_angle, NF, L)
    omega = az_angle * el_angle / (57.296^2)
    num1 = 10 * log10(4.0 * pi * 1.38e-23 * 290 * omega) + NF + L + snr
    num2 = sigma .+ 10 * log10(tsc)
    
    # 方法1：列表推导式
    PAP1 = [num1 .- num2[i] .+ 40 * log10.(range * 1000) for i in eachindex(sigma)]
    
    # 方法2：使用广播
    range_log = 40 .* log10.(range .* 1000)
    PAP2 = num1 .- num2 .+ range_log'
    
    # 方法3：使用矩阵进行广播运算
    range_reshape = reshape(range, 1, :)
    sigma_reshape = reshape(sigma, :, 1)
    PAP3 = num1 .- sigma_reshape .- 10 * log10(tsc) .+ 40 * log10.(range_reshape * 1000)
    
    # 方法4：使用循环
    PAP4 = zeros(length(sigma), length(range))
    for i in eachindex(sigma)
        for j in eachindex(range)
            PAP4[i,j] = num1 - num2[i] + 40 * log10(range[j] * 1000)
        end
    end
    
    # 画图
    figure()
    subplot(2,2,1)
    hold("on")
    grid("on")
    for i in eachindex(sigma)
        plot(range, PAP1[i])
    end
    title("方法1: 列表推导式")
    xlabel("探测距离/km")
    ylabel("功率孔径积/dB")

    subplot(2,2,2)
    hold("on")
    grid("on")
    for i in axes(PAP2, 1)
        plot(range, PAP2[i, :])
    end
    title("方法2: 使用广播")
    xlabel("探测距离/km")
    ylabel("功率孔径积/dB")

    subplot(2,2,3)
    hold("on")
    grid("on")
    for i in axes(PAP3, 1)
        plot(range, PAP3[i, :])
    end
    title("方法3: 使用矩阵进行广播运算")
    xlabel("探测距离/km")
    ylabel("功率孔径积/dB")

    subplot(2,2,4)
    hold("on")
    grid("on")
    for i in axes(PAP4, 1)
        plot(range, PAP4[i, :])
    end
    title("方法4: 使用循环")
    xlabel("探测距离/km")
    ylabel("功率孔径积/dB")
    
    return PAP1, PAP2, PAP3, PAP4
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

PAP1, PAP2, PAP3, PAP4 = power_aperture(range, snr, sigma, tsc, az_angle, el_angle, NF, L);
