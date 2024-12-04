using Downloads
using CSV
using DataFrames
using AlgebraOfGraphics
using CairoMakie

dclass = CSV.read("class19.csv", DataFrame)
transform!(dclass,
    :sex => (s -> categorical(s)),
    renamecols=false)
transform!(dclass, :sex => (x -> levelcode.(x)) => :sexi,
    :age => categorical => :agec)

p1 = data(dclass) * mapping(:height, :weight) *(
    visual(Scatter) +
    linear())
draw(p1)

p1 = data(dclass) * mapping(:height, :weight) * (
         visual(Scatter) +
         smooth(span=0.75) * visual(color=:red))
draw(p1)

p1 = data(dclass) *
     mapping(:name => verbatim, (:height, :weight) => Point) *
     visual(Annotations, textsize=8)
draw(p1)