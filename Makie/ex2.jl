using Downloads
using CSV
using DataFrames

urlf = "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
dht = CSV.read(Downloads.download(urlf), DataFrame, header=0)
rename!(dht, ["age", "sex", "cp", "trestbps", "chol",
    "fbs", "restecg", "thalach", "exang", "oldpeak",
    "slope", "ca", "thal", "num"])

using AlgebraOfGraphics
using CairoMakie

set_aog_theme!()
p1a = data(dht) * mapping(:cp) * frequency()
fig1 = draw(p1a; axis=(width=200, height=400))
save("barplot-ex1.png", fig1, px_per_unit=3)

p1b = p1a * mapping(color=:sex => nonnumeric, stack=:sex => nonnumeric)
fig2 = draw(p1b, axis=(width=200, height=400))
save("barplot-ex2.png", fig2, px_per_unit=3)

p1c = p1a * mapping(color = :sex => nonnumeric, dodge = :sex => nonnumeric)
fig3 = draw(p1c, axis = (width = 200, height = 400))
save("barplot-ex3.png", fig3, px_per_unit=3)