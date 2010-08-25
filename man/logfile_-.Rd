\name{logfile<-}
\alias{logfile<-}
\title{
Set the logfile for a logger object.
}
\description{
Set the logfile for a logger object. Must be a valid path in an already existing directory.
}
\usage{
logfile(x) <- value
}
\arguments{
  \item{x}{
	An object of class logger.
}
  \item{value}{
	The path name of a file to be used for logging.
}
}
\examples{
library('log4r')

logger <- create.logger()

logfile(logger) <- 'debug.log'

debug(logger, 'A Debugging Message')}
