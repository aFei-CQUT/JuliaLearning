using GLM, DataFrames, LinearAlgebra

# 输入数据
years = 1:12
disposable_income = [2.027, 2.577, 3.496, 4.283, 4.839, 5.16, 5.425, 5.854, 6.28, 6.86, 7.703, 8.472]
consumption_expenditure = [1.672, 2.111, 2.851, 3.538, 3.919, 4.186, 4.332, 4.616, 4.998, 5.309, 6.03, 6.511]

# 创建数据框
df = DataFrame(
    Y = consumption_expenditure,
    t = years,
    X = disposable_income
)

# 模型1：关于时间t的线性回归
model_t = lm(@formula(Y ~ t), df)

# 模型2：关于人均可支配收入的一元线性回归
model_x = lm(@formula(Y ~ X), df)

# 计算两个模型的预测值
y_pred_t = predict(model_t)
y_pred_x = predict(model_x)

# 计算最优组合系数
A = [sum(y_pred_t.^2) sum(y_pred_t .* y_pred_x); sum(y_pred_t .* y_pred_x) sum(y_pred_x.^2)]
b = [sum(y_pred_t .* consumption_expenditure); sum(y_pred_x .* consumption_expenditure)]
λ = A \ b

# 组合预测模型
y_pred_combined = λ[1] * y_pred_t + λ[2] * y_pred_x

# 输出结果
println("时间t的线性回归模型：")
println(model_t)
println("\n人均可支配收入的一元线性回归模型：")
println(model_x)
println("\n最优组合系数：")
println("λ1 = $(λ[1]), λ2 = $(λ[2])")

# 计算并比较三个模型的预测误差平方和
sse_t = sum((consumption_expenditure - y_pred_t).^2)
sse_x = sum((consumption_expenditure - y_pred_x).^2)
sse_combined = sum((consumption_expenditure - y_pred_combined).^2)

println("\n时间模型的预测误差平方和：$sse_t")
println("可支配收入模型的预测误差平方和：$sse_x")
println("组合模型的预测误差平方和：$sse_combined")

# 输出组合模型的方程
intercept_t = coef(model_t)[1]
slope_t = coef(model_t)[2]
intercept_x = coef(model_x)[1]
slope_x = coef(model_x)[2]

combined_intercept = λ[1] * intercept_t + λ[2] * intercept_x
combined_slope_t = λ[1] * slope_t
combined_slope_x = λ[2] * slope_x

println("\n组合模型方程：")
println("Y = $combined_intercept + $combined_slope_t * t + $combined_slope_x * X")
