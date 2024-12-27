using LinearAlgebra

A = [-2 3; 3 -2]
x_star = [5 // 12, 7 // 12]
y_star = [7 // 12, 5 // 12]
V = 41 // 72

function E(x, y)
    return x' * A * y
end

function check_optimality()
    pure_strategies = [[1 // 1, 0 // 1], [0 // 1, 1 // 1]]
    for (i, x) in enumerate(pure_strategies)
        ex = E(x, y_star)
        if ex > E(x_star, y_star)
            println("对于纯策略 x$i: E(x, y*) = $ex > E(x*, y*) = $(E(x_star, y_star))")
            return false
        end
    end
    for (i, y) in enumerate(pure_strategies)
        ey = E(x_star, y)
        if ey < E(x_star, y_star)
            println("对于纯策略 y$i: E(x*, y) = $ey < E(x*, y*) = $(E(x_star, y_star))")
            return false
        end
    end
    return true
end

println("矩阵A:")
display(A)

println("\n局中人1的最优混合策略 x*:")
println(x_star)

println("\n局中人2的最优混合策略 y*:")
println(y_star)

println("\nE(x*, y*):")
println(E(x_star, y_star))

println("\n验证最优性条件:")
if check_optimality()
    println("E(x, y*) ≤ E(x*, y*) ≤ E(x*, y) 条件成立")
else
    println("E(x, y*) ≤ E(x*, y*) ≤ E(x*, y) 条件不成立")
end

# 额外的详细验证
println("\n额外的详细验证:")
pure_strategies = [[1 // 1, 0 // 1], [0 // 1, 1 // 1]]
for (i, x) in enumerate(pure_strategies)
    println("E(x$i, y*) = ", E(x, y_star))
end
for (i, y) in enumerate(pure_strategies)
    println("E(x*, y$i) = ", E(x_star, y))
end

# 验证x*是否是最优策略
println("\n验证x*是否是最优策略:")
for (i, x) in enumerate(pure_strategies)
    if E(x, y_star) > E(x_star, y_star)
        println("x*不是最优策略，因为存在纯策略x$(i)使得E(x$(i), y*) > E(x*, y*)")
    end
end

# 验证y*是否是最优策略
println("\n验证y*是否是最优策略:")
for (i, y) in enumerate(pure_strategies)
    if E(x_star, y) < E(x_star, y_star)
        println("y*不是最优策略，因为存在纯策略y$(i)使得E(x*, y$(i)) < E(x*, y*)")
    end
end
