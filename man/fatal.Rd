\name{fatal}
\alias{fatal}
\title{
Write messages to logs at the fatal priority level.
}
\description{
Write messages to logs at the fatal priority level.
}
\usage{
fatal(logger, message)
}
\arguments{
  \item{logger}{
	An object of class 'logger'.
}
  \item{message}{
	A string to be printed to the log with priority level \code{log4r:::FATAL}.
}
}
\examples{
library('log4r')

logger <- create.logger(path = 'fatal_error.log', level = log4r:::FATAL)

fatal(logger, 'Generating a fatal error message.')}
