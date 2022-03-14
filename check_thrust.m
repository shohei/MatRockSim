clear; close all; 

fid = fopen('March_03.eng');
tline = fgetl(fid);
ts = [];
Fs = [];
while ischar(tline)
    if tline(1)~=';'
      val = split(tline);
      if length(val)==2
        t = str2double(cell2mat(val(1)));
        F = str2double(cell2mat(val(2)));
        ts(end+1) = t;
        Fs(end+1) = F;
      end
    end
    tline = fgetl(fid);
end

tt = linspace(0,3,20);
FF = interp1(ts,Fs,tt);
plot(ts,Fs,'-',tt,FF,':.');

title('Thrust');
xlabel('Time [s]');
ylabel('Thrust [N]');
legend('measured','interpolated');
big;



