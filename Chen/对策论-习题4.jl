using GLM, DataFrames, LinearAlgebra

# 输入数据
years = 1:21
fiscal_revenue = [22.5, 21.1, 20.3, 20.7, 22.0, 22.4, 24.4, 30.2, 35.4, 38.8, 43.6, 52.4, 52.9, 58.2, 55.1, 73.2, 108.8, 147.0, 193.0, 230.8, 262.1]
tertiary_industry = [2.0, 2.1, 2.6, 3.0, 3.7, 4.6, 5.7, 7.2, 8.9, 10.8, 13.5, 16.3, 16.0, 19.3, 23.8, 29.0, 40.8, 51.3, 60.7, 72.3, 81.2]
consumption = [7.7, 9.0, 10.7, 12.8, 14.1, 15.4, 15.8, 18.7, 21.6, 25.3, 31.3, 35.4, 37.3, 38.9, 44.1, 57.0, 74.0, 99.6, 118.5, 138.3, 157.4]

# 创建数据框
df = DataFrame(
    Y=fiscal_revenue,
    t=years,
    X1=tertiary_industry,
    X2=consumption
)

# 模型1：关于时间t的线性回归
model_t = lm(@formula(Y ~ t), df)

# 模型2：关于第三产业产值和居民消费的二元线性回归
model_x = lm(@formula(Y ~ X1 + X2), df)

# 计算两个模型的预测值
y_pred_t = predict(model_t)
y_pred_x = predict(model_x)

# 计算最优组合系数
A = [sum(y_pred_t .^ 2) sum(y_pred_t .* y_pred_x); sum(y_pred_t .* y_pred_x) sum(y_pred_x .^ 2)]
b = [sum(y_pred_t .* fiscal_revenue); sum(y_pred_x .* fiscal_revenue)]
λ = A \ b

# 组合预测模型
y_pred_combined = λ[1] * y_pred_t + λ[2] * y_pred_x

# 输出结果
println("时间t的线性回归模型：")
println(model_t)
println("\n第三产业产值和居民消费的二元线性回归模型：")
println(model_x)
println("\n最优组合系数：")
println("λ1 = $(λ[1]), λ2 = $(λ[2])")

# 计算并比较三个模型的预测误差平方和
sse_t = sum((fiscal_revenue - y_pred_t) .^ 2)
sse_x = sum((fiscal_revenue - y_pred_x) .^ 2)
sse_combined = sum((fiscal_revenue - y_pred_combined) .^ 2)

println("\n时间模型的预测误差平方和：$sse_t")
println("二元回归模型的预测误差平方和：$sse_x")
println("组合模型的预测误差平方和：$sse_combined")
