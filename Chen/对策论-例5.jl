using Combinatorics

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

function is_imputation(x, α, atol=1e-3)
    # 个体合理性
    for xi in x
        if xi < -atol
            return false
        end
    end
    # 集体合理性
    return abs(sum(x) - 1) < atol
end

function dominates(x, y, S, α)
    for i in S
        if x[i] <= y[i]
            return false
        end
    end
    return sum(x[i] for i in S) <= V(S, α)
end

function is_in_core(x, α, atol=1e-3)
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

function find_core_allocations(α, n=100, atol=1e-3)
    core_allocations = []
    for i in 0:n
        for j in 0:(n-i)
            x1 = i // n
            x2 = j // n
            x3 = (n - i - j) // n
            x = [x1, x2, x3]
            if is_imputation(x, α, atol) && is_in_core(x, α, atol)
                push!(core_allocations, x)
            end
        end
    end
    return unique(core_allocations)
end

# 测试代码
α = 2 // 3

x = [1 // 3, 1 // 3, 1 // 3]
y = [1 // 6, 1 // 6, 2 // 3]

println("x is an imputation: ", is_imputation(x, α))
println("y is an imputation: ", is_imputation(y, α))

S = [1, 2]
println("x dominates y in coalition S = {1,2}: ", dominates(x, y, S, α))

println("x is in the core: ", is_in_core(x, α))

core_allocations = find_core_allocations(α)
println("\nNumber of core allocations found: ", length(core_allocations))
println("Sample of core allocations:")
for i in 1:min(5, length(core_allocations))
    println(core_allocations[i])
end

println("\nChecking specific allocations:")
test_allocations = [
    [1 // 3, 1 // 3, 1 // 3],
    [2 // 5, 3 // 10, 3 // 10],
    [7 // 20, 7 // 20, 3 // 10]
]
for alloc in test_allocations
    println(alloc, " is in core: ", is_in_core(alloc, α))
end

# 手动检查 [1/3, 1/3, 1/3]
x_test = [1 // 3, 1 // 3, 1 // 3]
println("\nManual check for [1/3, 1/3, 1/3]:")
println("Is imputation: ", is_imputation(x_test, α))
println("Is in core: ", is_in_core(x_test, α))

println("\nTesting find_core_allocations with different n values:")
for n in [100, 1000]
    core_allocations = find_core_allocations(α, n)
    println("n = $n: Found $(length(core_allocations)) core allocations")
    if !isempty(core_allocations)
        println("Sample: ", core_allocations[1])
    end
end

# 手动检查一个接近 [1/3, 1/3, 1/3] 的分配方案
x_close = [333 // 1000, 333 // 1000, 334 // 1000]
println("\nChecking a close approximation to [1/3, 1/3, 1/3]:")
println(x_close)
println("Is imputation: ", is_imputation(x_close, α))
println("Is in core: ", is_in_core(x_close, α))
