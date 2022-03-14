clear; close all;  clc;

addpath 'environment';

nairobi_lat = -1.2921;
h_max = 100e3;
hs = linspace(0,h_max,30);

gs = [];
for idx=1:length(hs)
  h = hs(idx);
  g = gravity(h,nairobi_lat);
  gs(end+1) = g;
end

plot(gs, hs/1000);
ylabel('高度 [km]');
xlabel('重力加速度 [m/s2]');
ax = gca;
ax.XDir = 'reverse';
big;
