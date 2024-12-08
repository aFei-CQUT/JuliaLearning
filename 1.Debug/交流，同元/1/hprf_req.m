%程序2.5高脉冲重复频率雷达方程的计算   
function snr=hprf_req(pt,freq,G,sigma,ti,range,NF,L,dt)
%这个程序实现的是高脉冲重复频率雷达方程
c=3.0e+8;
lamda=c/freq;   
num1=10*log10(pt*1000.0*lamda.^2*sigma*ti*dt.' )+2.*G;  
num2=10*log10((4.0*pi)^3*1.38e-23*290*(range*1000).^4)+NF+L;
snr=num1*ones(1,length(range))-ones(length(dt),1)*num2;
plot(range,snr);
xlabel('距离/km');
ylabel('SNR/dB');
grid;