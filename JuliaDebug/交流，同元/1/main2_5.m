clear all
close all
pt=100;
freq=5.6e9;
G=20;
sigma=0.01;
ti=2;
L=6;
NF=4;
range=[10:1:100];
dt=[0.3,0.2,0.1];
snr=hprf_req(pt,freq,G,sigma,ti,range,NF,L,dt);
