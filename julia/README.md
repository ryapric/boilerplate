Julia Package Template
======================

This sub-repo provides a `Makefile` to generate the skeleton for Julia packages.
As traditional 'boilerplate' code in Julia is not only discouraged, but useless
by Julia's design, this `README` and `Makefile` serve to document the process of
generating package contents for Julia projects.

Workflow Suggestions
--------------------

Regarding a workflow in Julia, the dominant convention is that a user may enter
commands through the (admittedly well-designed) REPL. However, the documentation
for a non-interactive workflow when working with a package structure is terribly
sparse. The following attempts to document my experiences with creating a Julia
package from scratch, as well as the necessary build, test, install, etc. steps
for that package. I will document how to do these both through the REPL, as well
as non-interactively. REPL commands will appear first, and headless commands
second.

Getting Started
---------------

To have Julia generate the necessary dependency files for a project, you can
run:

```sh
julia> ]generate PkgName
# or
$ julia -e 'using Pkg; Pkg.generate("PkgName")'
```

This will create:

- a *folder* named `PkgName` in the current directory

- a `Project.toml` file in the project top-level

- a `src` folder in the project top-level, with an example module file, named
  `PkgName.jl`

Now, `cd` into `PkgName` for the rest of the process.

```sh
julia> ]activate .
```

```sh
julia --project -e 'using Pkg; Pkg.build(); Pkg.test()'
```

Notes
-----

- You cannot perform project-specific operations (build, test, etc.) on a Julia
  project unless *Julia recognizes a folder as a project*. This requires a
  top-level `Projct.toml` file, which is created when calling `Pkg.generate()`.
