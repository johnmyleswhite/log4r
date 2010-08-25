\name{warn}
\alias{warn}
\title{
Write messages to logs at the warn priority level.
}
\description{
Write messages to logs at the warn priority level.
}
\usage{
warn(logger, message)
}
\arguments{
  \item{logger}{
	An object of class 'logger'.
}
  \item{message}{
	A string to be printed to the log with priority level \code{log4r:::WARN}.
}
}
\examples{
library('log4r')

logger <- create.logger(path = 'warnings.log', level = log4r:::WARN)

warn(logger, 'Generating an warning message.')}
