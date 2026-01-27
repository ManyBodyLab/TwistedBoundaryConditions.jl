# # TwistedBoundaryConditions.jl

# ## Installation

# The package is not yet registered in the Julia general registry. It can be installed trough the package manager with the following command:

# ```julia-repl
# pkg> add git@github.com:ManyBodyLab/TwistedBoundaryConditions.jl.git
# ```

# ## Code Samples

# ```julia
# # --- Usage Example (3D) ---
# # Simple Cubic Basis
# julia> using TwistedBoundaryConditions
# julia> b1 = [1.0, 0.0, 0.0]; b2 = [0.0, 1.0, 0.0]; b3 = [0.0, 0.0, 1.0];
# julia> Ns, U, ratio = calculate_optimal_tbc(12, [b1, b2, b3], search_range=1);
# julia> println("Optimal Ns: $Ns")
# Optimal Ns: [1, 3, 4]
# julia> println("Optimal U matrix: \n$U")
# Optimal U matrix:
# [0 -1 -1; -1 0 -1; 1 -1 -1]
# julia> println("Aspect Ratio: $ratio")
# Aspect Ratio: 0.8164965809277259
# # Triangular Lattice Basis
# julia> b2 = [1.0, 0.0]; b1 = [-0.5, sqrt(3)/2]
# julia> Ns, U, ratio = calculate_optimal_tbc(21, [b1, b2], search_range=1)
# julia> println("Optimal Ns: $Ns")
# Optimal Ns: [3, 7]
# julia> println("Optimal U matrix: \n$U")
# Optimal U matrix:
# [0 -1; 1 -1]
# julia> println("Aspect Ratio: $ratio")
# Aspect Ratio: 0.6735753140545634
# julia> b2 = [1.0, 0.0]; b1 = [-0.5, sqrt(3)/2]
# julia> Ns, U, ratio = calculate_optimal_tbc(21, [b1, b2], search_range=2)
# julia> println("Optimal Ns: $Ns")
# Optimal Ns: [3, 7]
# julia> println("Optimal U matrix: \n$U")
# Optimal U matrix:
# [1 -2; 1 -1]
# julia> println("Aspect Ratio: $ratio")
# Aspect Ratio: 0.9571859726038531
# ```

# ## License

# TwistedBoundaryConditions.jl is licensed under the [MIT License](LICENSE)). By using or interacting with this software in any way, you agree to the license of this software.
