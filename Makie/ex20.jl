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

p1 = data(dht) * mapping(:age) * frequency()
draw(p1)