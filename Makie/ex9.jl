using CSV
using DataFrames
using DataFramesMeta
using CategoricalArrays
using CairoMakie
using AlgebraOfGraphics

dclass = CSV.read("class19.csv", DataFrame)
transform!(dclass,
    :sex => (s -> categorical(s)),
    renamecols=false)
transform!(dclass, :sex => (x -> levelcode.(x)) => :sexi,
    :age => categorical => :agec)

p1 = data(dclass) * frequency() * mapping(
         :sex => renamer("F" => "女", "M" => "男") => "性别")
draw(p1, axis=(width=200, height=400))

p2 = data(dclass) * frequency() * mapping(
         :sex => sorter(["M", "F"]))
draw(p2, axis=(width=200, height=400))

p3 = data(dclass) * frequency() *
     mapping(:age => nonnumeric)
draw(p3, axis=(width=200, height=400))