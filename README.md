
<!-- README.md is generated from README.Rmd. Please edit that file. -->

# log4r

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/log4r)](https://cran.r-project.org/package=log4r)
[![Travis-CI Build
Status](https://travis-ci.org/johnmyleswhite/log4r.svg?branch=master)](https://travis-ci.org/johnmyleswhite/log4r)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/johnmyleswhite/log4r?branch=master)](https://ci.appveyor.com/project/johnmyleswhite/log4r)
<!-- badges: end -->

**log4r** is a fast, lightweight, object-oriented approach to logging in
R based on the widely-emulated [Apache
Log4j](https://logging.apache.org/log4j/) project.

**log4r** differs from other R logging packages in its focus on
performance and simplicity. As such, it has fewer features – although it
is still quite extensible, as seen below – but is much faster. See
`vignette("performance", package = "log4r")` for details.

## Installation

The package is available from CRAN:

``` r
install.packages("log4r")
```

If you want to use the development version, you can install the package
from GitHub as follows:

``` r
# install.packages("remotes")
remotes::install_github("johnmyleswhite/log4r")
```

## Usage

Logging is configured by passing around `logger` objects created by
`logger()`. By default, this will log to the console and suppress
messages below the `"INFO"` level:

``` r
logger <- logger()

info(logger, "Located nearest gas station.")
#> INFO  [2019-09-04 16:31:04] Located nearest gas station.
warn(logger, "Ez-Gas sensor network is not available.")
#> WARN  [2019-09-04 16:31:04] Ez-Gas sensor network is not available.
debug(logger, "Debug messages are suppressed by default.")
```

Logging destinations are controlled by **Appenders**, a few of which are
provided by the package. For instance, if we want to debug-level
messages to a file:

``` r
log_file <- tempfile()
logger <- logger("DEBUG", appenders = file_appender(log_file))

info(logger, "Messages are now written to the file instead.")
debug(logger, "Debug messages are now visible.")

readLines(log_file)
#> [1] "INFO  [2019-09-04 16:31:04] Messages are now written to the file instead."
#> [2] "DEBUG [2019-09-04 16:31:04] Debug messages are now visible."
```

The `appenders` parameter takes a list, so you can log to multiple
destinations transparently.

To control the format of the messages you can change the **Layout** used
by each appender. Layouts are functions; you can write your own quite
easily:

``` r
my_layout <- function(level, ...) {
  paste0(format(Sys.time()), " [", level, "] ", ..., collapse = "")
}

logger <- logger(appenders = console_appender(my_layout))
info(logger, "Messages should now look a little different.")
#> 2019-09-04 16:31:04 [INFO] Messages should now look a little different.
```

## Older APIs

The 0.2 API is still supported:

``` r
logger <- create.logger()

logfile(logger) <- log_file
level(logger) <- "INFO"

debug(logger, 'A Debugging Message')
info(logger, 'An Info Message')
warn(logger, 'A Warning Message')
error(logger, 'An Error Message')
fatal(logger, 'A Fatal Error Message')

readLines(log_file)
#> [1] "INFO  [2019-09-04 16:31:05] An Info Message"      
#> [2] "WARN  [2019-09-04 16:31:05] A Warning Message"    
#> [3] "ERROR [2019-09-04 16:31:05] An Error Message"     
#> [4] "FATAL [2019-09-04 16:31:05] A Fatal Error Message"
```

## License

The package is available under the terms of the Artistic License 2.0.
