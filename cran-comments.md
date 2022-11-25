## Release Summary

This is a bugfix release fixing a memory corruption issue detected by rchk on
CRAN.

## Test Environments

- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)
- R-hub linux-x86_64-rocker-gcc-san (r-devel)

## R CMD check Results

On Windows only, two NOTEs appear:

> * checking package dependencies ... NOTE
> Package suggested but not available for checking: 'rsyslog'

> * checking Rd cross-references ... NOTE
> Package unavailable to check Rd xrefs: 'rsyslog'

These are due to listing the rsyslog package in Suggests, which is not available
for Windows (it is Unix-only). This is an optional dependency and does not
affect Windows users.

0 errors | 0 warning | 2 notes
