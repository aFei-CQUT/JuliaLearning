using ControlSystems
using Plots

function create_system(T0, num)
    den = T0 * [1, 44.7, 502, 0]
    G = tf(num, den)
    return feedback(G)
end

function plot_rlocus(sys, subplot_index, title_str)
    r = rlocus(sys)
    real_parts = real.(r.roots)
    imag_parts = imag.(r.roots)
    scatter!(p[subplot_index], real_parts, imag_parts,
        label="", title=title_str, xlabel="Real", ylabel="Imaginary",
        markersize=2, color=:blue)
    plot!(p[subplot_index], [0], [0], seriestype=:vline, color=:black, label="")
    plot!(p[subplot_index], [0], [0], seriestype=:hline, color=:black, label="")
end

# 创建 2x2 子图
p = plot(layout=(2, 2), size=(800, 600))

# 定义系统参数
num = [3.1, 230]

# T0 = 10 的情况
sys10 = create_system(10, num)
plot_rlocus(sys10, 1, "sys10 Root Locus")

# T0 = 1 的情况
sys1 = create_system(1, num)
plot_rlocus(sys1, 2, "sys1 Root Locus")

# T0 = 0.1 的情况
sys01 = create_system(0.1, num)
plot_rlocus(sys01, 3, "sys01 Root Locus")

# T0 = 0.01 的情况
sys001 = create_system(0.01, num)
plot_rlocus(sys001, 4, "sys001 Root Locus")

# 显示图形
display(p)
