using SymPy
using Plots
plotlyjs()  # 使用 PlotlyJS 后端

# 定义符号变量
@syms i alpha t i0

# 定义符号函数i(t)表示患病人数比例
i = SymFunction("i")

# 解微分方程 di/dt = alpha * i * (1-i)，初始条件 i(0) = i0
i_eq = dsolve(Eq(diff(i(t), t) - alpha*i(t)*(1-i(t)), 0), i(t), ics=Dict(i(0) => i0))
println("微分方程的解：")
println(i_eq)

# 定义函数myfun1(x)，对应MATLAB中的myfun1.m文件
myfun1(x) = 0.01 * x * (1 - x)

# 绘制myfun1函数图像
p1 = Plots.plot(myfun1, 0, 1, 
    label="myfun1(x)", 
    xlabel="x 值", 
    ylabel="y 值", 
    title="函数 myfun1(x) = 0.01x(1-x) 的图像",
    linewidth=2,
    legend=:topright)

# 保存myfun1的图像
Plots.savefig(p1, "myfun1_plot.html")

# 设置参数值
alpha_val = 0.5
i0_val = 0.01

# 创建函数来计算i(t)的值
i_func(t_val) = float(i_eq.rhs.subs([(alpha, alpha_val), (i0, i0_val), (t, t_val)]))

# 创建时间序列
t_values = 0:0.1:30

# 计算i(t)在不同时间点的值
i_values = [i_func(t) for t in t_values]

# 绘制i(t)的图像
p2 = Plots.plot(t_values, i_values, 
    label="i(t)", 
    xlabel="时间 t", 
    ylabel="患病人数比例 i", 
    title="患病人数比例 i(t) 随时间的变化",
    linewidth=2,
    legend=:bottomright)

# 保存i(t)的图像
Plots.savefig(p2, "i_t_plot.html")
