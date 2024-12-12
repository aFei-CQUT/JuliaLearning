using Distributions
using CairoMakie

CairoMakie.activate!()

let
    x = -3:0.1:3
    y = pdf.(Normal(0, 1), x)  # 指定均值为0，标准差为1
    lines(x, y)
end
