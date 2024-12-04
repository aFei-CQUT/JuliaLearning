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

p1 = data(dclass) * mapping(:height => (x -> x / 100) => "身高", :weight => "体重")
draw(p1, axis=(width=300, height=300))
