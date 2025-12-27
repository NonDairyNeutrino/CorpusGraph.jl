# CorpusGraph.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://nondairyneutrino.github.io/CorpusGraph.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://nondairyneutrino.github.io/CorpusGraph.jl/dev/)
[![Build Status](https://github.com/nondairyneutrino/CorpusGraph.jl/actions/workflows/CI.yml/badge.svg?branch=trunk)](https://github.com/nondairyneutrino/CorpusGraph.jl/actions/workflows/CI.yml?query=branch%3Atrunk)
[![Coverage](https://coveralls.io/repos/github/nondairyneutrino/CorpusGraph.jl/badge.svg?branch=trunk)](https://coveralls.io/github/nondairyneutrino/CorpusGraph.jl?branch=trunk)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)
[![PkgEval](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/C/CorpusGraph.svg)](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/C/CorpusGraph.html)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

The idea is simple: Given a collection of words, represent each word as a [weighted](https://en.wikipedia.org/wiki/Graph_(discrete_mathematics)#Weighted_graph),
[$k$-partite](https://en.wikipedia.org/wiki/Multipartite_graph) graph where the position of each character defines one of the $k$ vertex sets.
Then union them and weight edges with the number of times that connection occurs.

## Example

For example, consider the corpus `"pineapple pizza pasta sauce"`.
Each word (i.e. a sequence of non-white-space characters separated) is first represented as a
weighted, 5-partite graph with the position of each character defining a set, and consecutive
characters defining a (directed) edge from the prior to the later.  This structure also defines
the word graph as a [path graph](https://en.wikipedia.org/wiki/Path_graph).
So words in the corpus are encoded as
- "pineapple" ==> `[p] --[1]> [i] --[1]> [n] --[1]> [a] --[1]> [p] --[1]> [p] --[1]> [l] --[1]> [e]`
- "pizza"     ==> `[p] --[1]> [i] --[1]> [z] --[1]> [z] --[1]> [a]`
- "pasta"     ==> `[p] --[1]> [a] --[1]> [s] --[1]> [t] --[1]> [a]`
- "sauce"     ==> `[s] --[1]> [a] --[1]> [u] --[1]> [c] --[1]> [e]`
where each vertex has a value corresponding to its letter, edge has weight 1 as denoted in
square brackets.
Then add these graphs together to yield

```
                 --[1]> [n] --[1]> [a] --[1]> [p] --[1]> [p] --[1]> [l] --[1]> [e]
                /
     |--[2]> [i] --[1]> [z] --[1]> [z] --[1]> [a]
[p] <                                         |
     |--[1]> [a] --[1]> [s] --[1]> [t] --[1]> |
             |  \
[s] ----[1]>/    --[1]> [u] --[1]> [c] --[1]> [e]
```

where the set of vertices in each "index layer" (left to right columns of vertices) is the
union of the vertex sets of each word graph, an edge between two characters exists if those
characters appear consecutively at least once, and the weight of an edge is the sum of the
weights of matching edges in each word graph (i.e. the weight is the number of ocurrences of
those two characters appearing consecutively).
In this case, the only two characters that appeared at first index of all words are "p" and "s".
Likewise, the characters that appeared at least once at the second index of the word are "i" and "a".
The edge connecting "p" at index 1 and "i" at index 2 vertices has weight 2 because 2 is the
sum of the weights of the "pi" edge in "pineapple" and "pizza"; alternatively there are 2
instances of a word with "pi" in the first and second indices.

## It's a Monoid

Because the final graph doesn't change if words are grouped together differently while adding,
this operation is associative.  Additionally, the [null/order-zero](https://en.wikipedia.org/wiki/Null_graph) graph (i.e. the unique graph
containing no vertices) serves as the identity element for this operation as taking this operation
between any word graph $g$ and the order-zero graph results in $g$.
Therefore, the set of word graphs together with this operation form a [monoid](https://en.wikipedia.org/wiki/Monoid).


## Parallelism

TODO: add notes about parallelism and mapreduce.
