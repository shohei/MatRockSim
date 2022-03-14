clear; close all; clc;

Tend=4;
FT=150;
Isp=200;
g0 = 9.8066;
ts = linspace(0,Tend+1,20);
Fts = [];

for idx=1:length(ts)
    t = ts(idx);
    Ft = thrust(t, [Tend], [FT]); 
    Fts(end+1) = Ft;
end

delta_m = -Fts / Isp / g0;
yyaxis left;
plot(ts,Fts);
hold on;
yyaxis right;
plot(ts,delta_m);
big;

