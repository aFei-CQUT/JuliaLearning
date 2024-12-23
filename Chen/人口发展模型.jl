using SymPy

function solve_pde(eq, p, r, t, initial_condition, boundary_condition)
    try
        # 尝试使用 dsolve
        solution = dsolve(eq, p)
        return solution
    catch e
        println("dsolve failed. Attempting other methods...")
    end

    try
        # 尝试使用分离变量法
        println("Attempting to solve using separation of variables...")
        # 假设解的形式为 p(r,t) = R(r) * T(t)
        R = SymFunction("R")(r)
        T = SymFunction("T")(t)
        @syms lambda C1 C2

        separated_eq = eq.subs(p, R * T)
        r_eq = Eq(diff(R, r) / R, -lambda - μ)
        t_eq = Eq(diff(T, t) / T, -lambda)

        r_sol = dsolve(r_eq, R)
        t_sol = dsolve(t_eq, T)

        # 应用初始条件和边界条件
        general_solution = r_sol.rhs * t_sol.rhs

        # 应用初始条件
        init_cond = Eq(general_solution.subs(t, 0), p0(r))
        C1_sol = solve(init_cond, C1)

        # 应用边界条件
        bound_cond = Eq(general_solution.subs(r, 0), f(t))
        C2_sol = solve(bound_cond, C2)

        # 代入求解得到的常数
        final_solution = general_solution.subs(C1, C1_sol[1]).subs(C2, C2_sol[1])

        return Eq(p, final_solution)
    catch e
        println("Separation of variables failed. Attempting method of characteristics...")
    end

    # 使用特征线法
    μ = eq.rhs / (-p)  # 从方程中提取 μ(r)

    @syms x

    # 构造分段解
    solution = sympy.Piecewise(
        (initial_condition.rhs.subs(r, r - t) * exp(-integrate(μ.subs(r, x), (x, r - t, r))), sympy.Gt(r, t)),
        (boundary_condition.rhs.subs(t, t - r) * exp(-integrate(μ.subs(r, x), (x, 0, r))), true)
    )

    return Eq(p, solution)
end

# 定义符号和方程
@syms r t x
p = SymFunction("p")(r, t)
μ = SymFunction("μ")(r)
p0 = SymFunction("p0")(r)
f = SymFunction("f")(t)

eq = Eq(diff(p, r) + diff(p, t), -μ * p)
initial_condition = Eq(p.subs(t, 0), p0(r))
boundary_condition = Eq(p.subs(r, 0), f(t))

# 求解 PDE
solution = solve_pde(eq, p, r, t, initial_condition, boundary_condition)

println("Solution:")
println(solution)

# 解释解
println("\nExplanation of the solution:")
if solution.lhs == p
    println("The solution is obtained using separation of variables or method of characteristics.")
    println(solution)
else
    println("When r > t:")
    println("p(r, t) = p0(r - t) * exp(-∫μ(x)dx from r-t to r)")
    println("\nWhen r ≤ t:")
    println("p(r, t) = f(t - r) * exp(-∫μ(x)dx from 0 to r)")
end
