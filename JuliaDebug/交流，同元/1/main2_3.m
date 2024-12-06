clear all
close all
range=[20:1:250];
sigma=[-20,-10,0];
% sigma=-20;
% sigma=-10;
% sigma=0;
tsc=2;
az_angle=180;
el_angle=135;
L=6;
NF=8;
snr=20;
PAP=power_aperture(range,snr,sigma,tsc,az_angle,el_angle,NF,L);
% sigma=-10;
% PAP=power_aperture(range,snr,sigma,tsc,az_angle,el_angle,NF,L);
% sigma=0;
% PAP=power_aperture(range,snr,sigma,tsc,az_angle,el_angle,NF,L);