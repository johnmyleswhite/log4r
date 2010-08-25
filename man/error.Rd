\name{error}
\alias{error}
\title{
Write messages to logs at the error priority level.
}
\description{
Write messages to logs at the error priority level.
}
\usage{
error(logger, message)
}
\arguments{
  \item{logger}{
	An object of class 'logger'.
}
  \item{message}{
	A string to be printed to the log with priority level \code{log4r:::ERROR}.
}
}
\examples{
library('log4r')

logger <- create.logger(path = 'error.log', level = log4r:::ERROR)

error(logger, 'Generating an error message.')}
