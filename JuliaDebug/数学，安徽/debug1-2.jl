function fun(W)
    m, n = size(W)
    E = Vector{Vector{Int}}()  # 初始化边数组为向量的向量
    
    # 收集非零权重的边
    for i in 1:n
        for j in i:n
            if W[i, j] != 0 && W[i, j] != Inf  # 添加对Inf的检查
                push!(E, [i, j, Int(W[i, j])])  # 使用push!添加新的边
            end
        end
    end
    
    # 按权值大小排列边的顺序
    sort!(E, by = x -> x[3])
    
    A = Vector{Vector{Int}}()  # 初始化 A 为向量的向量
    S = collect(1:n)     # 初始化集合 S
    
    for edge in E
        u, v = edge[1], edge[2]
        
        # 判断是否在同一集合中
        if S[u] != S[v]
            # 添加边到 A
            push!(A, edge)  # 使用push!添加边
        
            indicator = S[u]
            for j in 1:n
                if S[j] == indicator
                    S[j] = S[v]  # 合并集合
                end
            end
        end
    end
    
    return A
end

# 测试用的邻接矩阵保持不变

# 调用函数
A = fun(w)
println("结果矩阵 A:")
for edge in A
    println(edge)
end
