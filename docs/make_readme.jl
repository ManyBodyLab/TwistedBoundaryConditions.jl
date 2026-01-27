using Literate: Literate
using EDTwists

Literate.markdown(
    joinpath(pkgdir(EDTwists), "docs", "files", "README.jl"),
    joinpath(pkgdir(EDTwists));
    flavor = Literate.CommonMarkFlavor(),
    name = "README",
)
