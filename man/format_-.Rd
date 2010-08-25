\name{format<-}
\alias{format<-}
\title{
Set the format string for a logger object.
}
\description{
Set the format string for a logger object.
}
\usage{
format(x) <- value
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

logger <- create.logger(path = 'debugging.log', level = log4r:::DEBUG)

format(logger) <- 'FORMAT STRING'}
