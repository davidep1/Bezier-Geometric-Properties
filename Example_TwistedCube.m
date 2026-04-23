% Program Example_TwistedCube.m : Exact computation of arbitrary-order moments
%                                 of volume for a highly distorted 3D solid 
%                                 (Twisted Cube) bounded by Bézier surfaces.
%                                 Demonstrates exact 3D boundary integration 
%                                 under combined necking, torsion, and shear.
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

%% 1. VOLUMETRIC MACRO-ELEMENT CONSTRUCTION (3x3x3 Control Net)
qu = 2; 
qw = 2;

% Q contains the 27 global physical control points
Q = zeros(3, 3, 3, 3);
nodes = [-1, 0, 1]; 

for i = 1:3
    for j = 1:3
        for k = 1:3
            x = nodes(i); y = nodes(j); z = nodes(k);
            
            % Geometric Distortions: Necking, Torsion, Shear
            if k == 2
                x = x * 0.4; 
                y = y * 0.4; 
            end
            
            theta = z * (pi/4); 
            x_rot = x * cos(theta) - y * sin(theta);
            y_rot = x * sin(theta) + y * cos(theta);
            z_new = z;
            
            if k == 3
                z_new = z + 0.3 * x_rot; 
            end
            
            Q(:, i, j, k) = [x_rot; y_rot; z_new];
        end
    end
end

%% 2. EXTRACTION OF THE 6 FACES (Watertight Topology)
patch = struct('qu', cell(1,6), 'qw', cell(1,6), 'P', cell(1,6));
for s = 1:6
    patch(s).qu = qu; 
    patch(s).qw = qw; 
end

% Extract faces ensuring the normal vector (r_u x r_w) points outward
patch(1).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(1).P(:,u,w)=Q(:, w, u, 1); end, end
patch(2).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(2).P(:,u,w)=Q(:, u, w, 3); end, end
patch(3).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(3).P(:,u,w)=Q(:, u, 1, w); end, end
patch(4).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(4).P(:,u,w)=Q(:, w, 3, u); end, end
patch(5).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(5).P(:,u,w)=Q(:, 1, w, u); end, end
patch(6).P = zeros(3,3,3); for u=1:3, for w=1:3, patch(6).P(:,u,w)=Q(:, 3, u, w); end, end

%% 3. EXACT TENSORIAL COMPUTATION OF VOLUME MOMENTS
fprintf('Computing exact volume moments for the Twisted Cube...\n');
J0 = Jk3D(patch, 0);
J1 = Jk3D(patch, 1);
J2 = Jk3D(patch, 2);
J3 = Jk3D(patch, 3);
J4 = Jk3D(patch, 4);
J5 = Jk3D(patch, 5);
J6 = Jk3D(patch, 6);

%% 4. ERROR EVALUATION
try
    TwistedCube_ref; % Load exact symbolic reference values
    
    % Robust relative error function for N-D tensors (flattened with (:))
    calc_err = @(Jref, J) norm(Jref(:) - J(:)) / norm(Jref(:));

    eps0 = calc_err(J0ref, J0);
    eps1 = calc_err(J1ref, J1);
    eps2 = calc_err(J2ref, J2);
    
    fprintf('\n--- Relative Errors ---\n');
    fprintf('Rank 0: %.2e\n', eps0);
    fprintf('Rank 1: %.2e\n', eps1);
    fprintf('Rank 2: %.2e\n', eps2);
catch
    warning('Reference file "Twisted_ref.m" not found. Skipping error evaluation.');
end
