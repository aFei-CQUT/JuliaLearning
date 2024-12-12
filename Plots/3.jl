using CSV, DataFrames, Plots, StatsPlots

d_class = CSV.read("class.csv", DataFrame)
dtmp = copy(d_class)
sort!(dtmp, :height)
@df dtmp plot(:height, :weight, 
    xlabel="height", ylabel="weight",
    color=:blue, linewidth=2, legend=:none)