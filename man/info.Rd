\name{info}
\alias{info}
\title{
Write messages to logs at the info priority level.
}
\description{
Write messages to logs at the info priority level.
}
\usage{
info(logger, message)
}
\arguments{
  \item{logger}{
	An object of class 'logger'.
}
  \item{message}{
	A string to be printed to the log with priority level \code{log4r:::INFO}.
}
}
\examples{
library('log4r')

logger <- create.logger(path = 'info.log', level = log4r:::INFO)

info(logger, 'This is an informational message.')}
