#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Must be run as root. Aborting" >&2
    exit 1
fi

if [ -z "$1" ] ; then
    echo "Please provide the version number as the first arg, e.g. '1.0.0'. Aborting." >&2
    exit 1
fi

tmpgz="/tmp/julia.tar.gz"

curl -o "$tmpgz" "https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-${1}-linux-x86_64.tar.gz"

mkdir -p /usr/share/julia
tar --overwrite -xzf "$tmpgz" -C /usr/share/julia/

ln -s -f /usr/share/julia/julia-${1}/bin/julia /usr/bin/julia

rm -rf "$tmpgz"

exit 0
