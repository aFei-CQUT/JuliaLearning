using SymPy
using Plots
plotlyjs()  # 使用 PlotlyJS 后端
# using PlotlyJS 和 plotlyjs() 第一次在环境中运行会出错，这属于 Julia-1.11.1 版本的一个错误，可以在 startup.jl 下预先加载再使用 plotlyjs() 防止报错

# 定义符号变量t（时间）
@syms t

# 定义符号函数m(t)和x(t)，分别表示胃肠道和血液中的酒精含量
m = SymFunction("m")
x = SymFunction("x")

# 求解胃肠道中酒精含量的微分方程
m_eq = dsolve(Eq(diff(m(t), t) + 0.1851*m(t), 0), m(t), ics=Dict(m(0) => 737.7661))
@show m_eq

# 求解血液中酒精含量的微分方程
x_eq = dsolve(Eq(diff(x(t), t) - 130.5155*exp(-0.1950*t) + 1.8537*x(t), 0), x(t), ics=Dict(x(0) => 18.6360))
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

# 绘制图形
p = Plots.plot(t_values, m_values, 
    label="胃肠道酒精含量", 
    xlabel="时间 (小时)", 
    ylabel="酒精含量", 
    title="酒精含量随时间变化",
    linewidth=2,
    legend=:topright
)
Plots.plot!(p, t_values, x_values, 
    label="血液酒精含量",
    linewidth=2
)

# 保存图像为HTML文件
Plots.savefig(p, "alcohol_content_plot.html")
