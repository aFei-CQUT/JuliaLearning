using Distributions
using CairoMakie

let
    d = MixtureModel(Normal[
            Normal(0, 0.3), Normal(1, 0.1)], 
        [0.7, 0.3])
    x = -2:0.01:2
    y = pdf.(d, x)
    m = mean(d)
    s = std(d)
    lines(x, y, axis=(; title="mean: $(m) std: $(s)"))
end