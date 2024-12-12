using Statistics, StatsBase


methods(mean)

quantile(rand(1000))

quantile(rand(1000), [0.01, 0.99])

StatsBase.ordinalrank([3, 1, 2, 4, 2]) |> show
StatsBase.competerank([3, 1, 2, 4, 2]) |> show
StatsBase.denserank([3, 1, 2, 4, 2]) |> show
StatsBase.tiedrank([3, 1, 2, 4, 2]) |> show