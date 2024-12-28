using BenchmarkTools
using Combinatorics

# 定义特征函数
function V(S, α)
    if length(S) == 0 || length(S) == 1
        return 0
    elseif length(S) == 2
        return α
    elseif length(S) == 3
        return 1
    end
end

# 检查是否为转归（分配）
function is_imputation(x, α, atol=1e-6)
    return all(x .>= -atol) && abs(sum(x) - 1) < atol
end

# 检查一个转归是否在联盟S上优超另一个转归
function dominates(x, y, S, α)
    return all(x[S] .> y[S]) && sum(x[S]) <= V(S, α)
end

# 检查一个转归是否整体上优超另一个转归
function dominates_overall(x, y, α)
    N = [1, 2, 3]
    for S in powerset(N)
        if !isempty(S) && dominates(x, y, collect(S), α)
            return true
        end
    end
    return false
end

# 检查一个分配是否在核心中
function is_in_core(x, α, atol=1e-6)
    N = [1, 2, 3]
    for S in powerset(N)
        if !isempty(S)
            if sum(x[i] for i in S) < V(collect(S), α) - atol
                return false
            end
        end
    end
    return abs(sum(x) - V(N, α)) < atol
end

# 生成所有可能的分配方案
function generate_allocations(n=100)
    allocations = []
    for i in 0:n
        for j in 0:(n-i)
            x1 = i // n
            x2 = j // n
            x3 = (n - i - j) // n
            push!(allocations, [x1, x2, x3])
        end
    end
    return allocations
end

# 找出核心中的分配方案
function find_core_allocations(α, n=100, atol=1e-6)
    allocations = generate_allocations(n)
    return [x for x in allocations if is_imputation(x, α, atol) && is_in_core(x, α, atol)]
end

# 计算优超关系的数量
function count_dominations(allocations, α)
    count = 0
    for (i, x) in enumerate(allocations)
        for (j, y) in enumerate(allocations)
            if i != j && dominates_overall(x, y, α)
                count += 1
            end
        end
    end
    return count
end

# 主函数：求解例8.6.5
function solve_example_8_6_5(α, n=100)
    println("Solving Example 8.6.5 with α = $α and n = $n")

    # 生成所有可能的分配方案
    println("\nGenerating allocations:")
    all_allocations = @btime generate_allocations($n)
    println("Number of all allocations: ", length(all_allocations))

    valid_imputations = @btime [x for x in $all_allocations if is_imputation(x, $α)]
    println("Number of valid imputations: ", length(valid_imputations))

    # 计算优超关系的数量
    println("\nCalculating domination relations:")
    domination_count = @btime count_dominations($valid_imputations, $α)
    println("Number of domination relations: ", domination_count)

    # 找出核心中的分配方案
    println("\nFinding core allocations:")
    core_allocations = @btime find_core_allocations($α, $n)
    println("Number of core allocations: ", length(core_allocations))

    # 输出一些示例分配
    println("\nSample allocations in the core:")
    for i in 1:min(5, length(core_allocations))
        println(core_allocations[i])
    end

    # 检查特定的分配方案
    test_allocations = [
        [1 // 3, 1 // 3, 1 // 3],
        [2 // 5, 3 // 10, 3 // 10],
        [7 // 20, 7 // 20, 3 // 10]
    ]
    println("\nChecking specific allocations:")
    for alloc in test_allocations
        is_in_core_result = @btime is_in_core($alloc, $α)
        println(alloc, " is in core: ", is_in_core_result)
    end
end

# 运行主函数求解例8.6.5
α = 2 // 3
solve_example_8_6_5(α, 100)
