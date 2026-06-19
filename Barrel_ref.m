% Program Barrel_ref.m : Reference script with exact values 
%                        for the 3D BARREL SOLID (q = 2).
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

%% 1. DEFINITION OF EXACT NON-ZERO VALUES (SYMBOLIC FRACTIONS)

% --- J0 (Volume) ---
val_J0 = 27531/2500;

% --- J2 (Inertia Tensor) ---
val_J2_xx = 20114927937/6125000000;
val_J2_yy = 20114927937/6125000000;
val_J2_zz = 524799/70000;

% --- J4 (Rank 4) ---
val_J4_xxxx = 35859691661150979/19269250000000000;
val_J4_xxyy = 56329211035341/70070000000000;
val_J4_xxzz = 546324655473/269500000000;
val_J4_yyyy = 35859691661150979/19269250000000000;
val_J4_yyzz = 546324655473/269500000000;
val_J4_zzzz = 2713257/280000;

% --- J6 (Rank 6) ---
val_J6_xxxxxx = 39336875020086135762987/30417887500000000000000;
val_J6_xxxxyy = 481640894199573828219/1216715500000000000000;
val_J6_xxxxzz = 401378902189076997/385385000000000000;
val_J6_xxyyyy = 481640894199573828219/1216715500000000000000;
val_J6_xxyyzz = 630495016526763/1401400000000000;
val_J6_xxzzzz = 35056330327251/14014000000000;
val_J6_yyyyyy = 39336875020086135762987/30417887500000000000000;
val_J6_yyyyzz = 401378902189076997/385385000000000000;
val_J6_yyzzzz = 35056330327251/14014000000000;
val_J6_zzzzzz = 37439253/2464000;

%% 2. ASSEMBLY OF FULL SYMMETRIC TENSORS

% Odd-rank tensors (J1, J3, J5) are strictly zero matrices due to geometric symmetry.
J0ref = val_J0;
J1ref = zeros(3,1);

J2ref = zeros(3,3);
J2ref = fill_sym(J2ref, val_J2_xx, [1 1]);
J2ref = fill_sym(J2ref, val_J2_yy, [2 2]);
J2ref = fill_sym(J2ref, val_J2_zz, [3 3]);

J3ref = zeros(3,3,3);

J4ref = zeros(3,3,3,3);
J4ref = fill_sym(J4ref, val_J4_xxxx, [1 1 1 1]);
J4ref = fill_sym(J4ref, val_J4_xxyy, [1 1 2 2]);
J4ref = fill_sym(J4ref, val_J4_xxzz, [1 1 3 3]);
J4ref = fill_sym(J4ref, val_J4_yyyy, [2 2 2 2]);
J4ref = fill_sym(J4ref, val_J4_yyzz, [2 2 3 3]);
J4ref = fill_sym(J4ref, val_J4_zzzz, [3 3 3 3]);

J5ref = zeros(3,3,3,3,3);

J6ref = zeros(3,3,3,3,3,3);
J6ref = fill_sym(J6ref, val_J6_xxxxxx, [1 1 1 1 1 1]);
J6ref = fill_sym(J6ref, val_J6_xxxxyy, [1 1 1 1 2 2]);
J6ref = fill_sym(J6ref, val_J6_xxxxzz, [1 1 1 1 3 3]);
J6ref = fill_sym(J6ref, val_J6_xxyyyy, [1 1 2 2 2 2]);
J6ref = fill_sym(J6ref, val_J6_xxyyzz, [1 1 2 2 3 3]);
J6ref = fill_sym(J6ref, val_J6_xxzzzz, [1 1 3 3 3 3]);
J6ref = fill_sym(J6ref, val_J6_yyyyyy, [2 2 2 2 2 2]);
J6ref = fill_sym(J6ref, val_J6_yyyyzz, [2 2 2 2 3 3]);
J6ref = fill_sym(J6ref, val_J6_yyzzzz, [2 2 3 3 3 3]);
J6ref = fill_sym(J6ref, val_J6_zzzzzz, [3 3 3 3 3 3]);

%% 3. HELPER FUNCTION FOR TENSOR PERMUTATIONS
function T = fill_sym(T, val, idx)
    % Finds all unique permutations of the indices and populates the tensor
    p = unique(perms(idx), 'rows');
    for i = 1:size(p, 1)
        c = num2cell(p(i, :));
        T(c{:}) = val;
    end
end
