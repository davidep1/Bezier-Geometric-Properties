% Program Example_Bridge.m : Exact computation of arbitrary-order moments
%                            for a polygonal bridge deck with a hollow core (q=1).
%                            Demonstrates the "cut-line" technique for multiply 
%                            connected domains using a single continuous path.
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

%% 1. GEOMETRY DEFINITION (q = 1)
q  = 1;
np = 50; % Number of points for plotting evaluation

% BRIDGE DECK WITH HOLLOW CORE (Single Path)
% "Cut-line" technique: Exterior CCW -> Cut -> Interior CW -> Return -> Exterior CCW
rv = [
    % --- RIGHT EXTERIOR (Counter-Clockwise) ---
     2.0,  0.0;   % 1. Right Outer Base
     3.5,  2.0;   % 2. Right Lower Parapet
     6.0,  2.2;   % 3. Right Lower Wing Tip
     6.0,  2.5;   % 4. Right Upper Wing Tip
     
    % --- CUT-IN (Entry to inner void) ---
     0.0,  2.6;   % 5. Road Center (Cut start)
     0.0,  2.0;   % 6. Inner Ceiling (Cut end)
     
    % --- INTERNAL PROFILE (Clockwise) ---
    -2.0,  1.7;   % 7. Inner Upper Left Corner
    -1.5,  0.5;   % 8. Inner Lower Left Corner
     1.5,  0.5;   % 9. Inner Lower Right Corner
     2.0,  1.7;   % 10. Inner Upper Right Corner
     0.0,  2.0;   % 11. Return to Inner Ceiling
     
    % --- CUT-OUT (Exit from inner void) ---
     0.0,  2.6;   % 12. Return to Road Center
     
    % --- LEFT EXTERIOR (Counter-Clockwise) ---
    -6.0,  2.5;   % 13. Left Upper Wing Tip
    -6.0,  2.2;   % 14. Left Lower Wing Tip
    -3.5,  2.0;   % 15. Left Lower Parapet
    -2.0,  0.0;   % 16. Left Outer Base
];

rv_base = rv'; 

%% 2. PRE-PROCESSING (BÉZIER CLOSURE)
% To close a Bézier domain, we append the FIRST point to the end of the array.
rv_closed = [rv_base, rv_base(:, 1)];

% Exact calculation of the number of segments based on the polynomial degree
n_segments = (size(rv_closed, 2) - 1) / q;

% Build the 'segments' struct: each element is an independent Bézier
% segment containing exactly q+1 points, ensuring C0 continuity at joints.
clear segments;
for i = 1 : n_segments
    idx_start = (i - 1) * q + 1;
    segments(i).rv = rv_closed(:, idx_start : idx_start + q);
    segments(i).q  = q;
end

%% 3. COMPUTATION OF AREA MOMENTS (Bernstein/Power Basis)
fprintf('Computing exact area moments for the bridge cross-section...\n');
J0 = Jk2D(segments, 0);
J1 = Jk2D(segments, 1);
J2 = Jk2D(segments, 2);
J3 = Jk2D(segments, 3);
J4 = Jk2D(segments, 4);
J5 = Jk2D(segments, 5);
J6 = Jk2D(segments, 6);

%% 4. ERROR EVALUATION
% Requires the reference script 'Bridge_ref.m'
try
    Bridge_ref;
    
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
    warning('Reference file "Bridge_ref.m" not found. Calculations completed, skipping error evaluation.');
end
