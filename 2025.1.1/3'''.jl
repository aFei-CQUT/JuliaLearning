using TyControlSystems: TyControlSystems, tf, feedback, rlocus
using TyPlot
using TyMath
using Base

function create_system(T0, num)
    den = T0 * [1, 44.7, 502, 0]
    G = tf(num, den)
    return feedback(G)
end

function safe_extrema(arr)
    filtered = filter(x -> !isnan(x) && !isinf(x), arr)
    if isempty(filtered)
        return (0.0, 1.0)  # 默认范围
    else
        return extrema(filtered)
    end
end

function plot_rlocus(sys, subplot_index, title_str)
    r, k = rlocus(sys; fig=false)
    
    subplot(2, 2, subplot_index)
    hold("on")
    
    for i in 1:size(r, 2)
        real_parts = real.(r[:, i])
        imag_parts = imag.(r[:, i])
        plot(real_parts, imag_parts, "b-", linewidth=1)
    end
    
    # 绘制起始点和终止点
    plot(real.(r[1, :]), imag.(r[1, :]), "rx", markersize=8)
    plot(real.(r[end, :]), imag.(r[end, :]), "ro", markersize=8)
    
    # 绘制虚轴和实轴
    xline(0, color="k", linewidth=0.5)
    yline(0, color="k", linewidth=0.5)
    
    title(title_str)
    xlabel("Real")
    ylabel("Imaginary")

    # 动态设置坐标轴范围
    x_min, x_max = safe_extrema(real.(r))
    y_min, y_max = safe_extrema(imag.(r))
    margin = 0.1  # 10% 的边距
    x_range = x_max - x_min
    y_range = y_max - y_min
    
    if x_range > 0 && y_range > 0
        try
            xlim(x_min - margin * x_range, x_max + margin * x_range)
            ylim(y_min - margin * y_range, y_max + margin * y_range)
        catch e
            println("Warning: Could not set axis limits. Using default.")
        end
    else
        println("Warning: Invalid data range. Using default axis limits.")
    end

    grid(true)
    hold("off")
end

# 定义系统参数
num = [3.1, 230]
T0_values = [10, 1, 0.1, 0.01]

# 创建图形
figure(figsize=(12, 9))

# 绘制每个系统的根轨迹
for (i, T0) in enumerate(T0_values)
    sys = create_system(T0, num)
    plot_rlocus(sys, i, "T0 = $T0 Root Locus")
end

# 调整子图之间的间距
tightlayout()

# 显示图形
gcf();
