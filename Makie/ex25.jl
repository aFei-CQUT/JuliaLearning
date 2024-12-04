using Downloads
using CSV
using DataFrames
using AlgebraOfGraphics
using CairoMakie

urlf = "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
dht = CSV.read(Downloads.download(urlf), DataFrame, header=0)
rename!(dht, ["age", "sex", "cp", "trestbps", "chol",
    "fbs", "restecg", "thalach", "exang", "oldpeak",
    "slope", "ca", "thal", "num"])

fig = Figure(;size=(200,400))
p1 = data(dht) * mapping(:sex) * frequency()
draw!(fig[1,1], p1)
display(fig)

fig = Figure()
p1 = data(dht) * mapping(:sex) * frequency()
draw!(fig[1, 1], p1)
p2 = data(dht) * mapping(:age) * histogram()
draw!(fig[1, 2], p2)
colsize!(fig.layout, 1, Auto(0.5))
fig

fig = Figure()
p1 = data(dht) * mapping(:sex) * frequency()
draw!(fig[1, 1], p1)
ax2 = Axis(fig[1, 2])
scatter!(ax2, dht[:, :age], dht[:, :thalach])
colsize!(fig.layout, 1, Auto(0.5))
fig

fig = Figure()
ax1 = Axis(fig[1, 1])
p1 = data(dht) * mapping(:sex) * frequency()
draw!(ax1, p1)
ax2 = Axis(fig[1, 2])
scatter!(ax2, dht[:, :age], dht[:, :thalach])
colsize!(fig.layout, 1, Auto(0.5))
fig