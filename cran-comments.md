## Release Summary

This is a bugfix release fixing a serious crash.

## Test Environments

- winbuilder (r-devel)
- R-hub debian-gcc-release (r-release)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check Results

winbuilder has a NOTE due to the short release window. This is expected, but
this release fixes a critical bug.

> * checking CRAN incoming feasibility ... NOTE
> Maintainer: ‘Aaron Jacobs ’
> Days since last update: 6

On Windows only, two NOTEs appear:

> * checking package dependencies ... NOTE
> Package suggested but not available for checking: 'rsyslog'

> * checking Rd cross-references ... NOTE
> Package unavailable to check Rd xrefs: 'rsyslog'

These are due to listing the rsyslog package in Suggests, which is not available
for Windows (it is Unix-only). This is an optional dependency and does not
affect Windows users.

0 errors | 0 warning | 3 notes
