\name{level.logger}
\alias{level.logger}
\alias{level}
\title{
Get the priority level for a logger object.
}
\description{
Get the priority level for a logger object. This can be one of five levels: \code{log4r:::DEBUG}, \code{log4r:::INFO}, \code{log4r:::WARN}, \code{log4r:::ERROR} or \code{log4r:::FATAL}
}
\usage{
level(x)
}
\arguments{
  \item{x}{
	An object of class logger.
}
}
\examples{
library('log4r')

logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)

print(level(logger))}
