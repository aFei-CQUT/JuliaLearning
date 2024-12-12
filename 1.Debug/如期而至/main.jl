function f(x)
    return x^3 - 2*x + 5
end

a = 0
b = 3
r = 0.618
x1 = b - r * (b - a)
x2 = a + r * (b - a)
f1 = f(x1)
f2 = f(x2)

for k in 1:7
    global a, b, x1, x2, f1, f2  # 声明为全局变量
    if f1 < f2
        b = x2
        x2 = x1
        f2 = f1
        x1 = b - r * (b - a)
        f1 = f(x1)
    else
        a = x1
        x1 = x2
        f1 = f2
        x2 = a + r * (b - a)
        f2 = f(x2)
    end
end

xq = 0.5 * (a + b)
println("最优解 xq: ", xq)
