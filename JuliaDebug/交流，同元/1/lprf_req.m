%程序2.4低脉冲重复频率雷达方程的计算 lprf_req.m   
function[snr]=lprf_req(pt,freq,G,sigma,tao,NF,L,range,np)  
%这个程序实现的是低脉冲重复频率雷达方程(2.6.18)
c=3.0e+8;
lamda=c/freq;
numl=10*log10(pt*1.0e3*tao*lamda^2*sigma)+2*G;  
num2=10*log10((4.0*pi)^3*1.38e-23*290)+NF+L;   
range_db=40*log10(range*1000.0);   
snr=numl+10*log10(np')*ones(1,length(range))-num2-ones(length(np),1)*range_db;
figure;
plot(range,snr');
xlabel('距离/km');
ylabel('SNR/dB');
grid;