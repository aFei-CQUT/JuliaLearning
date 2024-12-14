using TyMath, TyPlot

t = [0, 0.52, 1.04, 1.75, 2.37, 3.25, 3.83]
x = [0, 32, 55, 96, 108, 118, 120]

dx = TyMath.gradient(x)
dt = TyMath.gradient(t)
v = dx ./ dt

figure()
plot(t, v)

hold("on")

tfit = [0, 4]
vfit(x) = -20.15 * x + 70.12
fplot(vfit, tfit, "k*-", markersize = 1)

xlabel("时间(s)")
ylabel("速度(m/s)")
legend("数值速度曲线", "拟合速度函数图");
