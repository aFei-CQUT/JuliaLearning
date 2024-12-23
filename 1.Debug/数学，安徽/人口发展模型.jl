using SymPy

# 定义符号变量
@vars r t x
@vars μ(r) p0(r) f(t)

# 定义分段函数
function p(r, t)
    cond = t <= r
    return Piecewise(
        (p0(r-t) * exp(-integrate(μ(x), (x, r-t, r))), cond),
        (f(t-r) * exp(-integrate(μ(x), (x, 0, r))), true)
    )
end

# 打印解析解
println("人口密度函数 p(r,t) 的解析解为:")
println(p(r, t))

# 计算特定情况下的解
μ_specific(r) = 0.01 * r  # 假设相对死亡率为年龄的线性函数
p0_specific(r) = 1000 * exp(-0.05 * r)  # 假设初始人口密度为指数分布
f_specific(t) = 5000 * (1 + sin(0.1 * t))  # 假设出生率为周期性函数

p_specific = p(r, t).subs(μ(r), μ_specific(r)).subs(p0(r), p0_specific(r)).subs(f(t), f_specific(t))

println("\n特定情况下的人口密度函数 p(r,t) 为:")
println(p_specific)
