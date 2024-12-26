using JuMP
using GLPK

function find_core_solution()
    model = Model(GLPK.Optimizer)

    @variable(model, x[1:3] >= 0)

    @constraint(model, sum(x) == 1)
    @constraint(model, x[1] + x[2] >= 2/3)
    @constraint(model, x[1] + x[3] >= 7/12)
    @constraint(model, x[2] + x[3] >= 1/2)

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        return value.(x)
    else
        return nothing
    end
end

# 运行例 8.6.8
core_solution = find_core_solution()
println("例 8.6.8:")
if core_solution !== nothing
    println("核心解的一个可能的分配方案是: ", core_solution)
    println("验证约束条件:")
    println("x1 + x2 = ", core_solution[1] + core_solution[2], " ≥ 2/3")
    println("x1 + x3 = ", core_solution[1] + core_solution[3], " ≥ 7/12")
    println("x2 + x3 = ", core_solution[2] + core_solution[3], " ≥ 1/2")
    println("x1 + x2 + x3 = ", sum(core_solution), " = 1")
else
    println("未找到核心解")
end

# 验证 (1/3, 1/3, 1/3) 是否在核心中
balanced_solution = [1/3, 1/3, 1/3]
println("\n验证 (1/3, 1/3, 1/3) 是否在核心中:")
println("x1 + x2 = ", balanced_solution[1] + balanced_solution[2], " ≥ 2/3")
println("x1 + x3 = ", balanced_solution[1] + balanced_solution[3], " ≥ 7/12")
println("x2 + x3 = ", balanced_solution[2] + balanced_solution[3], " ≥ 1/2")
println("x1 + x2 + x3 = ", sum(balanced_solution), " = 1")
