clear; close all; clc;


CDs = [];
VAB_max = 340*2;
VABs = linspace(0,VAB_max,30);
a = 340;

for idx=1:length(VABs)
  VAB = VABs(idx);
  CD = cd_Rocket(norm(VAB) / a);
  CDs(end+1) = CD;
end

plot(VABs,CDs);
xlabel('VAB [m/s]');
ylabel('CD')
big;
