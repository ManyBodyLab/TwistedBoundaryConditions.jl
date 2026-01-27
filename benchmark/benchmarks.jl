using BenchmarkTools
using TwistedBoundaryConditions

SUITE = BenchmarkGroup()
SUITE["rand"] = @benchmarkable rand(10)

# Write your benchmarks here.
