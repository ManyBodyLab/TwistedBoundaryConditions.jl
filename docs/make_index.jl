using Literate: Literate
using TwistedBoundaryConditions

Literate.markdown(
    joinpath(pkgdir(TwistedBoundaryConditions), "docs", "files", "README.jl"),
    joinpath(pkgdir(TwistedBoundaryConditions), "docs", "src");
    flavor = Literate.DocumenterFlavor(),
    name = "index",
)
