\name{logfile.logger}
\alias{logfile.logger}
\alias{logfile}
\title{
Get the logfile for a logger object.
}
\description{
Get the logfile for a logger object.
}
\usage{
logfile(x)
}
\arguments{
  \item{x}{
	An object of class logger.
}
}
\examples{
library('log4r')

logger <- create.logger()

print(logfile(logger))}
