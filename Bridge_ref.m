% Program Bridge_ref.m : Reference script with exact values 
%                        for the BRIDGE PROFILE (q = 1).
%                        Values obtained via exact symbolic integration.
%
% Developed by:
%   Davide Pellecchia   (davide.pellecchia@unina.it);
%   Francesco Marmo     (f.marmo@unina.it);
%   Luciano Rosati      (rosati@unina.it);
%
% REFERENCE:
% D. Pellecchia, F. Marmo, L. Rosati. "Evaluation of high-order moments
% for plane and solid closed domains bounded by arbitrary-degree Bézier
% curves and surfaces". Submitted for publication, 2026.
%
% NOTE: THIS SCRIPT IS INTENDED TO BE CALLED FROM THE MAIN EXAMPLE FILE.

%% 1. UNIQUE VALUES DEFINITION (EXACT SYMBOLIC FRACTIONS)

% --- J0 (Area) ---
val_J0 = 219/10;

% --- J1 (Static Moments) ---
val_J1_x = 0;
val_J1_y = 4771/150;

% --- J2 (Inertia Tensor) ---
val_J2_xx = 4639/48;
val_J2_xy = 0;
val_J2_yy = 28339/500;

% --- J3 (Rank 3) ---
val_J3_30 = 0;                  % Jxxx (Symmetry)
val_J3_21 = 111847/600;         % Jxxy
val_J3_12 = 0;                  % Jxyy (Symmetry)
val_J3_03 = 1113551/10000;      % Jyyy

% --- J4 (Rank 4) ---
val_J4_40 = 3337819/2400;       % Jxxxx
val_J4_31 = 0;                  % Jxxxy (Symmetry)
val_J4_22 = 23657731/60000;     % Jxxyy
val_J4_13 = 0;                  % Jxyyy (Symmetry)
val_J4_04 = 57944629/250000;    % Jyyyy

% --- J5 (Rank 5) ---
val_J5_50 = 0;                  % Jxxxxx (Symmetry)
val_J5_41 = 9197663/3000;       % Jxxxxy
val_J5_32 = 0;                  % Jxxxyy (Symmetry)
val_J5_23 = 1214493257/1400000; % Jxxyyy
val_J5_14 = 0;                  % Jxyyyy (Symmetry)
val_J5_05 = 187827427/375000;   % Jyyyyy

% --- J6 (Rank 6) ---
val_J6_60 = 110423391/3584;         % Jxxxxxx
val_J6_51 = 0;                      % Jxxxxxy (Symmetry)
val_J6_42 = 3886825947/560000;      % Jxxxxyy
val_J6_33 = 0;                      % Jxxxyyy (Symmetry)
val_J6_24 = 27314318113/14000000;   % Jxxyyyy
val_J6_15 = 0;                      % Jxyyyyy (Symmetry)
val_J6_06 = 77761196427/70000000;   % Jyyyyyy

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
