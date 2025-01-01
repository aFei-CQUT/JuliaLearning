using TyControlSystems: TyControlSystems, tf, feedback, rlocus
using TyPlot
using TyMath
using Base

# 定义初始参数
T0_values = [10, 1, 0.1, 0.01]
num = [3.1, 230]
G0 = tf([1], [1])  # 单位负反馈

# 创建一个数组来存储所有系统
systems = Array{TyControlSystems.TransferFunction}(undef, length(T0_values))

# 创建所有系统
for (i, T0) in enumerate(T0_values)
    den = T0 * [1, 44.7, 502, 0]
    G = tf(num, den)
    systems[i] = feedback(G, G0)
end

# 创建 2x2 布局的子图
for (i, sys) in enumerate(systems)
    subplot(2, 2, i)
    
    # 获取根轨迹数据
    r, k = rlocus(sys; fig=false)
    
    # 绘制根轨迹
    plot(real.(r), imag.(r), "b", linewidth=1.5)
    plot(real.(r[1,:]), imag.(r[1,:]), "rx", markersize=10)  # 起始点
    plot(real.(r[end,:]), imag.(r[end,:]), "ro", markersize=10)  # 终止点

    # 坐标轴范围
    xlim(-10, 20)
    ylim(-300, 300)
    
    # 设置图形属性
    title("T0 = $(T0_values[i]) Root Locus")
    xlabel("Real")
    ylabel("Imaginary")
end

# 调整子图之间的间距
tightlayout()