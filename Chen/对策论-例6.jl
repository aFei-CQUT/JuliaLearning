using Combinatorics

function characteristic_function(S, α)
    if length(S) == 1
        return 0
    elseif length(S) == 2
        return α
    elseif length(S) == 3
        return 1
    else
        return 0
    end
end

function is_imputation(x, V)
    return all(x .>= 0) && isapprox(sum(x), V([1, 2, 3]), atol=1e-6)
end

function is_dominating(x, y, S, V)
    return all(x[S] .>= y[S]) && sum(x[S]) <= V(S)
end

function is_in_core(x, α)
    N = [1, 2, 3]
    V = S -> characteristic_function(S, α)
    for S in powerset(N)
        if !isempty(S) && sum(x[collect(S)]) < V(collect(S)) - 1e-6
            return false
        end
    end
    return true
end

function find_core(α, step=0.001)
    N = [1, 2, 3]
    V = S -> characteristic_function(S, α)
    core = []
    for x1 in 0:step:1
        for x2 in 0:step:(1-x1)
            x3 = 1 - x1 - x2
            x = [x1, x2, x3]
            if is_imputation(x, V) && is_in_core(x, α)
                push!(core, round.(x, digits=3))
            end
        end
    end
    return unique(core)
end

function solve_example_8_6_6()
    α = 2 / 3
    core = find_core(α)

    println("核心中的分配方案:")
    for x in core
        println(x)
    end

    x = [1 / 3, 1 / 3, 1 / 3]
    y = [1 / 6, 1 / 6, 2 / 3]
    V = S -> characteristic_function(S, α)

    println("\n验证 x 和 y 是否为转归:")
    println("x 是转归: ", is_imputation(x, V))
    println("y 是转归: ", is_imputation(y, V))

    println("\n验证 x 是否在核心中:")
    println("x 在核心中: ", is_in_core(x, α))

    println("\n验证 x 是否优超 y:")
    for S in powerset([1, 2, 3])
        if !isempty(S) && is_dominating(x, y, collect(S), V)
            println("x 在联盟 $S 上优超 y")
        end
    end

    if any(is_dominating(x, y, collect(S), V) for S in powerset([1, 2, 3]) if !isempty(S))
        println("x 优超 y")
    else
        println("x 不优超 y")
    end
end

# 运行例8.6.6的解答
solve_example_8_6_6()
