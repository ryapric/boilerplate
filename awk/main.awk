#!/usr/bin/awk -f

# Print first two lines, which includes the header
NR <= 2 { print $0 }
