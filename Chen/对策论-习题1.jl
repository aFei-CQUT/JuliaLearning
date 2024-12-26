# 定义参数
rain_probability = 0.6
outdoor_loss = 100000  # 10万元
indoor_rent = 70000    # 7万元
common_cost = 30000    # 3万元

# 计算户外展销的期望成本
outdoor_expected_cost = rain_probability * (outdoor_loss + common_cost) + 
                        (1 - rain_probability) * common_cost

# 计算室内展销的成本（固定成本）
indoor_cost = indoor_rent + common_cost

# 打印结果
println("户外展销的期望成本: ", outdoor_expected_cost, " 元")
println("室内展销的成本: ", indoor_cost, " 元")

# 做出决策
if outdoor_expected_cost < indoor_cost
    println("决策: 选择户外展销")
else
    println("决策: 选择室内展销")
end

# 计算成本差异
cost_difference = abs(outdoor_expected_cost - indoor_cost)
println("成本差异: ", cost_difference, " 元")
