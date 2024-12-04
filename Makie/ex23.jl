using Downloads
using CSV
using DataFrames
using CategoricalArrays

urlf = "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
dht = CSV.read(Downloads.download(urlf), DataFrame, header=0)
rename!(dht, ["age", "sex", "cp", "trestbps", "chol",
    "fbs", "restecg", "thalach", "exang", "oldpeak",
    "slope", "ca", "thal", "num"])

using AlgebraOfGraphics
using CairoMakie

p2 = data(dht) * mapping(:age, :thalach)
draw(p2, axis = (; xticks = 30:20:70))

p3 = data(dht) * mapping(:age, :thalach)
draw(p3, axis=(; xticks=(30:20:70, ["三十", "五十", "七十"])))

function cp_recode(x)
    x = string.(Int.(x))
    x = categorical(x)
    recode!(x, "1" => "典型心绞痛", "2" => "非典型心绞痛",
        "3" => "非心绞痛", "4" => "无症状")
    x
end

dht2 = transform(dht, :cp => cp_recode => :cpc)
p4 = data(dht2) * mapping(:cpc, :thalach) *
     visual(BoxPlot)
draw(p4)

p1 = data(dht) * mapping(:thalach, layout=:sex => nonnumeric) *
     histogram()
draw(p1, figure=(; backgrouncolor=:gray80, figure_padding=10,
    size=(600, 300)))

p1 = data(dht) * mapping(:age, :thalach) *
     mapping(color=:sex => renamer(0 => "女", 1 => "男") => "性别")
draw(p1)

draw(p1, legend=(; position=:top, titleposition=:left,
    framevisible=true, padding=5))

using AlgebraOfGraphics: scales

function recode_sex(x)
    x = string.(Int.(x))
    x = categorical(x)
    recode!(x, "0" => "女", "1" => "男")
    x
end

dht2 = transform(dht, :sex => recode_sex => :sexc)
p1 = data(dht2) * mapping(:age, :thalach) *
     mapping(color=:sexc => "性别")

# 使用新的 scales 函数来设置颜色
draw(p1, scales(Color=(palette=[:red, :blue],)))

p1 = data(dht) * mapping(:age, :thalach) *
     AlgebraOfGraphics.density(npoints=20) *
     visual(Heatmap, colormap=:heat)
draw(p1, colorbar=(; position=:top, size=25))