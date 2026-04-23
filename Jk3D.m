% Program Jk3D.m : Exact computation of arbitrary-order moments of volume
%                  for closed 3D domains bounded by Bézier surfaces.
%                  Supports mixed-degree boundaries via struct input.
%
% Developed by:
%   Davide Pellecchia   (davide.pellecchia@unina.it);
%   Luciano Rosati      (rosati@unina.it);
%   Francesco Marmo     (f.marmo@unina.it);
%
% Department of Structures for Engineering and Architecture,
% University of Naples Federico II, Italy.
%
% REFERENCE:
% If you use this code in your research, please cite the following paper:
% D. Pellecchia, L. Rosati, F. Marmo. "Evaluation of high-order moments
% for plane and solid closed domains bounded by arbitrary-degree Bézier
% curves and surfaces". Submitted for publication XXX, 2026.
%
% INPUT:
% patch = Struct array containing the pre-processed boundary geometry:
%         .P  -> Control points tensor (3 x (qu+1) x (qw+1))
%         .qu -> Bézier patch degree along parametric direction u
%         .qw -> Bézier patch degree along parametric direction w
% k     = General order of the moments of volume (integer k >= 0);
%
% OUTPUT:
% Jk = Exact k-th order moment of volume tensor;
%   J0 = Volume         (setting k = 0, returns a scalar);
%   J1 = Static moment  (setting k = 1, returns a 3x1 vector);
%   J2 = Inertia tensor (setting k = 2, returns a 3x3 matrix);
%   ... and so on for higher orders.

function Jk = Jk3D(patch, k)
    
    npatch = length(patch);
    
    % Initialization of the output tensor
    if k == 0
        Jk_init = 0;
    elseif k == 1
        Jk_init = zeros(3, 1);
    else
        dims = repmat(3, 1, k);
        Jk_init = zeros(dims);
    end
    
    % =================================================================
    % PURE TENSORIAL FORMULATION 
    % =================================================================
    % This method relies on pure multidimensional tensor contractions
    % to evaluate the exact boundary integrals in closed form.
    
    epsilon = levicivita; 
    n_op = k + 3; 
    Jk_tens = Jk_init;
    
    for s = 1 : npatch
        qu = patch(s).qu;
        qw = patch(s).qw;
        P  = patch(s).P; 
        
        % 1. Dynamic generation of bases and derivative operators
        Hu = BezierMatrix(qu); Tu = BezierTangentMatrix(Hu, qu);
        Hw = BezierMatrix(qw); Tw = BezierTangentMatrix(Hw, qw);
        Lu = PowerBasisMatrix(n_op, qu);
        Lw = PowerBasisMatrix(n_op, qw);
        
        U_outer = Hu;
        W_outer = Hw;
        
        for iter = 2 : n_op
            op_u = Hu; if iter == k + 2, op_u = Tu; end
            op_w = Hw; if iter == k + 3, op_w = Tw; end
            U_outer = tensorprod(U_outer, op_u, [], []);
            W_outer = tensorprod(W_outer, op_w, [], []);
        end
        
        ind_odds  = 2 : 2 : (2 * n_op);
        ind_evens = 1 : n_op;
        U_bar = tensorprod(U_outer, Lu, ind_odds, ind_evens);
        W_bar = tensorprod(W_outer, Lw, ind_odds, ind_evens);
        
        % 2. Permutation Operator
        ProdUW = tensorprod(U_bar, W_bar, n_op + 1, n_op + 1);
        S_k = zeros(1, 2 * n_op);
        S_k(1:2:end) = 1 : n_op; 
        S_k(2:2:end) = (n_op + 1) : (2 * n_op);
        UW_perm = permute(ProdUW, S_k);
        
        % -----------------------------------------------------------------
        % 3. TENSOR SIMPLIFICATION: Sequential Contraction
        % -----------------------------------------------------------------
        % Initialize the temporary tensor with the parametric integrals
        T_seq = UW_perm; 
        
        % Iteratively contract the (k + 3) copies of the control points P
        for iter = 1 : n_op
            % P has dimensions [3, qu+1, qw+1]. 
            % T_seq ALWAYS has the next two parametric dimensions in 
            % position 1 and 2. Contracting appends the spatial dimension 
            % of P (size 3) to the end of T_seq.
            T_seq = tensorprod(T_seq, P, [1, 2], [2, 3]);
        end
        
        % At the end of this loop, T_seq contains ONLY spatial indices.
        % The first k dimensions are x_1, x_2, ..., x_k.
        % The last 3 dimensions correspond to r, r_u, r_w.
        
        if k == 0
            % For k=0, T_seq has 3 dimensions: r, r_u, r_w.
            temp = tensorprod(T_seq, epsilon, [1, 2, 3], [1, 2, 3]);
        else
            % Contraction with the Levi-Civita tensor to compute r . (r_u x r_w)
            % yielding the desired rank-k tensor.
            temp = tensorprod(T_seq, epsilon, [k+1, k+2, k+3], [1, 2, 3]);
        end
        
        Jk_tens = Jk_tens + temp;
    end
    
    % Final scaling according to the Divergence Theorem
    Jk = Jk_tens / (k + 3);

end

%% =========================================================================
%% CORE SUB-FUNCTIONS
%% =========================================================================

function L = PowerBasisMatrix(order, q)
    % Evaluates the exact integration tensor over the parametric domain [0, 1]
    base_powers = q : -1 : 0; 
    args = repmat({1 : q + 1}, 1, order);
    
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
    % Transformation matrix mapping the power basis into Bernstein polynomials
    H = zeros(q + 1, q + 1);
    for i = 0 : q
        for k = i : q
            coeff = nchoosek(q, i) * nchoosek(q - i, k - i) * (-1)^(k - i);
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

function epsilon = levicivita
    % Generates the 3D Levi-Civita permutation tensor
    epsilon = zeros(3,3,3);
    epsilon(1,2,3) = 1; epsilon(2,3,1) = 1; epsilon(3,1,2) = 1;
    epsilon(3,2,1) = -1; epsilon(1,3,2) = -1; epsilon(2,1,3) = -1;
end