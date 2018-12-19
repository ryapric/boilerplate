"""
This file structure taken from the DataFrames runtests.jl file. As you add
test files, add them to the `tests` array. Note that `srcfile.jl` is just a
placeholder name for actual source files.

This file will be called when running `make test` from the repo top-level.
"""

fatalerrors = length(ARGS) > 0 && ARGS[1] == "-f"
quiet = length(ARGS) > 0 && ARGS[1] == "-q"
anyerrors = false

tests = ["srcfile.jl"]

println("Running tests:")

for testname in tests
    try
        include(testname)
        println("\t\033[1m\033[32mPASSED\033[0m: $(testname)")
    catch e
        global anyerrors = true
        println("\t\033[1m\033[31mFAILED\033[0m: $(testname)")
        if fatalerrors
            rethrow(e)
        elseif !quiet
            showerror(stdout, e, backtrace())
            println()
        end
    end
end

if anyerrors
    throw("Tests failed")
end
