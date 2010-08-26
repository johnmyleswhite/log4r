\name{logformat.logger}
\alias{logformat.logger}
\alias{logformat}
\title{
Get the format string for a logger object.
}
\description{
Get the format string for a logger object.
}
\usage{
logformat(x)
}
\arguments{
  \item{x}{
	An object of class logger.
}
}
\examples{
library('log4r')

logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)

print(logformat(logger))}
