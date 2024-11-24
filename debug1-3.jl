function fun(W)
    m, n = size(W)
    e = 0
    E = Matrix{Float64}(undef, 0, 3)  # 初始化边数组为0行3列的矩阵
    
    # 收集非零权重的边
    for i in 1:n
        for j in i:n
            if W[i, j] != 0 && W[i, j] != Inf  # 添加对Inf的检查
                e += 1
                E = vcat(E, [Float64(i) Float64(j) W[i, j]])  # 使用vcat添加新的边，确保所有元素都是Float64
            end
        end
    end
    
    # 按权值大小排列边的顺序
    E = sortslices(E, dims=1, by=x->x[3])
    
    A = Matrix{Float64}(undef, 0, 3) # 初始化 A 为0行3列的Float64矩阵
    S = collect(1:n)     # 初始化集合 S
    
    for i in 1:e
        u = Int(E[i, 1])
        v = Int(E[i, 2])
        
        # 判断是否在同一集合中
        if S[u] != S[v]
            # 添加边到 A
            A = vcat(A, E[i:i, :])  # 垂直连接，使用切片确保维度匹配
        
            indicator = S[u]
            for j in 1:n
                if S[j] == indicator
                    S[j] = S[v]  # 合并集合
                end
            end
        end
    end
    
    return A  # 返回A
end

# 测试用的邻接矩阵保持不变

# 调用函数
A = fun(w)
println("结果矩阵 A:")
println(A)
