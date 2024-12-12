using Random

Random.seed!(101)
x = rand(Normal(10, 2), 30)
fit_mle(Normal, x)