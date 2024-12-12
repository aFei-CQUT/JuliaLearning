using CSV, DataFrames, Plots

d_class = CSV.read("class.csv", DataFrame)
dtmp = copy(d_class)
sort!(dtmp, :height)
Plots.plot(dtmp[:, :height], dtmp[:, :weight], color=:blue, linewidth=2, label="Weight vs. Height")


x = range(0; stop=10, length=200)
y = sin.(x)
Plots.plot(x, y, color=:blue, linewidth=2, label="sin(x)")


Plots.plot(sin, 0, 10, title="Sine Function")


x = range(0; stop=10, length=200)
y = [sin.(x) cos.(x)]
plot(x, y, label=["sin" "cos"])


x = range(0; stop=10, length=200)
y = [sin.(x) cos.(x)]
plot(x, y, label=["sin" "cos"])
plot!(x, sin.(x) .^ 2, label="sin^2")