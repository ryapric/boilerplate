# This structure taken from the DataFrames.jl runtests.jl file

fatalerrors = length(ARGS) > 0 && ARGS[1] == "-f"
quiet = length(ARGS) > 0 && ARGS[1] == "-q"
anyerrors = false

using Test

tests = ["test-modulename.jl"]

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
