all: build test
	@echo "Not defined."

generate:
	@julia -e "using Pkg; Pkg.generate(\"$${PKGNAME}\")"
	@mkdir $${PKGNAME}/test
	@cp runtests.jl $${PKGNAME}/test/runtests.jl

test:
	@julia --project -e 'using Pkg; Pkg.test()'
