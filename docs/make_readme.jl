using Literate: Literate
using TwistedBoundaryConditions

Literate.markdown(
    joinpath(pkgdir(TwistedBoundaryConditions), "docs", "files", "README.jl"),
    joinpath(pkgdir(TwistedBoundaryConditions));
    flavor = Literate.CommonMarkFlavor(),
    name = "README",
)
