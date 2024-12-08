using SymPy
using Plots
plotlyjs()  # 使用 PlotlyJS 后端

# 定义符号变量t（时间）
@syms t

# 定义符号函数m(t)和x(t)，分别表示胃肠道和血液中的酒精含量
m = SymFunction("m")
x = SymFunction("x")

# 求解胃肠道中酒精含量的微分方程
m_eq = dsolve(Eq(diff(m(t), t) + 0.1851*m(t), 0), m(t), ics=Dict(m(0) => 737.7661))
@show m_eq

# 求解血液中酒精含量的微分方程
x_eq = dsolve(Eq(diff(x(t), t) - 136.5605*exp(-0.1851*t) + 1.9801*x(t), 0), x(t), ics=Dict(x(0) => 18.8486))
@show x_eq

# 创建时间序列
t_values = 0:0.1:24  # 0到24小时，步长0.1

# 定义数值计算函数
function numeric_eval(expr, t_val)
    return N(expr.subs(t, t_val))
end

# 计算m和x在不同时间点的值
m_values = [Float64(numeric_eval(m_eq.rhs, tv)) for tv in t_values]
x_values = [Float64(numeric_eval(x_eq.rhs, tv)) for tv in t_values]

# 绘制胃肠道酒精含量图
p1 = Plots.plot(t_values, m_values, 
    label="胃肠道酒精含量", 
    xlabel="时间 (小时)", 
    ylabel="酒精含量", 
    title="胃肠道酒精含量随时间变化",
    linewidth=2,
    legend=:topright
)

# 绘制血液酒精含量图
p2 = Plots.plot(t_values, x_values, 
    label="血液酒精含量", 
    xlabel="时间 (小时)", 
    ylabel="酒精含量", 
    title="血液酒精含量随时间变化",
    linewidth=2,
    legend=:topright
)

# 绘制组合图
p3 = Plots.plot(t_values, m_values, 
    label="胃肠道酒精含量", 
    xlabel="时间 (小时)", 
    ylabel="酒精含量", 
    title="酒精含量随时间变化",
    linewidth=2,
    legend=:topright
)
Plots.plot!(p3, t_values, x_values, 
    label="血液酒精含量",
    linewidth=2
)

# 保存图像为HTML文件
Plots.savefig(p1, "gastric_alcohol_content_plot.html")
Plots.savefig(p2, "blood_alcohol_content_plot.html")
Plots.savefig(p3, "combined_alcohol_content_plot.html")
