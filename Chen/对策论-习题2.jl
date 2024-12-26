# 定义参数
cost_per_unit = 6
price_per_unit = 9
loss_per_unit = 2
possible_demands = [0, 1000, 2000, 3000, 4000, 5000]
max_production = 4000

# 计算利润函数
function calculate_profit(production, demand)
    sold = min(production, demand)
    unsold = max(0, production - demand)
    revenue = sold * price_per_unit
    cost = production * cost_per_unit
    loss = unsold * loss_per_unit
    return revenue - cost - loss
end

# 计算所有可能的生产量和需求组合的利润
profits = [calculate_profit(prod, dem) for prod in 0:max_production, dem in possible_demands]

# 乐观准则（最大最大准则）
function optimistic_criterion(profits)
    max_profits = maximum(profits, dims=2)
    best_production = argmax(max_profits)[1] - 1
    return best_production, max_profits[best_production+1]
end

# 悲观准则（最大最小准则）
function pessimistic_criterion(profits)
    min_profits = minimum(profits, dims=2)
    best_production = argmax(min_profits)[1] - 1
    return best_production, min_profits[best_production+1]
end

# 折衷准则（Hurwicz准则，这里我们使用α=0.5）
function hurwicz_criterion(profits, α=0.5)
    hurwicz_values = α * maximum(profits, dims=2) + (1 - α) * minimum(profits, dims=2)
    best_production = argmax(hurwicz_values)[1] - 1
    return best_production, hurwicz_values[best_production+1]
end

# 应用决策准则
optimistic_result = optimistic_criterion(profits)
pessimistic_result = pessimistic_criterion(profits)
hurwicz_result = hurwicz_criterion(profits)

# 打印结果
println("乐观准则：最佳生产量 = ", optimistic_result[1], "，最大可能利润 = ", optimistic_result[2])
println("悲观准则：最佳生产量 = ", pessimistic_result[1], "，保证最小利润 = ", pessimistic_result[2])
println("折衷准则：最佳生产量 = ", hurwicz_result[1], "，期望利润 = ", hurwicz_result[2])
