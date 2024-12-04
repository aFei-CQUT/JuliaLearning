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

p2 = data(dht) * mapping(:age, :thalach) *
     AlgebraOfGraphics.density()
draw(p2, axis=(width=300, height=300))

p2b = p2 * visual(Contour)
draw(p2b, axis=(width=300, height=300))

p2c = p1 +
      p1 * linear() +
      p2 * visual(Contour)
draw(p2c, axis=(width=300, height=300))