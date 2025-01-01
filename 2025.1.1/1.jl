using TyControlSystems:TyControlSystems, tf, feedback, step, impulse
using TyPlot
 
# 定义初始参数
T0_values = [10, 1, 0.1, 0.01]
num = [3.1, 230]
G0 = tf([1], [1])  # 单位负反馈
 
# 存储数组
sys = Array{TyControlSystems.TransferFunction}(undef, length(T0_values), 1)
 
# 所有响应系统
for (i, T0) in enumerate(T0_values)
    den = T0 * [1, 44.7, 502, 0]
    G = tf(num, den)
    sys[i, 1] = feedback(G, G0)
end
 
figure()
 
hold(true)
step(sys[:]..., label=["T0 = $T0" for T0 in T0_values])
title("Step Response for Different T0 Values")
xlabel("Time (s)")
ylabel("Response")
legend();
 
figure()
 
hold(true)
impulse(sys[:]..., label=["T0 = $T0" for T0 in T0_values])
title("Impulse Response for Different T0 Values")
xlabel("Time (s)")
ylabel("Response")
legend();