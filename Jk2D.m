% Program Jk2D.m : Exact computation of arbitrary-order moments of area
%                  for closed 2D domains bounded by Bézier curves.
%                  Supports mixed-degree boundaries via struct input.
%
% Developed by:
%   Davide Pellecchia   (davide.pellecchia@unina.it);
%   Francesco Marmo     (f.marmo@unina.it);
%   Luciano Rosati      (rosati@unina.it);
%
% Department of Structures for Engineering and Architecture,
% University of Naples Federico II, Italy.
%
% REFERENCE:
% If you use this code in your research, please cite the following paper:
% D. Pellecchia, F. Marmo, L. Rosati. "Evaluation of high-order moments
% for plane and solid closed domains bounded by arbitrary-degree Bézier
% curves and surfaces". Submitted for publication XXXXX, 2026.
%
% INPUT:
% segments = Struct array containing the pre-processed boundary geometry:
%            .rv -> Control points matrix (2 x No. of control points)
%            .q  -> Bézier segment degree (scalar)
% k        = General order of the moments of area (integer k >= 0);
%
% OUTPUT:
% Jk = Exact k-th order moment of area tensor;
%   J0 = Area           (setting k = 0, returns a scalar);
%   J1 = Static moment  (setting k = 1, returns a 2x1 vector);
%   J2 = Inertia tensor (setting k = 2, returns a 2x2 matrix);
%   ... and so on for higher orders.

function Jk = Jk2D(segments, k)
    if ~isstruct(segments) || ~isfield(segments, 'rv') || ~isfield(segments, 'q')
        error('Input must be a struct array with fields .rv and .q');
    end
    nsegments = length(segments);
    
    % Initialization of the output tensor Jk
    if k == 0
        Jk = 0;
    elseif k == 1
        Jk = zeros(2, 1);
    else
        dims = repmat(2, 1, k);
        Jk = zeros(dims);
    end
    
    % 90-degree rotation matrix for the 2D cross product
    R = [0, 1; -1, 0]; 
    
    for c = 1 : nsegments
        rv = segments(c).rv;
        q  = segments(c).q;
        
        % Ensure control points are stored as column vectors (2 x n)
        if size(rv, 1) ~= 2 && size(rv, 2) == 2
            rv = rv';
        end
        
        % Evaluate constant matrices depending only on the polynomial degree q
        H = BezierMatrix(q);           % Transformation matrix to power basis
        T = BezierTangentMatrix(H, q); % Derivative matrix in power basis
        L = PowerBasisMatrix(k + 2, q);% Exact analytical integration tensor
        
        [~, n_points] = size(rv);
        ns = n_points - q;
        
        if ns < 1
            error('Error in Curve %d: Insufficient points (%d) for degree %d.', c, n_points, q);
        end
        
        for i = 1 : ns
            % Extract control points of the current Bézier patch
            B = rv(:, i : i + q);
            
            % Map control points to the power basis
            D = B * H;
            
            % Compute the cross-product matrix in the power basis
            M = H' * B' * (R * B) * T;
            
            % Contract integration tensor L with cross-product matrix M
            LM = tensorprod(L, M, [1 2], [1 2]);
            
            % Compute the final tensor term based on the geometric rank k
            if k == 0
                term = LM;
            else
                % Construct the k-th order tensor product of D
                Dtk = D;
                for j = 2 : k
                    Dtk = tensorprod(Dtk, D, [], []); 
                end
                
                % Contract Dtk with LM
                indD  = 2 : 2 : (2 * k); % Polynomial indices of D corresponding to even positions
                indLM = 1 : k;           % Polynomial indices of LM
                
                term = tensorprod(Dtk, LM, indD, indLM);
            end
            
            % Accumulate the contribution to the global moment tensor
            Jk = Jk + term;
        end
    end
    
    % Final scaling according to the divergence theorem (boundary reduction)
    Jk = Jk / (k + 2);
end

%% SUB-FUNCTIONS

function L = PowerBasisMatrix(order, p)
    % Evaluates the exact integration tensor over the parametric domain [0, 1]
    
    base_powers = p : -1 : 0; 
    args = repmat({1 : p + 1}, 1, order);
    
    if order == 1
        L = 1 ./ (base_powers' + 1);
        return
    end
    
    G = cell(1, order);
    [G{:}] = ndgrid(args{:});
    
    TotalPower = zeros(size(G{1}));
    for i = 1 : order
        TotalPower = TotalPower + base_powers(G{i});
    end
    
    L = 1 ./ (TotalPower + 1);
end

function H = BezierMatrix(q)
    % Transformation matrix for Bézier curves (Bernstein basis).
    % Maps the power basis [u^q, ..., u, 1] into Bernstein polynomials.
    
    H = zeros(q + 1, q + 1);
    
    for i = 0 : q
        for k = i : q
            % Computation of the binomial coefficient for the Bernstein polynomial
            coeff = nchoosek(q, i) * nchoosek(q - i, k - i) * (-1)^(k - i);
            
            % Placement in the correct column
            % (Columns correspond to decreasing powers of u)
            col = q - k + 1;
            H(i + 1, col) = coeff;
        end
    end
end

function T = BezierTangentMatrix(H, q)
    % Differentiation matrix representing the parametric derivative in the power basis
    
    n = q + 1;
    T = zeros(n);
    for j = 1 : q
        exponent = q - (j - 1); 
        T(:, j + 1) = H(:, j) * exponent;
    end
end
