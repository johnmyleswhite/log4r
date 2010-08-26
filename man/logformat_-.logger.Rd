\name{logformat<-.logger}
\alias{logformat<-.logger}
\alias{logformat<-}
\title{
Set the format string for a logger object.
}
\description{
Set the format string for a logger object.
}
\usage{
logformat(x) <- value
}
\arguments{
  \item{x}{
	An object of class logger.
}
  \item{value}{
	A string containing a proper format string.
}
}
\examples{
library('log4r')

logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)

logformat(logger) <- 'FORMAT STRING'}
