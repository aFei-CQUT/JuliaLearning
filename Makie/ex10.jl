using DataFrames, CairoMakie, AlgebraOfGraphics

# 创建数据框
dline01 = DataFrame(
    x=1:5,
    y=[11, 13, 18, 15, 14]
)

# 创建基础图形映射
pv1 = data(dline01) * mapping(:x, :y)

# 绘制散点图
fig1 = Figure(title="散点图")
ax1 = fig1[1, 1] = Axis(fig1, width=300, height=300)
draw!(ax1, pv1 * visual(Scatter, color=:blue))
display(fig1)  # 显示第一个图形

# 绘制折线图
fig2 = Figure(title="折线图")
ax2 = fig2[1, 1] = Axis(fig2, width=300, height=300)
draw!(ax2, pv1 * visual(Lines, color=:red))
display(fig2)  # 显示第二个图形

# 绘制散点连线图
fig3 = Figure(title="散点连线图")
ax3 = fig3[1, 1] = Axis(fig3, width=300, height=300)
draw!(ax3, pv1 * visual(ScatterLines, color=:green))
display(fig3)  # 显示第三个图形
