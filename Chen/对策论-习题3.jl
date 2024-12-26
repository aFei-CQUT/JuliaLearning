# 定义参数
big_scale_investment = 50  # 大规模生产的一次性投资
small_scale_investment = 20  # 小规模生产的一次性投资
additional_investment = 30  # 追加投资额

# 定义收益函数
function profit(scale, market_condition)
    if scale == :big
        return market_condition == :good ? 30 : -5
    else  # small scale
        return market_condition == :good ? 10 : 4
    end
end

# 计算期望收益
function expected_profit(strategy)
    if strategy == :big
        # 大规模生产
        first_two_years = 0.6 * 2 * profit(:big, :good) + 0.4 * 2 * profit(:big, :bad)
        next_five_years = 0.6 * (0.9 * 5 * profit(:big, :good) + 0.1 * 5 * profit(:big, :bad)) +
                          0.4 * (0.2 * 5 * profit(:big, :good) + 0.8 * 5 * profit(:big, :bad))
        return first_two_years + next_five_years - big_scale_investment
    elseif strategy == :small
        # 小规模生产
        first_two_years = 0.6 * 2 * profit(:small, :good) + 0.4 * 2 * profit(:small, :bad)
        next_five_years = 0.6 * (0.9 * 5 * profit(:small, :good) + 0.1 * 5 * profit(:small, :bad)) +
                          0.4 * (0.2 * 5 * profit(:small, :good) + 0.8 * 5 * profit(:small, :bad))
        return first_two_years + next_five_years - small_scale_investment
    else  # :mixed strategy
        # 前两年小规模，然后决定是否扩大
        first_two_years = 0.6 * 2 * profit(:small, :good) + 0.4 * 2 * profit(:small, :bad)
        
        # 如果前两年好，扩大生产
        good_scenario = 0.9 * 5 * profit(:big, :good) + 0.1 * 5 * profit(:big, :bad) - additional_investment
        
        # 如果前两年不好，继续小规模
        bad_scenario = 0.2 * 5 * profit(:small, :good) + 0.8 * 5 * profit(:small, :bad)
        
        next_five_years = 0.6 * good_scenario + 0.4 * bad_scenario
        
        return first_two_years + next_five_years - small_scale_investment
    end
end

# 计算每种策略的期望收益
big_scale_profit = expected_profit(:big)
small_scale_profit = expected_profit(:small)
mixed_strategy_profit = expected_profit(:mixed)

# 找出最佳策略
best_strategy = argmax([big_scale_profit, small_scale_profit, mixed_strategy_profit])
strategies = [:big, :small, :mixed]

println("大规模生产的期望收益: ", round(big_scale_profit, digits=2))
println("小规模生产的期望收益: ", round(small_scale_profit, digits=2))
println("混合策略的期望收益: ", round(mixed_strategy_profit, digits=2))
println("最佳策略是: ", strategies[best_strategy])
