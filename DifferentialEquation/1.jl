using SymPy  # 导入SymPy符号计算库

# 定义符号变量
@syms t k1 c  # 定义符号变量t(时间)、k1(代谢率常数)和c(初始酒精含量)

m = SymFunction("m")  # 定义符号函数m(t)表示体内酒精含量

# 建立微分方程
eq = Eq(diff(m(t), t) + k1*m(t), 0)  # dm/dt + k1*m = 0

# 求解微分方程,设定初始条件m(0) = c
sol = dsolve(eq, m(t), ics=Dict(m(0) => c))

@show sol # 显示解
