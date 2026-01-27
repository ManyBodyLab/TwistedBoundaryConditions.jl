using LinearAlgebra
using Combinatorics

"""
    lll_reduction(basis::AbstractVector{AbstractVector{T}}; delta=0.75) where {T<:Real}

Performs LLL lattice reduction to find a basis with short, nearly orthogonal vectors.
Essential for defining a meaningful aspect ratio in D > 2.
"""
function lll_reduction(basis::AbstractVector{<:AbstractVector{T}}; delta=0.75) where {T<:Real}
    n = length(basis)
    b = copy(basis)
    # Gram-Schmidt orthogonalization vectors (mu and B)
    # We maintain them lazily or recompute for simplicity in this snippet
    
    function update_gram_schmidt(b)
        q = [copy(vec) for vec in b]
        mu = Matrix{T}(I, n, n)
        B = zeros(T, n)
        for i in 1:n
            for j in 1:i-1
                mu[i, j] = dot(b[i], q[j]) / dot(q[j], q[j])
                q[i] .-= mu[i, j] .* q[j]
            end
            B[i] = dot(q[i], q[i])
        end
        return mu, B
    end

    k = 2
    while k <= n
        mu, B = update_gram_schmidt(b)
        # Size reduction
        for j in k-1:-1:1
            if abs(mu[k, j]) > 0.5
                c = round(mu[k, j])
                b[k] .-= c .* b[j]
                mu, B = update_gram_schmidt(b) # Update after change
            end
        end
        
        # Lovasz condition check
        if B[k] < (delta - mu[k, k-1]^2) * B[k-1]
            b[k], b[k-1] = b[k-1], b[k]
            k = max(k - 1, 2)
        else
            k += 1
        end
    end
    return b
end

"""
    get_factors_recursive(Ns, dim)

Recursively finds all factorizations of Ns into `dim` integers.
Returns a list of vectors, e.g., [[2, 2, 3], [1, 4, 3], ...] for Ns=12, dim=3.
"""
function get_factors_recursive(Ns::Int, dim::Int)
    if dim == 1
        return [[Ns]]
    end
    factors_list = Vector{Vector{Int}}()
    # Iterate i from 1 to Ns (optimization: can stop at sqrt(Ns) if ordered, 
    # but we need all permutations or just unique sets? The geometry N1, N2 matters 
    # if the basis vectors are not symmetric. We assume ordered sets.)
    for i in 1:Ns
        if Ns % i == 0
            sub_factors = get_factors_recursive(div(Ns, i), dim - 1)
            for sf in sub_factors
                push!(factors_list, vcat(i, sf))
            end
        end
    end
    return factors_list
end

"""
    generate_unimodular_matrices(dim::Int, limit::Int)

Generates DxD integer matrices with determinant 1.
Entries are within range [-limit, limit].
WARNING: The number of matrices grows as (2*limit+1)^(D^2). Keep limit small (1 or 2).
"""
function generate_unimodular_matrices(dim::Int, limit::Int)
    # Create an iterator over the Cartesian product of the range
    r = -limit:limit
    matrices = Vector{Matrix{Int}}()
    
    for M_flat in Iterators.product(ntuple(_ -> r, dim*dim)...)
        M = reshape(collect(M_flat), dim, dim)
        if round(Int, det(M)) == 1
            push!(matrices, M)
        end
    end
    return matrices
end

"""
    calculate_optimal_tbc(Ns::Int, basis_vectors::AbstractVector{<:AbstractVector{T}}; search_range::Int=3) where {T<:Real}

Generalized optimal TBC calculator for arbitrary dimension D.

# Arguments
- `Ns`: Total number of sites.
- `basis_vectors`: List of D basis vectors (e.g., [[1.0, 0.0], [-0.5, 0.866]]).
- `search_range`: Range for integers in the twist matrix.
"""
function calculate_optimal_tbc(Ns::Int, basis_vectors::AbstractVector{<:AbstractVector{T}}; search_range::Int=3) where {T<:Real}
    dim = length(basis_vectors)
    if length(basis_vectors[1]) != dim
        error("Dimension of basis vectors must match number of vectors.")
    end

    best_ratio = -1.0
    best_config = Dict()

    # 1. Factorize Ns into dimensions
    factorizations = get_factors_recursive(Ns, dim)

    # 2. Generate Twist Matrices (Unimodular)
    twist_matrices = generate_unimodular_matrices(dim, search_range)
    
    # Pre-calculate basis matrix B (columns are b1, b2, ...)
    # B = [b1 b2 ...]
    B_matrix = hcat(basis_vectors...) 

    for N_dims in factorizations
        # Construct Diagonal Scaling Matrix S = diag(1/N1, 1/N2, ...)
        S = Diagonal([1.0/n for n in N_dims])
        
        for U in twist_matrices
            # The momentum grid generator matrix K_matrix (columns are K1, K2...)
            # Definition: K_i = (1/N_i) * sum(U_ij * b_j)
            # In matrix form: K = B * U^T * S
            # (assuming standard convention: f_i = sum U_ij b_j)
            
            # Let's map to the 2D code: 
            # F1 = n11*b1 + n12*b2 => Column 1 of F = B * [n11; n12]
            # So F = B * U'. Note: U index order matters. 
            # In 2D code: f1 = n11 b1 + n12 b2. This matches F = B * U' if U = [n11 n12; n21 n22].
            
            K_matrix = B_matrix * transpose(U) * S

            # Real space superlattice R
            # Relation: K^T * R = 2pi * I  =>  R = 2pi * inv(K^T) = 2pi * inv(K)'
            if abs(det(K_matrix)) < 1e-9 continue end
            R_matrix = 2 * pi * transpose(inv(K_matrix))

            # Extract vectors from R_matrix columns
            R_vecs = [R_matrix[:, i] for i in 1:dim]

            # 3. Lattice Reduction (LLL)
            reduced_R = lll_reduction(R_vecs)

            # 4. Calculate Aspect Ratio
            # Generalized Metric: Volume / (Max_Length)^D
            vol = abs(det(hcat(reduced_R...)))
            max_len = maximum(norm.(reduced_R))
            ratio = vol / (max_len^dim)

            if ratio > best_ratio
                best_ratio = ratio
                best_config = Dict(
                    "N_dims" => N_dims,
                    "U_matrix" => U,
                    "Aspect_Ratio" => ratio,
                )
            end
        end
    end
    return best_config["N_dims"], best_config["U_matrix"], best_config["Aspect_Ratio"]
end
