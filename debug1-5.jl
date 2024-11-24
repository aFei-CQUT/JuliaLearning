function fun(W)
    m, n = size(W)

    if m != n
        error("输入矩阵必须是方阵")
    end
    
    E = Vector{Tuple{Int,Int,Float64}}()  # 使用元组存储边

    # 收集非零权重的边
    for i in 1:n
        for j in i:n
            if W[i, j] != 0 && W[i, j] != Inf
                push!(E, (i, j, W[i, j]))
            end
        end
    end
    
    # 按权值大小排列边的顺序
    sort!(E, by = x -> x[3])
    
    A = Vector{Tuple{Int,Int,Float64}}()  # 初始化 A 为空向量
    S = [Set([i]) for i in 1:n]  # 初始化每个节点为单独的集合
    
    for (u, v, weight) in E
        # 确保 u 和 v 是整数
        u, v = Int(u), Int(v)
        
        # 找到 u 和 v 所在的集合
        set_u = findfirst(set -> u in set, S)
        set_v = findfirst(set -> v in set, S)
        
        # 如果 u 和 v 不在同一个集合中
        if set_u != set_v
            # 添加边到 A
            push!(A, (u, v, weight))
        
            # 合并集合
            union!(S[set_u], S[set_v])
            deleteat!(S, set_v)
        end
    end
    
    return A
end

# 测试用的邻接矩阵
w = [
    Inf 4   Inf   Inf   Inf   Inf   Inf   1   2;
    4   Inf  1     Inf   Inf   Inf   Inf   Inf   1;
    Inf 1   Inf   1     Inf   Inf   Inf   Inf   3;
    Inf Inf 1    Inf   5     Inf   Inf   Inf   4;
    Inf Inf Inf  5     Inf   2     Inf   Inf   4;
    Inf Inf Inf  Inf   2     Inf   3     Inf   2;
    Inf Inf Inf  Inf   Inf   3     Inf   5   5;
    1   Inf Inf   Inf   Inf   Inf   5     Inf   4;
    2   1   3     4     4     2     5   4   Inf
]

# 调用函数
A = fun(w)
println("结果矩阵 A:")
for edge in A
    println(edge)
end
