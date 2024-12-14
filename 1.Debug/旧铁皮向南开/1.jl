using TyBase, TyMath, TyPlot

# 创建网格数据
X, Y = meshgrid2(-8:0.5:8, -8:0.5:8)

# 计算 R 值
R = sqrt.(X.^2 .+ Y.^2) .+ eps()

# 计算 Z 值
Z = sin.(R) ./ R

# 绘制三维图形
subplot(1, 1, 1)
surf(X, Y, Z)

# 设置图形标题
title("NMWORKS 三维着色曲面");
