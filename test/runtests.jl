using CorpusGraph
using Test
using Aqua
using JET

@testset "CorpusGraph.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(CorpusGraph)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(CorpusGraph; target_defined_modules = true)
    end
    # Write your tests here.
end
