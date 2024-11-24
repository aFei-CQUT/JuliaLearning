function fun(W)
    m, n = size(W)
    e = 0
    E = Int[]  # 初始化边数组
    
    # 收集非零权重的边
    for i in 1:n
        for j in i:n
            if W[i, j] != 0
                e += 1
                E[e,:]=[i j W(i, j)]
            end
        end
    end
    
    # 按权值大小排列边的顺序
    sort!(E, by = x -> x[3])
    
    A = zeros(Int, 1, 3) # 初始化 A 为一个零行三列数组
    S = collect(1:n)     # 初始化集合 S
    
    for i in 1:e
        u = E[i, 1]
        v = E[i, 2]
        
        # 判断是否在同一集合中
        if S[u] != S[v]
            # 添加边到 A
            A = vcat(A, E[i, :])  # 垂直连接
        
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
println(A)