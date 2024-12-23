using SymPy

# 定义符号变量
A, t, n, r, y = symbols("A t n r y")

# 等额本金还款模型
# 计算第t期应还款金额
y_t_expr = (A / n) + (A - (t - 1) / n * A) * r

# 等额本息还款模型
# 计算第t期尚欠银行的贷款额
A_t_expr = (y / r) * (1 - ((1 + r)^t) / ((1 + r)^n))

# 打印解析解
println("等额本金还款模型第t期应还款金额: ")
println(y_t_expr)
println("\n等额本息还款模型第t期尚欠银行的贷款额: ")
println(A_t_expr)
