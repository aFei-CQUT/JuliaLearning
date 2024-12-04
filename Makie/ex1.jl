using GLMakie  # 导入后端
using Makie    # 导入 Makie

fig = Figure(; size=(1000, 700))
ga = fig[1, 1] = GridLayout()
gb = fig[2, 1] = GridLayout()
gcd = fig[1:2, 2] = GridLayout()
gc = gcd[1, 1] = GridLayout()

# 显示图形
display(fig)
