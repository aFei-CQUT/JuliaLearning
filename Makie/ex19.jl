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

p1 = data(dht) * mapping(:age, :thalach) * AlgebraOfGraphics.density(npoints=20)
draw(p1)

p1b = p1 * visual(Surface)
draw(p1b, axis=(type=Axis3, zticks=0:0.1:0.2, 
    limits=(nothing, nothing, (0, 0.001))))