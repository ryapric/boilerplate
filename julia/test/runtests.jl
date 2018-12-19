"""
This file will be called when running `make test` from the repo top-level. It
reads all the ".jl" files in the test directory into an array, and runs
`include()` on each of them.
"""

dir = readdir(dirname(@__FILE__))
tests = filter(x -> (endswith(x, "jl") && x != "runtests.jl"), dir)
include.(tests)
