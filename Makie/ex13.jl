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

pdm1 = data(dclass) * mapping(:height, :weight)
pf1 = mapping(layout=:sex)
draw(pdm1 * pf1)