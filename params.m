% ---- �O���[�o���ϐ��̐ݒ�i������Ȃ��j ----
global Isp g0
global FT Tend At CLa area
global length_GCM length_A
global IXX IYY IZZ
global IXXdot IYYdot IZZdot
global VWH
global para_Cd para_S

% ---- �p�����[�^�ݒ� ----
% m0: ��������[kg]
% Isp: �䐄��[sec]
% g0: �n��ł̏d�͉����x[m/s2]
% FT: ����[N]
% Tend: �R�Ď���[sec]
% At: �X���[�g�a[m2]
% area: �@�̂̒f�ʐ�[m2]
% CLa: �g�͌X��[/rad]
% CD: �R�͌W��[-]
% length_GCM: �G���W���s�{�b�g�_����̏d�S�ʒu�x�N�g��[m](3x1)
% length_A: �G���W���s�{�b�g�_����̋�͒��S�_�ʒu�x�N�g��[m] (3x1)
% IXX,IYY,IZZ: �������[�����g[kgm2]
% IXXdot,IYYdot,IZZdot: �������[�����g�̎��ԕω�[kgm2/sec]
% azimth, elevation: �����p���̕��ʊp�A�p[deg]
% VWH:�@�������W�n�ɂ����Ă̕���(Up-East-North) [m/s] (3x1)
m0 = 4.0;
Isp = 200;
g0 = 9.80665;
FT = 150;
Tend = 4;
At = 0.01;
area = 0.010;
CLa = 3.5;
length_GCM = [-0.70; 0; 0]; length_A = [-0.50; 0; 0];
IXX = 5; IYY = 5; IZZ = 1;
IXXdot = 0; IYYdot = 0; IZZdot = 0;
azimth = 45; elevation = 90;
% VWH = [0; 0; 0];
VWH = [0; 4; 0];

% ---- �p���V���[�g ----
% para_exist : �p���V���[�g�����邩�ǂ���[true,false]
% para_Cd: �p���V���[�g�R�͌W��[-]
% para_Dia: �p���V���[�g�J�P���̒��a[m]
% para_S: �p���V���[�g�ʐ�[m2]
para_exist = true;
% para_Cd = 1.0;
para_Cd = 0.8;
% para_Dia = 1.5;
para_Dia = 2.0;
time_parachute = 10;
para_S = para_Dia * para_Dia / 4 * pi;

% ---- ������������Ɏg����ԗʂ̏����� ----
% pos0: �˓_���S�������W�n�ɂ�����ʒu�iUp-East-North)[m] (3x1)
% vel0: �˓_���S�������W�n�ɂ����鑬�x[m/s] (3x1)
% quat0: �@�̍��W�n���琅�����W�n�ɕϊ���\���N�H�[�^�j�I��[-] (4x1)
% omega0: �@�̍��W�n�ɂ�����@�̂ɓ����p���x[rad/s] (3x1)
pos0 = [0.0; 0.0; 0.0]; % m
vel0 = [0.0; 0.0; 0.0]; % m/s
quat0 = attitude(azimth, elevation);
omega0 = [0.0; 0.0; 0.0]; % rad/s
x0 = [m0; pos0; vel0; quat0; omega0];

% ---- mapping�̂��߂̕ϐ� ----
% filename: output�t�H���_�ɏo�͂���KML,HTML�t�@�C���̃t�@�C����(string)
% launch_phi,lambda, h: �˓_�̈ܓx�o�x���x�A�x�\��[deg][deg][m]
% time_ref: ���ˎ���[HHMMSS.SS] ��. 12��34��56.78�b��123456.78
% day_ref: ���˓�[year, month, day] ��. 2014�N1��1����[2014, 1, 1]
% ---- �Q�l ----
% �\��F���C�x���g��3�͐Ϗ�˓_ [40.1408, 139.9860, 20]
% �ɓ��哇�������˓_ [34.731059, 139.415917, 465]
% ���V�Y�F����Ԋϑ����i�~���[�Z���^�[�j[31.251008, 131.082301]
% JKUAT: -1.091108, 37.011861, 1527
filename = 'jkuat';
% launch_phi = 34.731059; % 43.5807
% launch_lambda = 139.415917; % 142.002083
% launch_h = 465; % 50
launch_phi = -1.090786; %JKUAT rugby field;
launch_lambda = 37.014623;
launch_h = 1527; 
time_ref=123456.78;
day_ref = [2022, 4,1];
[xr, yr, zr] = blh2ecef(launch_phi, launch_lambda, launch_h);



