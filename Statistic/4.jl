using HypothesisTests, Statistics


x = [
303, 282, 289, 298, 283, 
317, 297, 308, 317, 293, 
284, 290, 304, 290, 311, 
305, 277, 278, 301, 304, 
300, 293, 300, 276, 318, 
303, 309, 293, 316, 302, 
295, 294, 291, 297, 300, 
299, 303, 299, 282, 318, 
296, 285, 288, 279, 310, 
315, 292, 303, 301, 292
]

tres11 = OneSampleZTest(
    mean(x),   # 样本均值
    12.0,      # 已知的标准差
    length(x), # 样本量
    295.0)     # 要比较的mu0

confint(tres11)

pvalue(tres11)

pvalue(tres11, tail = :right)

tres12 = OneSampleTTest(x, 295.0)

tres21 = BinomialTest(750, 1000, 0.80)

confint(tres21, tail=:both, method=:wilson)