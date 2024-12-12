using Statistics, StatsBase


x = [1, 3, 4, 1, 3, 1]

g = unique(x)
show(g)

[count(xi -> xi == gk, x) for gk in g] |> show