using DataFrames, RDatasets


rds = RDatasets.datasets()

size(rds)
first(rds, 3)

rds[occursin.("crab", rds[:, :Dataset]), :]

crabs = RDatasets.dataset("MASS", "crabs")
size(crabs)
first(crabs, 3)