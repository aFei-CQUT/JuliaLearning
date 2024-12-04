let
    x = range(-2, 2, 100)
    y = x .^ 2
    d = DataFrame(x = x, y = y)
    p1 = data(d) * mapping(:x, :y) * visual(Lines)
    draw(p1, axis = (; title = L"Graph of $y = x^2$",
            xlabel="x", ylabel = L"x^2"))
end