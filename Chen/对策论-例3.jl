## 待完善，检查结果说不符合，但是计算结果与例题一致





using LinearAlgebra

A = [-2 3; 3 -2]
x_star = [5 / 12, 7 / 12]
y_star = [7 / 12, 5 / 12]
V = 41 / 72

function E(x, y)
    return x' * A * y
end

function check_optimality()
    pure_strategies = [[1.0, 0.0], [0.0, 1.0]]
    for (i, x) in enumerate(pure_strategies)
        ex = E(x, y_star)
        if ex > V + 1e-6
            println("For pure strategy x$i: E(x, y*) = $ex > V = $V")
            return false
        end
    end
    for (i, y) in enumerate(pure_strategies)
        ey = E(x_star, y)
        if ey < V - 1e-6
            println("For pure strategy y$i: E(x*, y) = $ey < V = $V")
            return false
        end
    end
    return true
end

function check_constant_expectation()
    pure_strategies = [[1.0, 0.0], [0.0, 1.0]]
    for (i, y) in enumerate(pure_strategies)
        ey = E(x_star, y)
        if !isapprox(ey, V, atol=1e-6)
            println("For pure strategy y$i: E(x*, y) = $ey ≠ V = $V")
            return false
        end
    end
    for (i, x) in enumerate(pure_strategies)
        ex = E(x, y_star)
        if !isapprox(ex, V, atol=1e-6)
            println("For pure strategy x$i: E(x, y*) = $ex ≠ V = $V")
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

println("\n对策值 V:")
println(V)

println("\n验证最优性条件:")
if check_optimality()
    println("E(x, y*) ≤ E(x*, y*) ≤ E(x*, y) 条件成立")
else
    println("E(x, y*) ≤ E(x*, y*) ≤ E(x*, y) 条件不成立")
end

println("\n直接验证 E(x*, y*) = V:")
println("E(x*, y*) = ", E(x_star, y_star))
println("V = ", V)
println("是否相等：", isapprox(E(x_star, y_star), V, atol=1e-6))

println("\n验证对任意y，E(x*, y) = V 且对任意x，E(x, y*) = V:")
if check_constant_expectation()
    println("条件成立")
else
    println("条件不成立")
end
