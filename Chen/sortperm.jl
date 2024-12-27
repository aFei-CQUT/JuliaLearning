x = [154.6 158.63 167.5 163.5 167.7 158.97;
    140.4 137.24 147.5 139.5 140.8 128.99;
    115.9 98.21 110.7 100.4 94.47 84.74;
    66.6 61.31 72.21 65.38 48.42 48.64;
    45.9 32.64 48.88 35.02 16.47 21.66;
    17.9 17.42 20.77 15.2 4.05 9.38;
    13.4 16.4 12.11 7.812 9.09 10.7;
    29.2 26.47 26.3 21.75 24.88 32.23]

m = 5;
n = 8;
err = zeros(8, 5)

for i in 2:6
    for j in 1:8
        err[j, i-1] = (x[j, 1] - x[j, i])^2
    end
end

Eii = sum(err, dims=1)

# 算术平均方法权向量系数
l1 = zeros(5, 1)
for i in 1:5
    l1[i] = 0.2
end
println("算术平均方法权向量系数:" * string(l1))

# 误差平方和倒数方法权向量系数
l2 = zeros(5, 1)
Eii2 = Eii .^ (-1)
for i in 1:5
    l2[i] = Eii[1, i]^(-1) / sum(Eii2)
end
println("误差平方和倒数方法权向量系数:" * string(l2))

# 均方误差导数方法权向量系数
l3 = zeros(5, 1)
Eii3 = Eii .^ (-1 / 2)
for i in 1:5
    l3[i] = Eii[1, i]^(-1 / 2) / sum(Eii3)
end
println("均方误差导数方法权向量系数:" * string(l3))

# 简单加权平均方法权向量系数
l4 = zeros(5, 1)
sorted_indices = sortperm(vec(Eii))
Eii4 = 1:5
for i in 1:5
    l4[sorted_indices[i]] = i / sum(Eii4)
end
println("简单加权平均方法权向量系数:" * string(l4))

# 二项式系数方法权向量系数
l5 = zeros(5, 1)
Eii5 = [binomial(9, i - 1) for i in 1:5]
for i in 1:5
    l5[sorted_indices[i]] = Eii5[i] / sum(Eii5)
end
println("二项式系数方法权向量系数:" * string(l5))

# 方法1-5组合预测值
L = [l1 l2 l3 l4 l5]
x_com_pred = x[:, 2:6] * L
println("方法1-方法5组合预测值" * string(x_com_pred))

# 方法1-5组合预测精度
ERR1 = zeros(8, 5)
ERR2 = zeros(8, 5)
for i in 1:5
    for j in 1:8
        ERR1[j, i] = abs(x[j, 1] - x_com_pred[j, i])
        ERR2[j, i] = (x[j, 1] - x_com_pred[j, i])^2
    end
end
MAE = 1 / 8 .* sum(ERR1, dims=1)
println("平均绝对误差:" * string(MAE))
SSE = sum(ERR2, dims=1)
println("误差平方和:" * string(SSE))
