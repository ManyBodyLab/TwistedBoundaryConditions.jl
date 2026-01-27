using TwistedBoundaryConditions
using Test
using TestExtras
using LinearAlgebra

@testset "TwistedBoundaryConditions" begin
    @testset "get_factors_recursive" begin
        f2 = TwistedBoundaryConditions.get_factors_recursive(6, 2)
        expected = [[1,6], [2,3], [3,2], [6,1]]
        for e in expected
            @test any(x -> x == e, f2)
        end
        @test all(prod(f) == 6 for f in f2)
    end

    @testset "generate_unimodular_matrices" begin
        mats0 = TwistedBoundaryConditions.generate_unimodular_matrices(2, 0)
        @test length(mats0) == 0

        mats1 = TwistedBoundaryConditions.generate_unimodular_matrices(2, 1)
        @test all(round(Int, det(M)) == 1 for M in mats1)
        @test all(all(-1 .<= M .<= 1) for M in mats1)
    end

    @testset "lll_reduction" begin
        b = [[2.0, 0.0], [0.0, 3.0]]
        reduced = TwistedBoundaryConditions.lll_reduction(b)
        @test length(reduced) == length(b)
        det_orig = det(hcat(b...))
        det_red = det(hcat(reduced...))
        @test isapprox(det_orig, det_red; atol=1e-8)
        @test all(x -> all(isfinite, x), reduced)
    end

    @testset "calculate_optimal_tbc" begin
        Ns = 4
        basis = [[1.0, 0.0], [0.0, 1.0]]
        N_dims, U, ratio = calculate_optimal_tbc(Ns, basis; search_range=1)
        @test prod(N_dims) == Ns
        @test isa(U, Matrix{Int})
        @test isfinite(ratio) && ratio > 0
        @test round(Int, det(U)) == 1

        basis_bad = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0]]
        @test_throws ErrorException calculate_optimal_tbc(Ns, basis_bad)

        # Non-trivial examples from README
        @testset "triangular lattice (Ns=21)" begin
            b2 = [1.0, 0.0]; b1 = [-0.5, sqrt(3)/2]
            N21_1, U21_1, ratio21_1 = calculate_optimal_tbc(21, [b1, b2]; search_range=1)
            @test N21_1 == [3, 7]
            @test U21_1 == Matrix{Int}([0 -1; 1 -1])
            @test isapprox(ratio21_1, 0.6735753140545634; atol=1e-12)

            N21_2, U21_2, ratio21_2 = calculate_optimal_tbc(21, [b1, b2]; search_range=2)
            @test N21_2 == [3, 7]
            @test U21_2 == Matrix{Int}([1 -2; 1 -1])
            @test isapprox(ratio21_2, 0.9571859726038531; atol=1e-12)
        end

        @testset "simple cubic (3D, Ns=12)" begin
            b1 = [1.0, 0.0, 0.0]; b2 = [0.0, 1.0, 0.0]; b3 = [0.0, 0.0, 1.0]
            N12, U12, ratio12 = calculate_optimal_tbc(12, [b1, b2, b3]; search_range=1)
            @test N12 == [1, 3, 4]
            @test U12 == Matrix{Int}([0 -1 -1; -1 0 -1; 1 -1 -1])
            @test isapprox(ratio12, 0.8164965809277259; atol=1e-12)
        end

        @testset "lll_reduction preserves volume and shortens vectors" begin
            # Reconstruct real-space R for the triangular search_range=2 case
            b2 = [1.0, 0.0]; b1 = [-0.5, sqrt(3)/2]
            N_dims, U_mat, _ = calculate_optimal_tbc(21, [b1, b2]; search_range=2)
            B = hcat(b1, b2)
            S = Diagonal([1.0 ./ N_dims...])
            K = B * transpose(U_mat) * S
            @test abs(det(K)) > 1e-9
            R = 2pi * transpose(inv(K))
            R_vecs = [R[:, i] for i in 1:2]
            orig_vol = abs(det(hcat(R_vecs...)))
            orig_max = maximum(norm.(R_vecs))
            reduced = TwistedBoundaryConditions.lll_reduction(R_vecs)
            red_vol = abs(det(hcat(reduced...)))
            red_max = maximum(norm.(reduced))
            @test isapprox(orig_vol, red_vol; atol=1e-8)
            @test red_max <= orig_max + 1e-8
        end
    end
end
