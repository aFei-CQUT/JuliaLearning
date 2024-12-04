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

p1 = data(dht) * mapping(:thalach) * histogram()
draw(p1)

p1b = data(dht) * mapping(:thalach,
          color=:sex => nonnumeric, stack=:sex => nonnumeric) * histogram()
draw(p1b)

d1c = data(dht) * mapping(:thalach,
          layout=:sex => nonnumeric) * histogram()
draw(d1c)