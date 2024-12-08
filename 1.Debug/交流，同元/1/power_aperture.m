%程序2.3搜索雷达方程的计算   power_aperture.m
function PAP=power_aperture(range,snr,sigma,tsc,az_angle,el_angle,NF,L)
%这个程序实现的是方程(2.6.11),计算功率孔径积
omega=az_angle*el_angle/(57.296^2);
numl=10*log10(4.0*pi*1.38e-23*290*omega)+NF+L+snr;  
num2=sigma'+10*log10(tsc);
PAP=numl-num2*ones(1,length(range))+40*ones(length(sigma),1)*log10(range*1000);  
figure;
% hold on;
plot(range,PAP);
xlabel('功率孔径积/dB');
ylabel('探测距离/km');
grid;