using JuMP
using GLPK

# 定义核心解的约束条件
function core_constraints(model, x)
    @constraint(model, sum(x) == 1)
    @constraint(model, x[1] + x[2] >= 2 / 3)
    @constraint(model, x[1] + x[3] >= 7 / 12)
    @constraint(model, x[2] + x[3] >= 1 / 2)
end

# 检查一个解是否满足所有约束
function check_solution(x)
    return (
        sum(x) ≈ 1 &&
        x[1] + x[2] >= 2 / 3 &&
        x[1] + x[3] >= 7 / 12 &&
        x[2] + x[3] >= 1 / 2 &&
        all(x .>= 0)
    )
end

# 找到核心解的边界
function find_core_boundaries()
    model = Model(GLPK.Optimizer)
    @variable(model, x[1:3] >= 0)
    core_constraints(model, x)

    boundaries = []
    for i in 1:3
        @objective(model, Max, x[i])
        optimize!(model)
        push!(boundaries, (i, value(x[i])))
    end

    return boundaries
end

# 主函数
function main()
    println("例 8.6.8 核心解分析:")

    # 计算核心解的边界
    boundaries = find_core_boundaries()
    println("\n核心解的边界:")
    for (i, val) in boundaries
        println("x$i 的最大值: $val")
    end

    # 验证平衡解 (1/3, 1/3, 1/3)
    balanced_solution = [1 / 3, 1 / 3, 1 / 3]
    println("\n验证平衡解 (1/3, 1/3, 1/3):")
    if check_solution(balanced_solution)
        println("(1/3, 1/3, 1/3) 是一个有效的核心解")
    else
        println("(1/3, 1/3, 1/3) 不是一个有效的核心解")
    end

    # 输出约束条件的验证
    println("\n约束条件验证:")
    println("x1 + x2 = $(balanced_solution[1] + balanced_solution[2]) ≥ 2/3")
    println("x1 + x3 = $(balanced_solution[1] + balanced_solution[3]) ≥ 7/12")
    println("x2 + x3 = $(balanced_solution[2] + balanced_solution[3]) ≥ 1/2")
    println("x1 + x2 + x3 = $(sum(balanced_solution)) = 1")
end

# 运行主函数
main()
