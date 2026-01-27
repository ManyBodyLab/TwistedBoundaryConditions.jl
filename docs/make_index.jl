using Literate: Literate
using EDTwists

Literate.markdown(
    joinpath(pkgdir(EDTwists), "docs", "files", "README.jl"),
    joinpath(pkgdir(EDTwists), "docs", "src");
    flavor = Literate.DocumenterFlavor(),
    name = "index",
)
