using LinearAlgebra

# 定义决策矩阵和权重
A = [300 1000 15 70 50;
     250 800 10 80 60;
     200 500 20 60 80;
     230 700 13 70 70]

w = [0.3, 0.1, 0.25, 0.15, 0.2]

# 步骤1: 构建规范化决策矩阵
Y = A ./ sqrt.(sum(A .^ 2, dims=1))

# 步骤2: 构建加权的规范化决策矩阵
Z = Y .* w'

# 步骤3: 确定理想解和负理想解
J_b = [2, 4, 5]  # 效益型指标
J_c = [1, 3]     # 成本型指标

x_plus = [j in J_c ? minimum(Z[:, j]) : maximum(Z[:, j]) for j in 1:size(Z, 2)]
x_minus = [j in J_c ? maximum(Z[:, j]) : minimum(Z[:, j]) for j in 1:size(Z, 2)]

# 步骤4: 计算到理想解和负理想解的距离
S_plus = sqrt.(sum((Z .- x_plus') .^ 2, dims=2))
S_minus = sqrt.(sum((Z .- x_minus') .^ 2, dims=2))

# 步骤5: 计算相对贴近度
C = S_minus ./ (S_plus .+ S_minus)

# 输出结果
println("规范化决策矩阵 Y:")
println(Y)
println("\n加权的规范化决策矩阵 Z:")
println(Z)
println("\n理想解:")
println(x_plus)
println("\n负理想解:")
println(x_minus)
println("\n到理想解的距离 S+:")
println(S_plus)
println("\n到负理想解的距离 S-:")
println(S_minus)
println("\n相对贴近度 C:")
println(C)

# 步骤6: 排序
ranking = sortperm(vec(C), rev=true)
println("\n方案排序:")
println(ranking)
println("\n最优方案为 x", ranking[1])
