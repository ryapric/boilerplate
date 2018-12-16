# Basic julia call with colors
juliab = julia --color=yes

# Project-based julia calls with colors
juliapg = julia --color=yes --project="$$PKGNAME"
juliap = julia --color=yes --project

all: build test

FORCE:

generate:
	@$(juliab) -e "using Pkg; Pkg.generate(\"$${PKGNAME}\")"
	@cp Makefile $${PKGNAME}/Makefile
	@$(juliapg) -e "using Pkg; Pkg.add(\"Test\")"
	@cp -r test/ $${PKGNAME}/test

build: FORCE
	@$(juliap) -e "using Pkg; Pkg.build()"

test: FORCE
	@$(juliap) -e "using Pkg; Pkg.test()"

# precompile() is not an exported function from Pkg; just a command in the REPL
# So, it can be accessed via Pkg.REPLMode.pkgstr()
precompile: FORCE
	@$(juliap) -e "using Pkg; Pkg.REPLMode.pkgstr(\"precompile\")"
