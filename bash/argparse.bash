#!/usr/bin/env bash
set -e

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

# Example manual argparse
shifterror () {
    echo "If supplying option '$1', you must supply a value" >&2 && exit 1
}

verbose=false
logfile=''
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -v | --verbose ) verbose=true; shift ;; # one shift since this takes no values
        -l | --logfile ) logfile="$2"; shift 2 ;; # two shifts, because you need to skip to the next flag
        -a | --alpha )   a="$2"; shift 2 || shifterror "$1" ;; # same
        -b | --beta )    b="$2"; shift 2 || shifterror "$1" ;; # same
        -c | --gamma )   c="$2"; shift 2 || shifterror "$1" ;; # same
        -- )             shift; break ;; # shift & break loop to end argparsing
        -* )             echo "Unrecognized option '$1'" >&2 && exit 1 ;; # crash
        * )              break ;; # 
    esac
done

echo $a $b $c
