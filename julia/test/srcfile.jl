"""
This is the corresponding tests file for the `srcfile.jl` found in the `src`
directory. Your test files should be set up approximately like this one, i.e.:

- declare your test dependencies (Test, your package, then other deps)

- Group related tests into `@testset`s

- `@test` unit functionality

- See if a `@test_throws` some exception

Again, please note that:

- `srcfile.jl` is just a placeholder name for your actual, eventual source file
  names

- `make test` from the repo top-level will run these for you.
"""

using Test
using PkgName

@testset "bogus" begin
    @test 1 == 1
end

@testset "sharpe" begin
    @test sharpe([0.03, 0.01]) == 0.0
    @test sharpe([0.03, 0.01], rf = 0.00) == 1.4142135623730951
    
    # Can't pass anything other than an Array{Float64} as x
    @test_throws MethodError sharpe(1)
end
