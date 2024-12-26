function nash_equilibrium(A, B)
    # 计算Q, q, R, r
    Q = A[1,1] + A[2,2] - A[2,1] - A[1,2]
    q = A[2,2] - A[1,2]
    R = B[1,1] + B[2,2] - B[2,1] - B[1,2]
    r = B[2,2] - B[1,2]

    # 计算α和β
    α = q / Q
    β = r / R

    # 寻找平衡点
    equilibria = []

    # 检查(0,0), (1,1)和(β,α)是否为平衡点
    if 0 <= α <= 1 && 0 <= β <= 1
        push!(equilibria, (0.0, 0.0))
        push!(equilibria, (1.0, 1.0))
        push!(equilibria, (β, α))
    end

    return equilibria
end

function expected_payoffs(A, B, x, y)
    E1 = x * (y * A[1,1] + (1-y) * A[1,2]) + (1-x) * (y * A[2,1] + (1-y) * A[2,2])
    E2 = x * (y * B[1,1] + (1-y) * B[1,2]) + (1-x) * (y * B[2,1] + (1-y) * B[2,2])
    return E1, E2
end

# 定义赢得矩阵
A = [2 -1; -1 1]
B = [1 -1; -1 2]

# 计算Nash均衡点
equilibria = nash_equilibrium(A, B)

println("Nash均衡点:")
for (i, eq) in enumerate(equilibria)
    println("均衡点 $i: x = $(eq[1]), y = $(eq[2])")
    E1, E2 = expected_payoffs(A, B, eq[1], eq[2])
    println("  期望赢得: E1 = $E1, E2 = $E2")
end
