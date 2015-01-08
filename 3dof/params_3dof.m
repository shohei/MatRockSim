% ---- �O���[�o���ϐ��̐ݒ�i������Ȃ��j ----
global ROCKET
global VWH
global para_Cd para_S

% ---- �p�����[�^�ݒ� ----
% m0: ��������[kg]
% Isp: �䐄��[sec]
% g0: �n��ł̏d�͉����x[m/s2]
% FT: ����[N]
% Tend: �R�Ď���[sec]
% At: �X���[�g�a[m2]
% Area: �@�̂̒f�ʐ�[m2]
% CLa: �g�͌X��[/rad]
% CD: �R�͌W��[-]
% length_GCM: �G���W���s�{�b�g�_����̏d�S�ʒu�x�N�g��[m](3x1)
% length_A: �G���W���s�{�b�g�_����̋�͒��S�_�ʒu�x�N�g��[m] (3x1)
% IXX,IYY,IZZ: �������[�����g[kgm2]
% IXXdot,IYYdot,IZZdot: �������[�����g�̎��ԕω�[kgm2/sec]
% azimth, elevation: �����p���̕��ʊp�A�p[deg]
% VWH:�@�������W�n�ɂ����Ă̕���(Up-East-North) [m/s] (3x1)
ROCKET = struct( ...
'm0', 300.0, ...
'Isp', 200, ...
'g0', 9.80665, ...
'FT', [7500], ...
'Tend', [4], ...
'At', 0.01, ...
'Area', 0.090, ...
'CLa', 3.5, ...
'azimth', 45, ...
'elevation', 88 ...
);

VWH = [0; 0; 0];

% ---- �p���V���[�g ----
% para_exist : �p���V���[�g�����邩�ǂ���[true,false]
% para_Cd: �p���V���[�g�R�͌W��[-]
% para_Dia: �p���V���[�g�J�P���̒��a[m]
% para_S: �p���V���[�g�ʐ�[m2]
para_exist = true;
para_Cd = 1.0;
para_Dia = 1.5;
time_parachute = 15;
para_S = para_Dia * para_Dia / 4 * pi;

% ---- ������������Ɏg����ԗʂ̏����� ----
% pos0: �˓_���S�������W�n�ɂ�����ʒu�iUp-East-North)[m] (3x1)
% vel0: �˓_���S�������W�n�ɂ����鑬�x[m/s] (3x1)
% quat0: �@�̍��W�n���琅�����W�n�ɕϊ���\���N�H�[�^�j�I��[-] (4x1)
% omega0: �@�̍��W�n�ɂ�����@�̂ɓ����p���x[rad/s] (3x1)
pos0 = [0.0; 0.0; 0.0]; % m
vel0 = [0.0; 0.0; 0.0]; % m/s
quat0 = attitude(ROCKET.azimth, ROCKET.elevation);
omega0 = [0.0; 0.0; 0.0]; % rad/s
x0 = [ROCKET.m0; pos0; vel0];


% ---- mapping�̂��߂̕ϐ� ----
% filename: output�t�H���_�ɏo�͂���KML,HTML�t�@�C���̃t�@�C����(string)
% launch_phi,lambda, h: �˓_�̈ܓx�o�x���x�A�x�\��[deg][deg][m]
% time_ref: ���ˎ���[HHMMSS.SS] ��. 12��34��56.78�b��123456.78
% day_ref: ���˓�[year, month, day] ��. 2014�N1��1����[2014, 1, 1]
% ---- �Q�l ----
% �\��F���C�x���g��3�͐Ϗ�˓_ [40.1408, 139.9860, 20]
% �ɓ��哇�������˓_ [34.731059, 139.415917, 465]
% ���V�Y�F����Ԋϑ����i�~���[�Z���^�[�j[31.251008, 131.082301]
filename = 'test';
launch_phi = 34.731059; % 43.5807
launch_lambda = 139.415917; % 142.002083
launch_h = 465; % 50
time_ref=123456.78;
day_ref = [2013, 10,1];
[xr, yr, zr] = blh2ecef(launch_phi, launch_lambda, launch_h);


