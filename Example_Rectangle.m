% Program Example_Rectangle.m : Exact computation of arbitrary-order moments
%                               for a polygonal domain (Rectangle, q=1).
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

clc; clear; close all;

%% 1. GEOMETRY DEFINITION (q = 1)
q = 1;

% Physical vertices of the rectangle (stored as column vectors)
rv_base = [
    0, 0;
    1, 0;
    1, 2;
    0, 2]'; 

%% 2. PRE-PROCESSING (BÉZIER CLOSURE)
% To close a Bézier domain, the last point of the last segment 
% must coincide with the first point of the first segment.
rv_closed = [rv_base, rv_base(:, 1)];
n_segments = size(rv_base, 2);

% Build the 'segments' struct: each element is an independent Bézier
% segment containing exactly q+1 points.
clear segments;
for i = 1 : n_segments
    segments(i).rv = rv_closed(:, i : i + q);
    segments(i).q  = q;
end

%% 3. COMPUTATION OF AREA MOMENTS
% Use the generalized Jk2D function for arbitrary order k
fprintf('Computing exact moments of area up to rank 6...\n');
J0 = Jk2D(segments, 0);
J1 = Jk2D(segments, 1);
J2 = Jk2D(segments, 2);
J3 = Jk2D(segments, 3);
J4 = Jk2D(segments, 4);
J5 = Jk2D(segments, 5);
J6 = Jk2D(segments, 6);

%% 4. ERROR EVALUATION
% Load exact symbolic reference values
try
    Rectangular_ref; % Ensure this script is in the same folder
    
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
    warning('Reference file "Rectangular_ref.m" not found. Skipping error computation.');
end
