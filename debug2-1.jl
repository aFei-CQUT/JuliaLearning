using TyMath, TyPlot

function zuzhi(y, t)
    z = size(y)
    if z[1] > z[2]
        y = y'
    end
    z1 = maximum(z)
    y1 = zeros(1, z1 - 1)  # 初始化 y1
    for i in 1:(z1-1)
        y1[i] = (y[i + 1] - y[i]) / y[i]
    end
    p = polyfit(y[1:(z1-1)], y1, 1)  # 线性拟合
    p1 = abs(p[2] / p[1])
    Ym = p1
    Y = zeros(1, z1-1)  # 初始化 Y
    dY = zeros(1, z1 - 1)  # 初始化 dY
    for k in 1:(z1-1)
        if k == 1
            Y[k] = y[1]
        end
        dY[k] = p[2] * Y[k] * (1 - Y[k] / Ym)
        Y[k + 1] = Y[k] + dY[k]
    end
    plot(t, Y, label="预测", marker=:dot, color=:blue)
    plot!(t, y, label="实际", color=:red)
    xlabel!("年份")
    ylabel!("人口")
    legend!()
end
y = [1.0, 2.0, 4.0, 8.0, 16.0]  # 示例人口数据
t = [2000, 2001, 2002, 2003, 2004]  # 示例年份

# 调用函数
zuzhi(y, t)