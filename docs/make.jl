using Documenter, PConv

makedocs(sitename="PConv.jl",
        modules = [PConv],
        pages = [
            "Home" => "index.md",
            "Library" => "docs.md"]
        )

deploydocs(repo = "github.com/lukasgrunwald/PConv.jl.git")
