using CSV
using DataFrames
using DataFramesMeta
using CategoricalArrays

dclass = CSV.read("class19.csv", DataFrame)
transform!(dclass,
    :sex => (s -> categorical(s)),
    renamecols=false)
transform!(dclass, :sex => (x -> levelcode.(x)) => :sexi,
    :age => categorical => :agec)

dc = copy(dclass)
DataFramesMeta.transform!(dc,
    :height => (x -> x ./ 100) => "身高(米)")
p2 = data(dc) * mapping("身高(米)", :weight => "体重")
draw(p2, axis=(width=300, height=300))