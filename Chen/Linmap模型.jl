using JuMP
using Ipopt

# 定义决策矩阵
A = [0 5;
    5 4;
    0 2;
    1 3;
    4 1]

# 定义成对比较集合Q
Q = [(2, 1), (1, 3), (4, 1), (1, 5), (2, 3), (2, 4), (2, 5), (4, 3), (5, 3), (4, 5)]  # 调整顺序

# 创建模型
model = Model(Ipopt.Optimizer)

# 定义变量
@variable(model, w[1:2] >= 0)
@variable(model, v[1:2])
@variable(model, λ[1:length(Q)] >= 0)

# 设置目标函数
@objective(model, Min, sum(λ))

# 添加约束条件
for (idx, (k, l)) in enumerate(Q)
    @constraint(model,
        sum(w[j] * (A[l, j]^2 - A[k, j]^2) for j in 1:2) -
        2 * sum(v[j] * (A[l, j] - A[k, j]) for j in 1:2) +
        λ[idx] >= 0
    )
end

# 添加归一化约束
@constraint(model, sum(w[j] * sum((A[l, j]^2 - A[k, j]^2) for (k, l) in Q) for j in 1:2) -
                   2 * sum(v[j] * sum((A[l, j] - A[k, j]) for (k, l) in Q) for j in 1:2) == 1)

# 求解模型
optimize!(model)

# 输出结果
println("Optimal objective value: ", objective_value(model))
println("w = ", value.(w))
println("v = ", value.(v))

# 计算理想点
z = value.(v) ./ value.(w)
println("Ideal point z = ", z)

# 计算各方案到理想点的平方距离
S = [sum(value(w[j]) * (A[i, j] - z[j])^2 for j in 1:2) for i in 1:5]
println("Square distances to ideal point S = ", S)

# 对方案进行排序
ranking = sortperm(S)
println("Ranking of alternatives: ", ranking)
