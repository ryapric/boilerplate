# Basic julia call with colors
juliab = julia --color=yes

# Project-based julia calls with colors
juliapg = julia --color=yes --project="$$PKGNAME"
juliap = julia --color=yes --project

# Bare package name provided, in case it includes path info
PKGNAMEBARE := $$(echo "$${PKGNAME}" | sed -r 's/^.*\/([A-Za-z0-9_\-]+)$$/\1/')

all: precompile build test

FORCE:

generate:
	@# Initalize package files via Julia
	@$(juliab) -e "using Pkg; Pkg.generate(\"$${PKGNAME}\")"
	@cp Makefile $${PKGNAME}/Makefile

	@# Initialize src folder skeleton
	@rm -rf $${PKGNAME}/src/
	@cp -r src/ $${PKGNAME}/src
	@mv $${PKGNAME}/src/PkgName.jl $${PKGNAME}/src/$(PKGNAMEBARE).jl
	@sed -i "s/PkgName/$(PKGNAMEBARE)/g" $${PKGNAME}/src/$(PKGNAMEBARE).jl

	@# Initialize tests skeleton
	@$(juliapg) -e "using Pkg; Pkg.add([\"Test\", \"Statistics\"])"
	@cp -r test/ $${PKGNAME}/test
	@sed -i "s/PkgName/$(PKGNAMEBARE)/g" $${PKGNAME}/test/srcfile.jl

# precompile() is not an exported function from Pkg; just a command in the REPL
# So, it can be accessed via Pkg.REPLMode.pkgstr()
precompile: FORCE
	@$(juliap) -e "using Pkg; Pkg.REPLMode.pkgstr(\"precompile\")"

build: FORCE
	@$(juliap) -e "using Pkg; Pkg.build()"

test: FORCE
	@$(juliap) -e "using Pkg; Pkg.test()"
