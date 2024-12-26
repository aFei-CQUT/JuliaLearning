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

# 运行例 8.6.7
max_alpha = find_alpha_range()
println("例 8.6.7:")
println("α 的最大值为: ", max_alpha)
println("因此，C(V) ≠ ∅ 成立的 α 范围是: 0 ≤ α ≤ ", max_alpha)
