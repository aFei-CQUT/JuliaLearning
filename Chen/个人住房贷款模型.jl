using SymPy

# 使用 symbols 定义符号变量
A, t, n, r, y = symbols("A t n r y")

# 解析解公式
A_t_expr = (y / r) * (1 - ((1 + r)^t) / ((1 + r)^n))
display(A_t_expr)
