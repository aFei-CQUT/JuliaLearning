using Statistics, StatsBase


x = [1, 3, 4, 1, 3, 1]

@show sort(unique(x));
@show StatsBase.counts(x);
@show StatsBase.proportions(x);
@show StatsBase.countmap(x);

StatsBase.fit(Histogram, [1, 2, 3, 2, 2, 3], [0.5, 1.5, 2.5, 3.5])

rle([3, 3, 1, 1, 1, 2, 2])

inverse_rle([3, 1, 2], [2, 3, 2]) |> show