using AlgebraOfGraphics
using CairoMakie

x = collect(range(0, 2π, 100))
y = sin.(x)
p1 = data((; x=x, y=y)) * mapping(:x, :y) * visual(Lines)
draw(p1)
