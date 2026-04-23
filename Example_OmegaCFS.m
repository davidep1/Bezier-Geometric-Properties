% Program Example_OmegaCFS.m : Exact computation of arbitrary-order moments
%                              for a complex Cold-Formed Steel (CFS) Omega
%                              cross-section with heterogeneous Bézier degrees
%                              (linear, quadratic, and cubic segments).
%                              Demonstrates exact modeling of rounded corners
%                              and stiffeners without polygonal approximation.
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

clc; clear; close all;

%% 1. PARAMETERS DEFINITION
H = 60;          
Web_W = 120;     
Lip_W = 20;      
t = 2.5;         
R = 4.0;         

% Derived Radii
R_concave = R;          
R_convex  = R + t;      

% Stiffener Centers
Center_S1 = 40;  
Center_S2 = 80;  

%% 2. GEOMETRY POINTS GENERATION
% --- 1. BASE PROFILE (OUTER) ---
O_LipL_Tip  = [-Lip_W; t];
O_LipL_End  = [-R_concave; t];
O_CornA_C   = [0; t];
O_CornA_End = [0; t + R_concave];
O_WebL_End  = [0; H - R_convex];
O_CornB_C   = [0; H];
O_CornB_End = [R_convex; H];

% --- 2. FIRST STIFFENER (x=40) - DEPTH EXCHANGE ---
Depth_Deep = 46;      
Depth_Shallow = 48.5; 

% A. OUTER POINTS
O_S1_Sh1_C = [35.5; 60];   
O_S1_Join1 = [35.5; 53.5]; 
O_S1_Start = [O_S1_Sh1_C(1) - 6.5; H]; 
O_S1_Belly_C1 = [35.5; Depth_Shallow]; 
O_S1_Belly_C2 = [44.5; Depth_Shallow]; 
O_S1_Join2    = [44.5; 53.5];
O_S1_Sh2_C    = [44.5; 60];
O_S1_End      = [O_S1_Sh2_C(1) + 6.5; H];

% B. INNER POINTS
I_S1_Sh1_C = [33; 57.5];   
I_S1_Join1 = [33; 53.5];   
I_S1_Start = O_S1_Start + [0; -t];
I_S1_Belly_C1 = [33; Depth_Deep]; 
I_S1_Belly_C2 = [47; Depth_Deep]; 
I_S1_Join2    = [47; 53.5];
I_S1_Sh2_C    = [47; 57.5];
I_S1_End      = O_S1_End + [0; -t];

% --- 3. SECOND STIFFENER (Translation to x=80) ---
dx = Center_S2 - Center_S1;

% Outer 2 (Rigid translation)
O_S2_Start    = O_S1_Start + [dx; 0];
O_S2_Sh1_C    = O_S1_Sh1_C + [dx; 0];
O_S2_Join1    = O_S1_Join1 + [dx; 0];
O_S2_Belly_C1 = O_S1_Belly_C1 + [dx; 0]; 
O_S2_Belly_C2 = O_S1_Belly_C2 + [dx; 0]; 
O_S2_Join2    = O_S1_Join2 + [dx; 0];
O_S2_Sh2_C    = O_S1_Sh2_C + [dx; 0];
O_S2_End      = O_S1_End + [dx; 0];

% Inner 2
I_S2_Start    = I_S1_Start + [dx; 0];
I_S2_Sh1_C    = I_S1_Sh1_C + [dx; 0];
I_S2_Join1    = I_S1_Join1 + [dx; 0];
I_S2_Belly_C1 = I_S1_Belly_C1 + [dx; 0];
I_S2_Belly_C2 = I_S1_Belly_C2 + [dx; 0];
I_S2_Join2    = I_S1_Join2 + [dx; 0];
I_S2_Sh2_C    = I_S1_Sh2_C + [dx; 0];
I_S2_End      = I_S1_End + [dx; 0];

% --- 4. REMAINING POINTS (PROFILE CLOSURE) ---
O_Flat3_End = [Web_W - R_convex; H];
O_CornC_C   = [Web_W; H];
O_CornC_End = [Web_W; H - R_convex];
O_WebR_End  = [Web_W; t + R_concave];
O_CornD_C   = [Web_W; t];
O_CornD_End = [Web_W + R_concave; t];
O_LipR_Tip  = [Web_W + Lip_W; t];

% Inner Points
I_LipR_Tip  = [Web_W + Lip_W; 0];
I_LipR_End  = [Web_W - t + R_convex; 0]; 
I_CornD_C   = [Web_W - t; 0];
I_CornD_End = [Web_W - t; R_convex];
I_WebR_End  = [Web_W - t; H - t - R_concave];
I_CornC_C   = [Web_W - t; H - t];
I_CornC_End = [Web_W - t - R_concave; H - t];
I_Flat3_Start = I_CornC_End;
I_CornB_End   = [t; H - t - R_concave];
I_CornB_C     = [t; H - t];
I_CornB_Start = [t + R_concave; H - t];
I_WebL_End    = [t; R_convex];
I_CornA_C     = [t; 0];
I_CornA_End   = [t - R_convex; 0];
I_LipL_Tip    = [-Lip_W; 0];

%% 3. SEGMENTS CONSTRUCTION (CCW Order: Bottom L->R, then Top R->L)
Idx = 1;
clear segments;

% =========================================================
% LOOP 1: BOTTOM SURFACE (Inner Vars I_) -> TRAVERSE LEFT TO RIGHT
% =========================================================
segments(Idx).rv = [I_LipL_Tip, I_CornA_End]; segments(Idx).q=1; Idx=Idx+1;
segments(Idx).rv = [I_CornA_End, I_CornA_C, I_WebL_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [I_WebL_End, I_CornB_End]; segments(Idx).q=1; Idx=Idx+1;
segments(Idx).rv = [I_CornB_End, I_CornB_C, I_CornB_Start]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [I_CornB_Start, I_S1_Start]; segments(Idx).q=1; Idx=Idx+1;
% Stiffener 1 Bottom
segments(Idx).rv = [I_S1_Start, I_S1_Sh1_C, I_S1_Join1]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [I_S1_Join1, I_S1_Belly_C1, I_S1_Belly_C2, I_S1_Join2]; segments(Idx).q=3; Idx=Idx+1;
segments(Idx).rv = [I_S1_Join2, I_S1_Sh2_C, I_S1_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [I_S1_End, I_S2_Start]; segments(Idx).q=1; Idx=Idx+1;
% Stiffener 2 Bottom
segments(Idx).rv = [I_S2_Start, I_S2_Sh1_C, I_S2_Join1]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [I_S2_Join1, I_S2_Belly_C1, I_S2_Belly_C2, I_S2_Join2]; segments(Idx).q=3; Idx=Idx+1;
segments(Idx).rv = [I_S2_Join2, I_S2_Sh2_C, I_S2_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [I_S2_End, I_Flat3_Start]; segments(Idx).q=1; Idx=Idx+1;
segments(Idx).rv = [I_Flat3_Start, I_CornC_C, I_WebR_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [I_WebR_End, I_CornD_End]; segments(Idx).q=1; Idx=Idx+1;
segments(Idx).rv = [I_CornD_End, I_CornD_C, I_LipR_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [I_LipR_End, I_LipR_Tip]; segments(Idx).q=1; Idx=Idx+1;

% =========================================================
% RIGHT TIP 
% =========================================================
segments(Idx).rv = [I_LipR_Tip, O_LipR_Tip]; segments(Idx).q=1; Idx=Idx+1;

% =========================================================
% LOOP 2: TOP SURFACE (Outer Vars O_) -> TRAVERSE RIGHT TO LEFT
% =========================================================
segments(Idx).rv = [O_LipR_Tip, O_CornD_End]; segments(Idx).q=1; Idx=Idx+1;
segments(Idx).rv = [O_CornD_End, O_CornD_C, O_WebR_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [O_WebR_End, O_CornC_End]; segments(Idx).q=1; Idx=Idx+1;
segments(Idx).rv = [O_CornC_End, O_CornC_C, O_Flat3_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [O_Flat3_End, O_S2_End]; segments(Idx).q=1; Idx=Idx+1;
% Stiffener 2 Top 
segments(Idx).rv = [O_S2_End, O_S2_Sh2_C, O_S2_Join2]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [O_S2_Join2, O_S2_Belly_C2, O_S2_Belly_C1, O_S2_Join1]; segments(Idx).q=3; Idx=Idx+1;
segments(Idx).rv = [O_S2_Join1, O_S2_Sh1_C, O_S2_Start]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [O_S2_Start, O_S1_End]; segments(Idx).q=1; Idx=Idx+1;
% Stiffener 1 Top 
segments(Idx).rv = [O_S1_End, O_S1_Sh2_C, O_S1_Join2]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [O_S1_Join2, O_S1_Belly_C2, O_S1_Belly_C1, O_S1_Join1]; segments(Idx).q=3; Idx=Idx+1;
segments(Idx).rv = [O_S1_Join1, O_S1_Sh1_C, O_S1_Start]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [O_S1_Start, O_CornB_End]; segments(Idx).q=1; Idx=Idx+1;
segments(Idx).rv = [O_CornB_End, O_CornB_C, O_WebL_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [O_WebL_End, O_CornA_End]; segments(Idx).q=1; Idx=Idx+1;
segments(Idx).rv = [O_CornA_End, O_CornA_C, O_LipL_End]; segments(Idx).q=2; Idx=Idx+1;
segments(Idx).rv = [O_LipL_End, O_LipL_Tip]; segments(Idx).q=1; Idx=Idx+1;

% =========================================================
% LEFT TIP - CLOSURE
% =========================================================
segments(Idx).rv = [O_LipL_Tip, I_LipL_Tip]; segments(Idx).q=1; 

%% 4. COMPUTATION OF AREA MOMENTS (Bézier Framework)
% NOTE: Bézier curves naturally interpolate endpoints, ensuring C0 
% continuity between adjacent segments by design.
fprintf('Computing exact area moments for the CFS Omega section...\n');
J0 = Jk2D(segments, 0);
J1 = Jk2D(segments, 1);
J2 = Jk2D(segments, 2);
J3 = Jk2D(segments, 3);
J4 = Jk2D(segments, 4);
J5 = Jk2D(segments, 5);
J6 = Jk2D(segments, 6);

%% 5. ERROR EVALUATION
try
    OmegaCFS_ref;
    
    % Robust relative error function for N-D tensors (flattened with (:))
    calc_err = @(Jref, J) norm(Jref(:) - J(:)) / norm(Jref(:));

    eps0 = calc_err(J0ref, J0);
    eps1 = calc_err(J1ref, J1);
    eps2 = calc_err(J2ref, J2);
    eps3 = calc_err(J3ref, J3);
    eps4 = calc_err(J4ref, J4);
    eps5 = calc_err(J5ref, J5);
    eps6 = calc_err(J6ref, J6);
    
    fprintf('\n--- Relative Errors ---\n');
    fprintf('Rank 0: %.2e\n', eps0);
    fprintf('Rank 1: %.2e\n', eps1);
    fprintf('Rank 2: %.2e\n', eps2);
    fprintf('Rank 3: %.2e\n', eps3);
    fprintf('Rank 4: %.2e\n', eps4);
    fprintf('Rank 5: %.2e\n', eps5);
    fprintf('Rank 6: %.2e\n', eps6);
catch
    warning('Reference file "OmegaCFS_ref.m" not found. Skipping error evaluation.');
end
