using DifferentialEquations  # 用于解微分方程
using Plots                  # 用于绘图
Plots.plotlyjs()             # 使用 PlotlyJS 后端进行绘图

# 定义微分方程系统
function zhuiqiu!(du, u, p, t)
    a, b, r = 0.5, 0.1, 0.3  # 设定参数值
    du[1] = (a - b*u[2]) * u[1]   # x 的微分方程
    du[2] = (-r + b*u[1]) * u[2]  # y 的微分方程
end

# 设定时间跨度和初始条件
tspan = (0.0, 50.0)  # 时间范围从 0 到 50
x0 = [5.0, 2.0]      # 初始条件 [x(0), y(0)]

# 创建并求解微分方程问题
prob = ODEProblem(zhuiqiu!, x0, tspan)
sol = solve(prob)

# 绘制时间序列图
p1 = Plots.plot(sol, idxs=(0,[1,2]), 
                xlabel="t", ylabel="Population", 
                label=["x(t)" "y(t)"], 
                title="Time Series", 
                grid=true)

# 保存时间序列图为 HTML 文件
Plots.savefig(p1, "time_series.html")

# 绘制相轨线图
p2 = Plots.plot(sol, idxs=(1,2), 
                xlabel="x", ylabel="y", 
                label="Phase Portrait", 
                title="Phase Portrait", 
                grid=true)

# 在相轨线图上标记起始点
Plots.scatter!(p2, [x0[1]], [x0[2]], label="Start", marker=:circle)

# 保存相轨线图为 HTML 文件
Plots.savefig(p2, "phase_portrait.html")
