% ===== RocketSim =====
% 6自由度の運動を行う飛翔体の飛翔シミュレータ
% Matlab2014RとOctave3.6.4で動作を確認。
% 
% Copyright (C) 2014, Takahiro Inagawa
% This program is free software under MIT license.
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
% ======================
clear global;  clear all; close all;

addpath ./quaternion
addpath ./environment
addpath ./aerodynamics
addpath ./mapping
addpath ./eng_files

% ---- パラメータ設定読み込み ----
% params_test
params
% params_M3S

% ---- 常微分方程式 ----
AbsTol = [1e-4; % m
          1e-4; 1e-4; 1e-4; % pos
          1e-4; 1e-4; 1e-4; % vel
          1e-4; 1e-4; 1e-4; 1e-4; %quat
          1e-3; 1e-3; 1e-3]; % omega
options = odeset('Events', @events_land, 'RelTol', 1e-3, 'AbsTol', AbsTol);

time_end = 400;

disp('Start Simulation...');

% パラシュートの有無でシミュレーションの場合分け
if para_exist == true
  disp('with parachute');  
  tic
  [T_rocket, X_rocket] = ode23s(@rocket_dynamics, [0 time_parachute_tmp], x0, options);
  toc;tic
  x_vertical = movmean(X_rocket(:,2),5);
  v_vertical = diff(x_vertical);
  v_vertical_filtered_index = find(v_vertical<0);
  apogee_index = v_vertical_filtered_index(1);
  t_apogee = T_rocket(apogee_index);
  tic
  [T_rocket, X_rocket] = ode23s(@rocket_dynamics, [0 t_apogee], x0, options);
  toc;tic
  [T_parachute, X_parachute] = ode23s(@parachute_dynamics, [t_apogee time_end], X_rocket(length(X_rocket),:), options);
  toc
  T = [T_rocket; T_parachute];
  X = [X_rocket; X_parachute];
  fprintf('Burn time: %.0f [s]\n',Tend);
  fprintf('Apogee altitude: %.0f [m]\n',X_rocket(end,2));
  fprintf('Apogee time t = %.0f [s]\n', t_apogee);
  fprintf('Ground hit speed: %.2f [m/s]\n',X(end,5));
  fprintf('Landing time t = %.0f [s]\n',T_parachute(end));
  fprintf('Horizontal landing distance: %.0f [m]\n',X_parachute(end,3));
else
  % パラボリックフライト
  disp('no parachute');  
  tic
  [T, X] = ode23s(@rocket_dynamics, [0 time_end], x0, options);
  toc
end

% --------------
%     plot
% --------------
% figure()
% plot(T,X(:,1))
% title('Weight')
% xlabel('Time [s]')
% ylabel('Weight [kg]')
% grid on
% 
% figure()
% plot(T,X(:,2),'-',T,X(:,3),'-',T,X(:,4),'-')
% title('Position')
% xlabel('Time [s]')
% ylabel('Position [m]')
% legend('Altitude','East','North')
% grid on
% 
% figure()
% plot(T,X(:,5),'-',T,X(:,6),'-',T,X(:,7),'-')
% title('Velocity')
% xlabel('Time [s]')
% ylabel('Velocity [m/s]')
% legend('Altitude','East','North')
% grid on
% 
% figure()
% plot(T,X(:,8),'-',T,X(:,9),'-',T,X(:,10),'-',T,X(:,11),'-')
% title('Attitude')
% xlabel('Time [s]')
% ylabel('Quaternion [-]')
% legend('q0','q1','q2','q3')
% grid on
% 
% figure()
% plot(T,X(:,12),'-',T,X(:,13),'-',T,X(:,14),'-')
% title('Angler Velocity')
% xlabel('Time [s]')
% ylabel('Angler Velocity [rad/s]')
% legend('omega x','omega y','omega z')
% grid on




% coordinate: Up-East-North
figure()
xe = X(:,3);
ye = X(:,4);
ze = X(:,2);
hh = plot3(X(:,3),X(:,4),X(:,2),0,0,0,'x');

grid on
xlabel('East');
ylabel('North');
% プロットをキレイにするための調整
plot3_height = max(X(:,2));
plot3_width_east = max(X(:,3)) - min(X(:,3));
plot3_width_north = max(X(:,4)) - min(X(:,4));
plot3_width_max = max([plot3_height; plot3_width_east; plot3_width_north])*1.1;
if min(X(:,3)) < 0
    xlim([min(X(:,3))*1.1 min(X(:,3))*1.1+plot3_width_max]);
else
    xlim([0 plot3_width_max*1.1]);
end
if min(X(:,4)) < 0
    ylim([min(X(:,4))*1.1 min(X(:,4))*1.1+plot3_width_max]);
else
    ylim([0 plot3_width_max*1.1]);
end
if plot3_height < plot3_width_max
    zlim([0 plot3_width_max]);
else
    zlim([0 plot3_height*1.1]);
end
big;
children = get(gca, 'children');
delete(children(1));
delete(hh);
hold on;
plot3(0,0,0,'x');

for i=1:length(xe)
  x = xe(i);
  y = ye(i);
  z = ze(i);
  plot3(x,y,z,'ro');
  drawnow;
  pause(0.01);
end

plot3(X(:,3),X(:,4),X(:,2),0,0,0,'x');

% ----
% mapping
% ----
% outputフォルダがなかったら作る
if exist('output', 'dir') == 0
  mkdir output;
end

tic
disp('making KML files...');
% pos2GPSdata(filename, T, X(:,2), X(:,3), X(:,4), xr, yr, zr, time_ref, day_ref );
str_KML = pos2KML(filename, X(:,2), X(:,3), X(:,4),xr, yr, zr);
toc
