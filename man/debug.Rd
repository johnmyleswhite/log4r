\name{debug}
\alias{debug}
\title{
Write messages to logs at the debugging priority level.
}
\description{
Write messages to logs at the debugging priority level.
}
\usage{
debug(logger, message)
}
\arguments{
  \item{logger}{
	An object of class 'logger'.
}
  \item{message}{
	A string to be printed to the log with priority level \code{log4r:::DEBUG}.
}
}
\examples{
library('log4r')

logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)

debug(logger, 'Testing our logger')}
