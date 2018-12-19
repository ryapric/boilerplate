"""
This is a main module file. In it, you should:

- `export` the desired functions from your `include()` calls (comma-delimited)

- `include()` your `srcfile`s. There is a stubbed, vectorized `include()` here,
  but if you want to change it, just construct a manual array of source file
  names.
"""

module PkgName

export sharpe

dir = readdir(dirname(@__FILE__))
includes = filter(x -> (endswith(x, "jl") && x != "PkgName.jl"), dir)
include.(includes)

end # module Ex
