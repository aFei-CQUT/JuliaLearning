using DifferentialEquations
using Plots
plotlyjs() # 使用 PlotlyJS 后端

# 定义 SIR 模型的微分方程
function sir!(du, u, p, t)
    s, i, r = u
    α, β = p
    du[1] = -α * s * i         # ds/dt: 易感人群变化率
    du[2] = α * s * i - β * i  # di/dt: 感染人群变化率
    du[3] = β * i              # dr/dt: 康复人群变化率
end

# 设置模型参数
α, β = 1.0, 0.3  # α: 感染率, β: 康复率
p = [α, β]

# 设置初始条件
s0, i0, r0 = 0.98, 0.02, 0.0  # 初始易感人群、感染人群和康复人群比例
u0 = [s0, i0, r0]

# 设置时间跨度
tspan = (0.0, 50.0)

# 定义 ODE 问题
prob = ODEProblem(sir!, u0, tspan, p)

# 求解 ODE 问题
sol = solve(prob)

# 绘制时间序列图
p1 = Plots.plot(sol, idxs=[1,2,3], label=["Susceptible" "Infected" "Recovered"], 
                title="SIR Model Time Series", xlabel="Time", ylabel="Population Ratio",
                size=(800, 500))
Plots.annotate!(p1, [(25, 0.6, "S: Susceptible"), (25, 0.3, "I: Infected"), (25, 0.1, "R: Recovered")])

# 保存时间序列图为 HTML 格式
Plots.savefig(p1, "sir_model_time_series.html")

# 绘制相图
p2 = Plots.plot(sol, idxs=(1,2), label="Phase Trajectory", 
                title="SIR Model Phase Plot", xlabel="Susceptible", ylabel="Infected",
                size=(800, 500))
Plots.annotate!(p2, [(0.5, 0.15, "Direction of time")])
Plots.quiver!(p2, [0.5], [0.15], quiver=([0.1], [0]), color=:black)

# 保存相图为 HTML 格式
Plots.savefig(p2, "sir_model_phase_plot.html")
