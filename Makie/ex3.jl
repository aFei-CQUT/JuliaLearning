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

p1 = data(dht) * mapping(:age, :thalach)
draw(p1)

p1b = p1 + p1 * linear()
draw(p1b)

p1c = p1 * mapping(color=:sex => nonnumeric)
draw(p1c)

p1d = p1 * mapping(color=:sex => nonnumeric) +
      p1 * linear() * mapping(color=:sex => nonnumeric)
draw(p1d, axis=(width=400, height=300))

p1e = p1 * mapping(layout=:sex => nonnumeric)
draw(p1e, axis=(width=300, height=300))

p1f = (p1 + p1 * linear()) *
      mapping(layout=:sex => nonnumeric)
draw(p1f, axis=(width=300, height=300))