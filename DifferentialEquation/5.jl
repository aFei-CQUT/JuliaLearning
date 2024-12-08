using SymPy  # 导入SymPy符号计算库

# 定义符号变量
@syms t alpha sigma i0  # 定义符号变量

i = SymFunction("i")  # 定义符号函数i(t)表示感染率

# 建立微分方程
eq = Eq(diff(i(t), t), -alpha * i(t) * (i(t) - (1 - 1/sigma)))

# 求解微分方程,设定初始条件i(0) = i0
sol = dsolve(eq, i(t), ics=Dict(i(0) => i0))

# 显示解
@show sol

# 简化解（可选）
simplified_sol = simplify(rhs(sol))
println("\n简化后的解：")
println(simplified_sol)
