# 导入必要的包
using DifferentialEquations  # 用于解微分方程
using Plots                  # 用于绘图
plotlyjs()                   # 使用 PlotlyJS 后端进行绘图

# 定义微分方程系统
function xt!(du, u, p, t)
    # 设定模型参数
    p1, p2, r1, r2, N1, N2 = 0.5, 0.6, 2.5, 1.8, 1.6, 1.0
    # 种群 1 的微分方程
    du[1] = r1 * u[1] * (1 - u[1]/N1 - p1*u[2]/N2)
    # 种群 2 的微分方程
    du[2] = r2 * u[2] * (1 - u[2]/N2 - p2*u[1]/N1)
end

# 设定时间跨度
tspan = (0.0, 10.0)

# 设定第一组初始条件 [0.1, 0.1] 并求解
prob1 = ODEProblem(xt!, [0.1, 0.1], tspan)
sol1 = solve(prob1)

# 设定第二组初始条件 [1.0, 2.0] 并求解
prob2 = ODEProblem(xt!, [1.0, 2.0], tspan)
sol2 = solve(prob2)

# 绘制第一个初始条件的时间序列图
p1 = Plots.plot(sol1, idxs=(0,[1,2]), title="Initial: [0.1, 0.1]", 
                xlabel="t", ylabel="Population", label=["x(t)" "y(t)"])
Plots.savefig(p1, "time_series_1.html")  # 保存图形为HTML文件

# 绘制第二个初始条件的时间序列图
p2 = Plots.plot(sol2, idxs=(0,[1,2]), title="Initial: [1.0, 2.0]", 
                xlabel="t", ylabel="Population", label=["x(t)" "y(t)"])
Plots.savefig(p2, "time_series_2.html")  # 保存图形为HTML文件

# 绘制相轨线图
p3 = Plots.plot(sol1, idxs=(1,2), label="Initial: [0.1, 0.1]", xlabel="x", ylabel="y")
Plots.plot!(p3, sol2, idxs=(1,2), label="Initial: [1.0, 2.0]")
# 在相轨线图上标记起始点
Plots.scatter!(p3, [0.1], [0.1], label="Start [0.1, 0.1]", marker=:diamond)
Plots.scatter!(p3, [1.0], [2.0], label="Start [1.0, 2.0]", marker=:circle)
Plots.title!(p3, "甲乙种群相轨线")
Plots.savefig(p3, "phase_portrait_for_7.html")  # 保存图形为HTML文件
