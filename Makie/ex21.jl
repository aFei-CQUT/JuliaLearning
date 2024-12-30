using Downloads
using CSV
using DataFrames
using AlgebraOfGraphics
using CategoricalArrays
using CairoMakie
using Makie: Text  # 显式导入 Text

# 读取数据
dclass = CSV.read("class19.csv", DataFrame)

# 转换性别为分类变量
transform!(dclass,
    :sex => (s -> categorical(s)),
    renamecols=false)

# 添加额外的列
transform!(dclass, :sex => (x -> levelcode.(x)) => :sexi,
    :age => categorical => :agec)

# 创建散点图和线性回归
p1 = data(dclass) * mapping(:height, :weight) * (
         visual(Scatter) +
         linear())
draw(p1)

# 创建散点图和平滑曲线
p2 = data(dclass) * mapping(:height, :weight) * (
         visual(Scatter) +
         smooth(span=0.75) * visual(color=:red))
draw(p2)
