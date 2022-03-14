clear; close all; clc;
addpath 'environment';
min_h = 0e3; %m
max_h = 86e3; %m
hs = linspace(min_h,max_h,40);
Ps = [];
Ts = [];
as = [];
rhos = [];

for idx=1:length(hs)
  h = hs(idx);
  [T, a, P, rho] = atmosphere_Rocket(h);
  Ps(end+1) = P;
  Ts(end+1) = T;
  as(end+1) = a;
  rhos(end+1) = rho;  
end

subplot(141);
hh = plot(Ps,hs/1000);
ylabel('高度[km]');
xlabel('圧力[Pa]');
ax = ancestor(hh, 'axes');
ax.YAxis.Exponent = 0;
ax.XAxis.Exponent = 0;
xtickformat('%.0f')

subplot(142);
hh = plot(Ts,hs/1000);
ylabel('高度[km]');
xlabel('温度[K]');

subplot(143);
hh = plot(as,hs/1000);
ylabel('高度[km]');
xlabel('音速[m/s]');

subplot(144);
hh = plot(rhos,hs/1000);
ylabel('高度[km]');
xlabel('密度[kg/m3]');

big;
  

