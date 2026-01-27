using EDTwists
using Aqua: Aqua
using Test
using TestExtras

@testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(EDTwists)
end
