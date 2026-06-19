% Program Example_Barrel.m : Exact computation of arbitrary-order moments
%                            of volume for a highly distorted 3D solid 
%                            (Barrel) bounded by quadratic Bézier surfaces.
%                            Demonstrates exact 3D boundary integration 
%                            without internal volume meshing.
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

%% 1. BARREL MACRO-ELEMENT CONSTRUCTION (3x3x3 Control Net)
qu = 2; 
qw = 2;
Q = zeros(3, 3, 3, 3);
nodes = [-1, 0, 1]; 

for i = 1:3
    for j = 1:3
        for k = 1:3
            x = nodes(i); y = nodes(j); z = nodes(k);
            
            % A. Cross-section rounding (from square to quasi-circle)
            if abs(x) == 1 && abs(y) == 1
                % Pull corners inward
                x = x * 0.75; 
                y = y * 0.75;
            elseif (abs(x) == 1 && y == 0) || (abs(y) == 1 && x == 0)
                % Push midpoints outward
                x = x * 1.05;
                y = y * 1.05;
            end
            
            % B. "Barrel" Effect (Equatorial bulging at k=2)
            if k == 2
                x = x * 1.4;
                y = y * 1.4;
            end
            
            % C. Axial elongation
            z = z * 1.5;
            
            % Store deformed control points
            Q(:, i, j, k) = [x; y; z];
        end
    end
end

%% 2. EXTRACTION OF THE 6 FACES (Watertight Topology)
patch = struct('qu', cell(1,6), 'qw', cell(1,6), 'P', cell(1,6));
for s = 1:6
    patch(s).qu = qu; 
    patch(s).qw = qw; 
end

% Face 1 (Bottom), Face 2 (Top)
patch(1).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(1).P(:,u,w)=Q(:, w, u, 1); end, end
patch(2).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(2).P(:,u,w)=Q(:, u, w, 3); end, end

% Faces 3, 4, 5, 6 (Curved lateral surface of the barrel)
patch(3).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(3).P(:,u,w)=Q(:, u, 1, w); end, end
patch(4).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(4).P(:,u,w)=Q(:, w, 3, u); end, end
patch(5).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(5).P(:,u,w)=Q(:, 1, w, u); end, end
patch(6).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(6).P(:,u,w)=Q(:, 3, u, w); end, end

%% 3. EXACT TENSORIAL COMPUTATION OF VOLUME MOMENTS
fprintf('Computing exact volume moments for the 3D Barrel solid...\n');
J0 = Jk3D(patch, 0);
J1 = Jk3D(patch, 1);
J2 = Jk3D(patch, 2);
J3 = Jk3D(patch, 3);
J4 = Jk3D(patch, 4);
J5 = Jk3D(patch, 5);
J6 = Jk3D(patch, 6);

%% 4. ERROR EVALUATION
try
    Barrel_ref; % Load exact symbolic reference values
    
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
    warning('Reference file "Barrel_ref.m" not found. Skipping error evaluation.');
end
