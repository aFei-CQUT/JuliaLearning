using CSV, DataFrames, CategoricalArrays

d_class = CSV.read("class19.csv", DataFrame,
    types=Dict(
        "name" => String,
        "sex" => String,
        "height" => Float64,
        "weight" => Float64))
        
d_class[:, :sex] = categorical(d_class[:, :sex]);

using GLM

lmr = lm(@formula(weight ~ height), d_class)

lmr2 = lm(@formula(weight ~ sex + height), d_class)

lmr2b = lm(@formula(weight ~ -1 + sex + height), d_class)