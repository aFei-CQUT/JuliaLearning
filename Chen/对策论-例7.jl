using JuMP
using GLPK

function find_alpha_range()
    model = Model(GLPK.Optimizer)

    @variable(model, x[1:3] >= 0)
    @variable(model, α)

    @constraint(model, sum(x) == 1)
    @constraint(model, x[1] + x[2] >= α)
    @constraint(model, x[1] + x[3] >= α)
    @constraint(model, x[2] + x[3] >= α)

    @objective(model, Max, α)

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        return value(α)
    else
        return nothing
    end
end

# 主函数
function solve_example_8_6_7()
    max_alpha = find_alpha_range()
    println("例 8.6.7:")
    println("α 的最大值为: ", max_alpha)
    println("因此，C(V) ≠ ∅ 成立的 α 范围是: 0 ≤ α ≤ ", max_alpha)
end

# 运行主函数求解例8.6.7
solve_example_8_6_7()
