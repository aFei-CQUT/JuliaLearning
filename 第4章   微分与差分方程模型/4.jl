using SymPy
using Plots
plotlyjs()  # 使用 PlotlyJS 后端

# 定义符号变量
@syms i alpha t i0

# 定义符号函数i(t)表示患病人数比例
i = SymFunction("i")

# 解微分方程 di/dt = alpha * i * (1-i)，初始条件 i(0) = i0
i_eq = dsolve(Eq(diff(i(t), t) - alpha*i(t)*(1-i(t)), 0), i(t), ics=Dict(i(0) => i0))

# 打印方程的解
println("微分方程的解：")
println(i_eq)

# 简化解的表达式
i_eq_simplified = simplify(i_eq.rhs)
println("\n简化后的解：")
println(i_eq_simplified)

# 设置参数值
alpha_val = 0.5
i0_val = 0.01

# 定义函数来计算i(t)的值
i_func(t_val) = 1 / (1 - exp(-alpha_val * t_val) * (-1 + i0_val) / i0_val)

# 创建时间序列
t_values = 0:0.1:30

# 计算i(t)在不同时间点的值
i_values = [i_func(t) for t in t_values]

# 绘制i(t)的图像
p = Plots.plot(t_values, i_values, 
    label="患病人数比例", 
    xlabel="时间 t", 
    ylabel="患病人数比例 i", 
    title="患病人数比例i(t)随时间的变化",
    linewidth=2,
    legend=:topright
)

# 计算拐点（增长速度最大点）
t_inflection = log(1/i0_val - 1) / alpha_val
println("\n增长速度最大点: t ≈ ", t_inflection)

# 在图中标记拐点
i_inflection = i_func(t_inflection)
Plots.scatter!([t_inflection], [i_inflection], label="拐点", markersize=8, color=:red)
Plots.annotate!([(t_inflection, i_inflection, Plots.text("拐点", :red, :bottom))])

# 保存图像为HTML文件
Plots.savefig(p, "patient_proportion_plot.html")
