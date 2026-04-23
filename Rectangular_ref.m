% Program Rectangular_ref.m : Reference script with exact values 
%                             for the RECTANGULAR SECTION (q = 1).
%                             Values obtained via exact symbolic integration.
%
% Developed by:
%   Davide Pellecchia   (davide.pellecchia@unina.it);
%   Luciano Rosati      (rosati@unina.it);
%   Francesco Marmo     (f.marmo@unina.it);
%
% REFERENCE:
% D. Pellecchia, L. Rosati, F. Marmo. "Evaluation of high-order moments
% for plane and solid closed domains bounded by arbitrary-degree Bézier
% curves and surfaces". Submitted for publication, 2026.
%
% NOTE: THIS SCRIPT IS INTENDED TO BE CALLED FROM THE MAIN EXAMPLE FILE.

%% 1. UNIQUE VALUES DEFINITION (EXACT SYMBOLIC FRACTIONS)

% --- J0 (Area) ---
val_J0 = 2;

% --- J1 (Static Moments) ---
val_J1_x = 1;
val_J1_y = 2;

% --- J2 (Inertia Tensor) ---
val_J2_xx = 2/3;
val_J2_xy = 1;
val_J2_yy = 8/3;

% --- J3 (Rank 3) ---
val_J3_30 = 1/2;      % Jxxx
val_J3_21 = 2/3;      % Jxxy
val_J3_12 = 4/3;      % Jxyy
val_J3_03 = 4;        % Jyyy

% --- J4 (Rank 4) ---
val_J4_40 = 2/5;      % Jxxxx
val_J4_31 = 1/2;      % Jxxxy
val_J4_22 = 8/9;      % Jxxyy
val_J4_13 = 2;        % Jxyyy
val_J4_04 = 32/5;     % Jyyyy

% --- J5 (Rank 5) ---
val_J5_50 = 1/3;      % Jxxxxx
val_J5_41 = 2/5;      % Jxxxxy
val_J5_32 = 2/3;      % Jxxxyy
val_J5_23 = 4/3;      % Jxxyyy
val_J5_14 = 16/5;     % Jxyyyy
val_J5_05 = 32/3;     % Jyyyyy

% --- J6 (Rank 6) ---
val_J6_60 = 2/7;      % Jxxxxxx
val_J6_51 = 1/3;      % Jxxxxxy
val_J6_42 = 8/15;     % Jxxxxyy
val_J6_33 = 1;        % Jxxxyyy
val_J6_24 = 32/15;    % Jxxyyyy
val_J6_15 = 16/3;     % Jxyyyyy
val_J6_06 = 128/7;    % Jyyyyyy

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
J6ref(2,2,1,1,1,1) = val_