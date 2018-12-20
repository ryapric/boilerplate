"""
This is a file where code to be used for your module can appear. Files like
these are *not* modules themselves, so don't wrap them in one, or your
`include()`s won't run!

The example function, `sharpe()`, also demonstrates how to use docstrings in
Julia. However, refer to the official docs to read about best practices, like
not documenting kwargs if they're self-explanatory.
"""

using Statistics

"""
    sharpe(x[, rf])

Calculate the Sharpe Ratio of a financial returns series `x`, using `rf` as the
risk-free rate. If `rf` is missing, use 0.02.

# Arguments
- x::Array{Float64}: An array of returns data
- rf::Float64: The risk-free rate

# Examples
```jldoctest
using PkgName

returns = [0.03, 0.04, 0.01]
sharpe(returns, rf = 0.02)

# output

0.4364357804719848
```
"""
function sharpe(x::Array{Float64}; rf::Float64 = 0.02)::Float64
    return ((mean(x) - rf) / std(x))
end
