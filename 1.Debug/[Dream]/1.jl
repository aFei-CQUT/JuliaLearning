using TyControlSystems: tf

H = tf([2 5 1], [1 2 3])

nyquist(H);