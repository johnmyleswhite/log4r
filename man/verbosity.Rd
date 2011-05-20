\name{verbosity}
\alias{verbosity}
\title{
Converts an integer to a logging level
}
\description{
Converts an integer to an logging level defined in this package.
}
\usage{
verbosity(i)
}
\arguments{
  \item{i}{
	An integer from the set {1..5}. Otherwise it will be modified sensibly
	to fit in that range.
      }
}
\value{A logging level from the \code{log4r:::LEVELS} array. Giving
  anything less or equal than 1 will return  \code{log4r:::FATAL}. Giving
  anything larger or equal than 5 will return  \code{log4r:::DEBUG}. }
\examples{
#!/usr/bin/env Rscript

library(optparse) # or your command line parsing package of choice
library(log4r)

optlist <- list(
  make_option(c('-v', '--verbosity-level'),
    type="integer", dest="verbosity", default=1,
    help="Verbosity threshold (5=DEBUG, 4=INFO 3=WARN, 2=ERROR, 1=FATAL)"))
  optparser <- OptionParser(option_list=optlist)
  opt <- parse_args(optparser)
  my.logger <- create.logger(logfile="", level=verbosity(opt$verbosity))
  fatal(my.logger, "Fatal message")
  error(my.logger, "Error message")
  warn(my.logger, "Warning message")
  info(my.logger, "Informational message")
  debug(my.logger, "Debugging message")
}
