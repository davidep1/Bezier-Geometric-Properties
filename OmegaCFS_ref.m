% Program OmegaCFS_ref.m : Reference script with exact values 
%                       for the CFS OMEGA PROFILE (Mixed Bézier Degrees).
%                       Values obtained via exact symbolic integration.
%
% Developed by:
%   Davide Pellecchia   (davide.pellecchia@unina.it);
%   Francesco Marmo     (f.marmo@unina.it);
%   Luciano Rosati      (rosati@unina.it);
%
% REFERENCE:
% D. Pellecchia, L. Rosati, F. Marmo. "Evaluation of high-order moments
% for plane and solid closed domains bounded by arbitrary-degree Bézier
% curves and surfaces". Submitted for publication, 2026.
%
% NOTE: THIS SCRIPT IS INTENDED TO BE CALLED FROM THE MAIN EXAMPLE FILE.

%% 1. UNIQUE VALUES DEFINITION (EXACT SYMBOLIC FRACTIONS)

% --- J0 (Area) ---
val_J0 = 1439/2;

% --- J1 (Static Moments) ---
val_J1_x = 43170;
val_J1_y = 4645759/168;

% --- J2 (Inertia Tensor) ---
val_J2_xx = 16252880075/3696;
val_J2_xy = 23228795/14;
val_J2_yy = 29612444/21;

% --- J3 (Rank 3) ---
val_J3_30 = 148059409125/308;        % Jxxx (J111)
val_J3_21 = 85878982035211/576576;   % Jxxy (J112, J121, J211)
val_J3_12 = 592248880/7;             % Jxyy (J122, J212, J221)
val_J3_03 = 306015998429/4032;       % Jyyy (J222)

% --- J4 (Rank 4) ---
val_J4_40 = 268913792968839397/4900896;   % Jxxxx
val_J4_31 = 238063971520055/16016;        % Jxxxy
val_J4_22 = 2822427501008081/384384;      % Jxxyy
val_J4_13 = 1530079992145/336;            % Jxyyy
val_J4_04 = 109622154527609/26208;        % Jyyyy

% --- J5 (Rank 5) ---
val_J5_50 = 374332661078369275/58344;          % Jxxxxx
val_J5_41 = 44885290051406587337/28651392;     % Jxxxxy
val_J5_32 = 3260495745140745/4576;             % Jxxxyy
val_J5_23 = 2174907371439523439/5601024;       % Jxxyyy
val_J5_14 = 548110772638045/2184;              % Jxyyyy
val_J5_05 = 1749826953704761/7488;             % Jyyyyy

% --- J6 (Rank 6) ---
val_J6_60 = 26129648205166672807856269/34267064832;  % Jxxxxxx
val_J6_51 = 5294724747119917124525/31039008;         % Jxxxxxy
val_J6_42 = 8403219828289346781367/114605568;        % Jxxxxyy
val_J6_33 = 40413363175700168365/1089088;            % Jxxxyyy
val_J6_24 = 375482743885256319365/17736576;          % Jxxyyyy
val_J6_15 = 8749134768523805/624;                    % Jxyyyyy
val_J6_06 = 39730777838165243411/3015936;            % Jyyyyyy

%% 2. MANUAL ASSIGNMENT OF FULL TENSORS

% ================= J0 =================
J0ref = val_J0;

% ================= J1 =================
J1ref = zeros(2,1);
J1ref(1) = val_J1_x;
J1ref(2) = val_J1_y;

% ================= J2 =================
J2ref = zeros(2,2);
J2ref(1,1) = val_J2_xx;
J2ref(1,2) = val_J2_xy;
J2ref(2,1) = val_J2_xy;
J2ref(2,2) = val_J2_yy;

% ================= J3 =================
J3ref = zeros(2,2,2);
% 3x (1 perm)
J3ref(1,1,1) = val_J3_30;
% 2x, 1y (3 perms)
J3ref(1,1,2) = val_J3_21;
J3ref(1,2,1) = val_J3_21;
J3ref(2,1,1) = val_J3_21;
% 1x, 2y (3 perms)
J3ref(1,2,2) = val_J3_12;
J3ref(2,1,2) = val_J3_12;
J3ref(2,2,1) = val_J3_12;
% 3y (1 perm)
J3ref(2,2,2) = val_J3_03;

% ================= J4 =================
J4ref = zeros(2,2,2,2);
% 4x (1 perm)
J4ref(1,1,1,1) = val_J4_40;
% 3x, 1y (4 perms)
J4ref(1,1,1,2) = val_J4_31;
J4ref(1,1,2,1) = val_J4_31;
J4ref(1,2,1,1) = val_J4_31;
J4ref(2,1,1,1) = val_J4_31;
% 2x, 2y (6 perms)
J4ref(1,1,2,2) = val_J4_22;
J4ref(1,2,1,2) = val_J4_22;
J4ref(1,2,2,1) = val_J4_22;
J4ref(2,1,1,2) = val_J4_22;
J4ref(2,1,2,1) = val_J4_22;
J4ref(2,2,1,1) = val_J4_22;
% 1x, 3y (4 perms)
J4ref(1,2,2,2) = val_J4_13;
J4ref(2,1,2,2) = val_J4_13;
J4ref(2,2,1,2) = val_J4_13;
J4ref(2,2,2,1) = val_J4_13;
% 4y (1 perm)
J4ref(2,2,2,2) = val_J4_04;

% ================= J5 =================
J5ref = zeros(2,2,2,2,2);
% 5x (1 perm)
J5ref(1,1,1,1,1) = val_J5_50;
% 4x, 1y (5 perms)
J5ref(1,1,1,1,2) = val_J5_41;
J5ref(1,1,1,2,1) = val_J5_41;
J5ref(1,1,2,1,1) = val_J5_41;
J5ref(1,2,1,1,1) = val_J5_41;
J5ref(2,1,1,1,1) = val_J5_41;
% 3x, 2y (10 perms)
J5ref(1,1,1,2,2) = val_J5_32;
J5ref(1,1,2,1,2) = val_J5_32;
J5ref(1,1,2,2,1) = val_J5_32;
J5ref(1,2,1,1,2) = val_J5_32;
J5ref(1,2,1,2,1) = val_J5_32;
J5ref(1,2,2,1,1) = val_J5_32;
J5ref(2,1,1,1,2) = val_J5_32;
J5ref(2,1,1,2,1) = val_J5_32;
J5ref(2,1,2,1,1) = val_J5_32;
J5ref(2,2,1,1,1) = val_J5_32;
% 2x, 3y (10 perms)
J5ref(1,1,2,2,2) = val_J5_23;
J5ref(1,2,1,2,2) = val_J5_23;
J5ref(1,2,2,1,2) = val_J5_23;
J5ref(1,2,2,2,1) = val_J5_23;
J5ref(2,1,1,2,2) = val_J5_23;
J5ref(2,1,2,1,2) = val_J5_23;
J5ref(2,1,2,2,1) = val_J5_23;
J5ref(2,2,1,1,2) = val_J5_23;
J5ref(2,2,1,2,1) = val_J5_23;
J5ref(2,2,2,1,1) = val_J5_23;
% 1x, 4y (5 perms)
J5ref(1,2,2,2,2) = val_J5_14;
J5ref(2,1,2,2,2) = val_J5_14;
J5ref(2,2,1,2,2) = val_J5_14;
J5ref(2,2,2,1,2) = val_J5_14;
J5ref(2,2,2,2,1) = val_J5_14;
% 5y (1 perm)
J5ref(2,2,2,2,2) = val_J5_05;

% ================= J6 =================
J6ref = zeros(2,2,2,2,2,2);
% 6x (1 perm)
J6ref(1,1,1,1,1,1) = val_J6_60;
% 5x, 1y (6 perms)
J6ref(1,1,1,1,1,2) = val_J6_51;
J6ref(1,1,1,1,2,1) = val_J6_51;
J6ref(1,1,1,2,1,1) = val_J6_51;
J6ref(1,1,2,1,1,1) = val_J6_51;
J6ref(1,2,1,1,1,1) = val_J6_51;
J6ref(2,1,1,1,1,1) = val_J6_51;
% 4x, 2y (15 perms)
J6ref(1,1,1,1,2,2) = val_J6_42;
J6ref(1,1,1,2,1,2) = val_J6_42;
J6ref(1,1,1,2,2,1) = val_J6_42;
J6ref(1,1,2,1,1,2) = val_J6_42;
J6ref(1,1,2,1,2,1) = val_J6_42;
J6ref(1,1,2,2,1,1) = val_J6_42;
J6ref(1,2,1,1,1,2) = val_J6_42;
J6ref(1,2,1,1,2,1) = val_J6_42;
J6ref(1,2,1,2,1,1) = val_J6_42;
J6ref(1,2,2,1,1,1) = val_J6_42;
J6ref(2,1,1,1,1,2) = val_J6_42;
J6ref(2,1,1,1,2,1) = val_J6_42;
J6ref(2,1,1,2,1,1) = val_J6_42;
J6ref(2,1,2,1,1,1) = val_J6_42;
J6ref(2,2,1,1,1,1) = val_J6_42;
% 3x, 3y (20 perms)
J6ref(1,1,1,2,2,2) = val_J6_33;
J6ref(1,1,2,1,2,2) = val_J6_33;
J6ref(1,1,2,2,1,2) = val_J6_33;
J6ref(1,1,2,2,2,1) = val_J6_33;
J6ref(1,2,1,1,2,2) = val_J6_33;
J6ref(1,2,1,2,1,2) = val_J6_33;
J6ref(1,2,1,2,2,1) = val_J6_33;
J6ref(1,2,2,1,1,2) = val_J6_33;
J6ref(1,2,2,1,2,1) = val_J6_33;
J6ref(1,2,2,2,1,1) = val_J6_33;
J6ref(2,1,1,1,2,2) = val_J6_33;
J6ref(2,1,1,2,1,2) = val_J6_33;
J6ref(2,1,1,2,2,1) = val_J6_33;
J6ref(2,1,2,1,1,2) = val_J6_33;
J6ref(2,1,2,1,2,1) = val_J6_33;
J6ref(2,1,2,2,1,1) = val_J6_33;
J6ref(2,2,1,1,1,2) = val_J6_33;
J6ref(2,2,1,1,2,1) = val_J6_33;
J6ref(2,2,1,2,1,1) = val_J6_33;
J6ref(2,2,2,1,1,1) = val_J6_33;
% 2x, 4y (15 perms)
J6ref(1,1,2,2,2,2) = val_J6_24;
J6ref(1,2,1,2,2,2) = val_J6_24;
J6ref(1,2,2,1,2,2) = val_J6_24;
J6ref(1,2,2,2,1,2) = val_J6_24;
J6ref(1,2,2,2,2,1) = val_J6_24;
J6ref(2,1,1,2,2,2) = val_J6_24;
J6ref(2,1,2,1,2,2) = val_J6_24;
J6ref(2,1,2,2,1,2) = val_J6_24;
J6ref(2,1,2,2,2,1) = val_J6_24;
J6ref(2,2,1,1,2,2) = val_J6_24;
J6ref(2,2,1,2,1,2) = val_J6_24;
J6ref(2,2,1,2,2,1) = val_J6_24;
J6ref(2,2,2,1,1,2) = val_J6_24;
J6ref(2,2,2,1,2,1) = val_J6_24;
J6ref(2,2,2,2,1,1) = val_J6_24;
% 1x, 5y (6 perms)
J6ref(1,2,2,2,2,2) = val_J6_15;
J6ref(2,1,2,2,2,2) = val_J6_15;
J6ref(2,2,1,2,2,2) = val_J6_15;
J6ref(2,2,2,1,2,2) = val_J6_15;
J6ref(2,2,2,2,1,2) = val_J6_15;
J6ref(2,2,2,2,2,1) = val_J6_15;
% 6y (1 perm)
J6ref(2,2,2,2,2,2) = val_J6_06;
