\name{create.logger}
\alias{create.logger}
\title{
Creates a logger object.
}
\description{
Creates a logger object.
}
\usage{
create.logger(path = "logfile.log", level = log4r:::FATAL, format = NULL)
}
\arguments{
  \item{path}{
	The full pathname of the file you want log messages to be written to.
}
  \item{level}{
	The level at which the logger is initialized.
}
  \item{format}{
	The format string used when writing messages to the log file.
}
}
\examples{
library('log4r')

logger <- create.logger(path = 'debugging.log', level = log4r:::DEBUG)}
