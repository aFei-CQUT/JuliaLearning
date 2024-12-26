using Combinatorics

# 定义特征函数V
function V(S, α)
    if length(S) == 0
        return 0
    elseif length(S) == 1
        return 0
    elseif length(S) == 2
        return α
    elseif length(S) == 3
        return 1
    end
end

# 检查分配方案是否满足个体合理性和集体合理性
function is_imputation(x, α)
    # 个体合理性
    for xi in x
        if xi < 0
            return false
        end
    end
    # 集体合理性
    return isapprox(sum(x), 1, atol=1e-6)
end

# 检查分配方案x是否优超y在联盟S上
function dominates(x, y, S, α)
    for i in S
        if x[i] <= y[i]
            return false
        end
    end
    return sum(x[i] for i in S) <= V(S, α)
end

# 检查分配方案是否在核心中
function is_in_core(x, α)
    N = [1, 2, 3]
    for S in powerset(N)
        if !isempty(S)
            if sum(x[i] for i in S) < V(collect(S), α) - 1e-6
                return false
            end
        end
    end
    return isapprox(sum(x), V(N, α), atol=1e-6)
end

# 找出所有可能的核心分配方案
function find_core_allocations(α, step=0.001)
    core_allocations = []
    for x1 in 0:step:1
        for x2 in 0:step:(1-x1)
            x3 = 1 - x1 - x2
            x = [x1, x2, x3]
            if is_imputation(x, α) && is_in_core(x, α)
                push!(core_allocations, round.(x, digits=3))
            end
        end
    end
    return unique(core_allocations)
end

# 主程序
function main()
    # 示例数据
    α = 2 / 3
    x = [1 / 3, 1 / 3, 1 / 3]
    y = [1 / 6, 1 / 6, 2 / 3]

    # 验证分配方案是否满足个体合理性和集体合理性
    println("x is an imputation: ", is_imputation(x, α))
    println("y is an imputation: ", is_imputation(y, α))

    # 验证x是否优超y在联盟{1,2}上
    S = [1, 2]
    println("x dominates y in coalition S = {1,2}: ", dominates(x, y, S, α))

    # 验证x是否在核心中
    println("x is in the core: ", is_in_core(x, α))

    # 找出所有可能的核心分配方案
    core_allocations = find_core_allocations(α)
    println("\nNumber of core allocations found: ", length(core_allocations))
    println("Sample of core allocations:")
    for i in 1:min(5, length(core_allocations))
        println(core_allocations[i])
    end

    # 额外检查
    println("\nChecking specific allocations:")
    test_allocations = [
        [1 / 3, 1 / 3, 1 / 3],
        [0.4, 0.3, 0.3],
        [0.35, 0.35, 0.3]
    ]
    for alloc in test_allocations
        println(alloc, " is in core: ", is_in_core(alloc, α))
    end
end

# 运行主程序
main()
