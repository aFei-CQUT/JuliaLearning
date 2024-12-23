using SymPy

# 使用 @syms 宏定义符号变量
@syms α β γ δ Pₜ Pₜ₋₁

# 定义方程组
# 第一个方程： Q_t^d = α - β * Pₜ
Qd = α - β * Pₜ

# 第二个方程： Q_t^s = -δ + γ * P(t-1)
Qs = -δ + γ * Pₜ₋₁

# 将 Q_t^d = Q_t^s 代入
equation = Eq(Qd, Qs)

# 输出推导出的方程
println("从方程组推导出的结果是： ", equation)

# 定义方程：α - β * Pₜ = -δ + γ * P_{t-1}
eq = α - β * Pₜ - (-δ + γ * Pₜ₋₁)

# 求解 Pₜ
Pₜ_solution = solve(eq, Pₜ)