using LinearAlgebra

# 定义赢得矩阵A（注意：这里使用的是负值，因为我们要最小化支出）
A = [-10000 -17500 -30000;
     -15000 -15000 -25000;
     -20000 -20000 -20000]

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

    strategies = ["买10吨", "买15吨", "买20吨"]
    weather = ["较暖", "正常", "较冷"]

    println("采购员的最优策略: $(strategies[i])")
    println("对应的天气情况: $(weather[j])")
    println("最小支出: ", -A[i,j])  # 注意这里取负值，因为A中存储的是负的支出
else
    println("不存在纯策略解")
end
