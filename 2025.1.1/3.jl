using TyControlSystems: TyControlSystems, tf, feedback, rlocus
using TyPlot
using TyMath
using Base
 
T0=10;
num=[3.1 230];
den=T0*[1,44.7,502,0];
G=tf(num,den);
G0=tf([1],[1]);
sys10=feedback(G,G0);#单位负反馈系统T0=10;
#运行，打开app,然后Linear System Analyzer
T0=1;
den=T0*[1,44.7,502,0];
G=tf(num,den);
sys1=feedback(G,G0);#单位负反馈系统T0=1;
T0=0.1;
den=T0*[1,44.7,502,0];
G=tf(num,den);
sys01=feedback(G,G0);#单位负反馈系统T0=0.1;
T0=0.01;
den=T0*[1,44.7,502,0];
G=tf(num,den);
sys001=feedback(G,G0);#单位负反馈系统T0=0.01;
 
# 在第一个子图中绘制 sys10 的根轨迹
subplot(2, 2, 1);
hold("on")

rlocus(sys10);
title("sys10 Root Locus");
 
# 在第二个子图中绘制 sys1 的根轨迹
subplot(2, 2, 2);
rlocus(sys1);
title("sys1 Root Locus");
 
# 在第三个子图中绘制 sys01 的根轨迹
subplot(2, 2, 3);
rlocus(sys01);
title("sys01 Root Locus");
 
# 在第四个子图中绘制 sys001 的根轨迹
subplot(2, 2, 4);
rlocus(sys001);
title("sys001 Root Locus");
 