clear all
close all
pt=1.500;
freq=5.6e9;
G=45;
sigma=0.1;
Te=100e-6;
b=1/Te;
L=6;
NF=3;
range=[25:5:300];
np=[1,10,100];
[snr]=lprf_req(pt,freq,G,sigma,Te,NF,L,range,np);