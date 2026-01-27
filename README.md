<!-- <img src="./docs/src/assets/logo_readme.svg" width="150"> -->

# TwistedBoundaryConditions.jl

| **Documentation** | **Downloads** |
|:-----------------:|:-------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![Downloads][downloads-img]][downloads-url]

| **Build Status** | **Coverage** | **Style Guide** | **Quality assurance** |
|:----------------:|:------------:|:---------------:|:---------------------:|
| [![CI][ci-img]][ci-url] | [![Codecov][codecov-img]][codecov-url] | [![code style: runic][codestyle-img]][codestyle-url] | [![Aqua QA][aqua-img]][aqua-url] |

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://manybodylab.github.io/TwistedBoundaryConditions.jl/stable

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://manybodylab.github.io/TwistedBoundaryConditions.jl/dev

[doi-img]: https://zenodo.org/badge/DOI/
[doi-url]: https://doi.org/

[downloads-img]: https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Ftotal_downloads%2FTwistedBoundaryConditions&query=total_requests&label=Downloads
[downloads-url]: http://juliapkgstats.com/pkg/TwistedBoundaryConditions

[ci-img]: https://github.com/ManyBodyLab/TwistedBoundaryConditions.jl/actions/workflows/Tests.yml/badge.svg
[ci-url]: https://github.com/ManyBodyLab/TwistedBoundaryConditions.jl/actions/workflows/Tests.yml

[pkgeval-img]: https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/M/TwistedBoundaryConditions.svg
[pkgeval-url]: https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/M/TwistedBoundaryConditions.html

[codecov-img]: https://codecov.io/gh/ManyBodyLab/TwistedBoundaryConditions.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/ManyBodyLab/TwistedBoundaryConditions.jl

[aqua-img]: https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg
[aqua-url]: https://github.com/JuliaTesting/Aqua.jl

[codestyle-img]: https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black
[codestyle-url]: https://github.com/fredrikekre/Runic.jl


## Installation

The package is not yet registered in the Julia general registry. It can be installed trough the package manager with the following command:

```julia-repl
pkg> add git@github.com:ManyBodyLab/TwistedBoundaryConditions.jl.git
```


## Code Samples

```julia
# --- Usage Example (3D) ---
# Simple Cubic Basis
julia> using TwistedBoundaryConditions
julia> b1 = [1.0, 0.0, 0.0]; b2 = [0.0, 1.0, 0.0]; b3 = [0.0, 0.0, 1.0];
julia> Ns, U, ratio = calculate_optimal_tbc(12, [b1, b2, b3], search_range=1);
julia> println("Optimal Ns: $Ns")
Optimal Ns: [1, 3, 4]
julia> println("Optimal U matrix: \n$U")
Optimal U matrix:
[0 -1 -1; -1 0 -1; 1 -1 -1]
julia> println("Aspect Ratio: $ratio")
Aspect Ratio: 0.8164965809277259
# Triangular Lattice Basis
julia> b2 = [1.0, 0.0]; b1 = [-0.5, sqrt(3)/2]
julia> Ns, U, ratio = calculate_optimal_tbc(21, [b1, b2], search_range=1)
julia> println("Optimal Ns: $Ns")
Optimal Ns: [3, 7]
julia> println("Optimal U matrix: \n$U")
Optimal U matrix:
[0 -1; 1 -1]
julia> println("Aspect Ratio: $ratio")
Aspect Ratio: 0.6735753140545634
julia> b2 = [1.0, 0.0]; b1 = [-0.5, sqrt(3)/2]
julia> Ns, U, ratio = calculate_optimal_tbc(21, [b1, b2], search_range=2)
julia> println("Optimal Ns: $Ns")
Optimal Ns: [3, 7]
julia> println("Optimal U matrix: \n$U")
Optimal U matrix:
[1 -2; 1 -1]
julia> println("Aspect Ratio: $ratio")
Aspect Ratio: 0.9571859726038531
```

## License

TwistedBoundaryConditions.jl is licensed under the [MIT License](LICENSE). By using or interacting with this software in any way, you agree to the license of this software.
