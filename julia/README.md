Julia Package Template
======================

This sub-repo provides a `Makefile` to generate the skeleton for Julia packages.
Most traditional 'boilerplate' code in Julia is not only discouraged, but
useless by Julia's design (for example, UUIDs won't be correct just by changing
the package name itself). Therefore, this `README` and `Makefile` serve to
document the process of manually generating package contents for Julia projects,
but also generating the fewest, most important parts automatically
(respectively).

Using the Makefile
------------------

The included `Makefile` serves to automate all of what you will read below, but
the latter is included for posterity regardless.

The `Makefile` provides a `generate` target, which will call Julia's
`Pkg.generate()`, as well as important files that are missing from that call,
such as the `test` folder & a stubbed `runtests.jl` file.

There is no default name that the `Makefile` will assign to a project when
calling `make generate`. As such, you will need to call it with an environment
variable `PKGNAME` specifying the name of the project, i.e.:

```sh
$ make generate PKGNAME="../SomePkgName"
```

Note the parent-directory reference, '`..`'. You are able to use absolute and
relative path references in the passed variable, and the package will be
initialized at this location. If you just specify a name (e.g. `SomePkgName`),
then the folder for the packge will be made in the current (`boilerplate`)
directory, which is probably not what you want.

Note that the `generate` target will add the Julia packages `Statistics` and
`Test` to your project's `Project.toml` file. If you do not want these, or any
other packages that are added, you will need to remove them through Julia, with
either of the following:

```sh
(PkgName)> remove Pkg1 Pkg2 ...
# or
$ julia --project -e 'using Pkg; Pkg.remove(["Pkg1", "Pkg2", ...])
```

The `Makefile` also includes targets for:

- `test`

- `build`

- `precompile` (Julia is probably subject to change how I'm invoking this)

Workflow Suggestions
--------------------

Regarding a workflow in Julia, the dominant convention is that a user may enter
commands through the (admittedly well-designed) REPL. However, the documentation
for a non-interactive workflow when working with a package structure is terribly
sparse. The following attempts to document my experiences with creating a Julia
package from scratch, as well as the necessary build, test, install, etc. steps
for that package. I will document how to do these both through the REPL, as well
as non-interactively. REPL commands will appear first, and headless commands
second. For the REPL commands, any that are prefixed with the `(PkgName)` prompt
indicate that the user has pressed `]` at the regular Julia prompt to enter the
`Pkg` REPL.

Getting Started
---------------

To have Julia generate the necessary dependency files for a project, you can
run:

```sh
(PkgName)> generate PkgName
# or
$ julia -e 'using Pkg; Pkg.generate("PkgName")'
```

This will create:

- a *project folder* named `PkgName` in the current directory

- a `Project.toml` file in the project top-level (this file is the formal
  project indicator for Julia)

- a `Makefile` identical to the one in *this* top-level.

- a `src` folder in the project top-level, with a single example module file,
  named `PkgName.jl`. This is where you should `include()` all of the modules
  you write in the `src` folder.

Now, `cd` into `PkgName` for the rest of your work.

Working with Your Project
-------------------------

Getting Julia to understand that you are working with a scoped package, and not
OS-global files, requires *activating* your project. At the Julia REPL, you
would run:

```sh
(PkgName)> activate .
```

To indicate this. Be sure to do this *first*.

If running non-interactively, there isn't a meaningful `Pkg.activate()` to run,
but `julia` takes the `--project` flag to indicate the same effect for the
duration of the shell call.

```sh
$ julia --project="@." [ARGS]
```

The `@.` value to `--project` is the default, which will traverse *up* from your
current directory until it finds a `Project.toml` (or a `JuliaProject.toml`)
file. You can omit the value from the flag itself if your are running commands
from the top-level directory.

Project-specific Commands
-------------------------

"DevOps"-y commands, such as running unit tests or building your package, can be
run in a project context as described above. For example, to run your unit
tests:

```sh
(PkgName)> test
# or
julia --project -e 'using Pkg; Pkg.test()'
```

Tests go in the `test` (not "testS") directory. The main test which calls the
others needs to be called `runtests.jl`. You can see an example template in this
sub-repos top-level `test` folder.

Notes
-----

- As stated above, you cannot perform project-specific operations (build, test,
  etc.) on a Julia project unless *Julia recognizes a folder as a project*. This
  requires a top-level `Projct.toml` file, which is created when calling
  `Pkg.generate()`.
