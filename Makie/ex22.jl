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

p1 = data(dclass) * mapping(:height, :weight)
draw(p1, axis = (; width=400, height=300, title="体重对身高",
        xlabel="身高", ylabel = "体重"))

p1 = data(dclass) * mapping(:sex) * frequency()
draw(p1, axis=(; aspect=1 / 3))