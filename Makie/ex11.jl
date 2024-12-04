using CSV
using DataFrames
using DataFramesMeta
using CategoricalArrays
using AlgebraOfGraphics, CairoMakie

dclass = CSV.read("class19.csv", DataFrame)
transform!(dclass,
    :sex => (s -> categorical(s)),
    renamecols=false)
transform!(dclass, :sex => (x -> levelcode.(x)) => :sexi,
    :age => categorical => :agec)

# 创建两个 Figure 对象
fig1 = Figure(; size=(800, 600))
fig2 = Figure(; size=(800, 600))

# 使用 col 映射的图
pdm_col = data(dclass) * mapping(:height, :weight, col=:sex)
draw!(fig1[1, 1], pdm_col)

# 使用 row 映射的图
pdm_row = data(dclass) * mapping(:height, :weight, row=:sex)
draw!(fig2[1, 1], pdm_row)

# 显示两个图
display(fig1)
display(fig2)
