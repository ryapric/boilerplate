Golang
======

This subrepo contains a simple set of dummy Go utilities -- just enough to
demonstrate how a package should be structured.

Go can be frustrating to configure universally; it depends heavily on path
settings being unique across all projects on a host. The included Make targets
configure the `$GOPATH` dynamically per run based on the current directory to
solve for this, without changing the global setting. There is also a Make target
to configure VS Code to treat the working directory as the `$GOPATH`, so that
linters work correctly.
