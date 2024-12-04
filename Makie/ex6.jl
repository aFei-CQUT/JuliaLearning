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

p1 = data(dht) * mapping(:age => "年龄", :thalach => "血压")
draw(p1, axis=(width=300, height=300))