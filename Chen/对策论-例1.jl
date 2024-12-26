using LinearAlgebra

# 定义赢得矩阵A
A = [4 0 2;
    3 2 5;
    -5 2 1]

# 计算每行的最小值
row_mins = minimum(A, dims=2)

# 计算每列的最大值  
col_maxs = maximum(A, dims=1)

# 找出行最小值中的最大值
max_row_min = maximum(row_mins)

# 找出列最大值中的最小值
min_col_max = minimum(col_maxs)

# 检查是否存在纯策略解
if max_row_min == min_col_max
    println("存在纯策略解")

    # 找出解的位置
    result = findfirst(x -> x == max_row_min, A)
    i, j = result.I  # 使用 .I 来获取 CartesianIndex 的坐标

    println("局中人1的最优策略: α$i")
    println("局中人2的最优策略: β$j")
    println("对策值: ", A[i, j])
else
    println("不存在纯策略解")
end
