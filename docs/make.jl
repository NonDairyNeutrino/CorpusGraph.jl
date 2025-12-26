using CorpusGraph
using Documenter

DocMeta.setdocmeta!(CorpusGraph, :DocTestSetup, :(using CorpusGraph); recursive=true)

makedocs(;
    modules=[CorpusGraph],
    authors="nondairyneutrino <chapmann19@gmail.com> and contributors",
    sitename="CorpusGraph.jl",
    format=Documenter.HTML(;
        canonical="https://nondairyneutrino.github.io/CorpusGraph.jl",
        edit_link="trunk",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/nondairyneutrino/CorpusGraph.jl",
    devbranch="trunk",
)
