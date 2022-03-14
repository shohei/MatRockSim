edit % ===== RocketSim =====
% 6���R�x�̉^�����s�����đ̂̔��ăV�~�����[�^
% Matlab2014R��Octave3.6.4�œ�����m�F�B
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

% ---- �p�����[�^�ݒ�ǂݍ��� ----
% params_test
params
% params_M3S

% ---- ����������� ----
AbsTol = [1e-4; % m
          1e-4; 1e-4; 1e-4; % pos
          1e-4; 1e-4; 1e-4; % vel
          1e-4; 1e-4; 1e-4; 1e-4; %quat
          1e-3; 1e-3; 1e-3]; % omega
options = odeset('Events', @events_land, 'RelTol', 1e-3, 'AbsTol', AbsTol);

time_end = 400;
if time_parachute > time_end
  time_parachute = time_end - 0.1;
end

disp('Start Simulation...');

% �p���V���[�g�̗L���ŃV�~�����[�V�����̏ꍇ����
if para_exist == true
  disp('with parachute');  
  tic
  [T_rocket, X_rocket] = ode23s(@rocket_dynamics, [0 time_parachute], x0, options);
  toc;tic
  [T_parachute, X_parachute] = ode23s(@parachute_dynamics, [time_parachute time_end], X_rocket(length(X_rocket),:), options);
  toc
  T = [T_rocket; T_parachute];
  X = [X_rocket; X_parachute];
else
  % �p���{���b�N�t���C�g
  disp('no parachute');  
  tic
  [T, X] = ode23s(@rocket_dynamics, [0 time_end], x0, options);
  toc
end

% --------------
%     plot
% --------------
figure()
plot(T,X(:,1))
title('Weight')
xlabel('Time [s]')
ylabel('Weight [kg]')
grid on

figure()
plot(T,X(:,2),'-',T,X(:,3),'-',T,X(:,4),'-')
title('Position')
xlabel('Time [s]')
ylabel('Position [m]')
legend('Altitude','East','North')
grid on

figure()
plot(T,X(:,5),'-',T,X(:,6),'-',T,X(:,7),'-')
title('Velocity')
xlabel('Time [s]')
ylabel('Velocity [m/s]')
legend('Altitude','East','North')
grid on

figure()
plot(T,X(:,8),'-',T,X(:,9),'-',T,X(:,10),'-',T,X(:,11),'-')
title('Attitude')
xlabel('Time [s]')
ylabel('Quaternion [-]')
legend('q0','q1','q2','q3')
grid on

figure()
plot(T,X(:,12),'-',T,X(:,13),'-',T,X(:,14),'-')
title('Angler Velocity')
xlabel('Time [s]')
ylabel('Angler Velocity [rad/s]')
legend('omega x','omega y','omega z')
grid on

% coordinate: Up-East-North
figure()
plot3(X(:,3),X(:,4),X(:,2),0,0,0,'x');
grid on
xlabel('East');
ylabel('North');
% �v���b�g���L���C�ɂ��邽�߂̒���
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


% ----
% mapping
% ----
% output�t�H���_���Ȃ���������
if exist('output', 'dir') == 0
  mkdir output;
end

tic
disp('making KML and HTML files...');
pos2GPSdata(filename, T, X(:,2), X(:,3), X(:,4), xr, yr, zr, time_ref, day_ref )
str_KML = pos2KML(filename, X(:,2), X(:,3), X(:,4),xr, yr, zr);
KML2html(filename, str_KML,launch_phi, launch_lambda, launch_h);
toc
