using DataFrames, CategoricalArrays, AlgebraOfGraphics, CairoMakie

dlay01 = DataFrame(f1 = categorical(rand(["a", "b"], 100)), 
    f2 = rand(["c", "d"], 100),
    x0 = randn(100), y0 = randn(100))
transform!(dlay01, [:y0, :f1] => ByRow((x, f) -> f == "a" ? x + 1 : x + 4) => :y,
    [:x0, :f2] => ByRow((x, f) -> f == "c" ? x + 10 : x + 20) => :x)

pdm1 = data(dlay01) * mapping(:x, :y)
dlay1 = mapping(row=:f1, col=:f2)

# draw(pdm1 * dlay1)

# draw(pdm1 * dlay1, facet=(; linkxaxes=:minimal))

draw(pdm1 * dlay1, facet=(; linkxaxes=:none))