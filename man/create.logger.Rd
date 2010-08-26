\name{create.logger}
\alias{create.logger}
\title{
Creates a logger object.
}
\description{
Creates a logger object.
}
\usage{
create.logger(logfile = "logfile.log", level = log4r:::FATAL, logformat = NULL)
}
\arguments{
  \item{logfile}{
	The full pathname of the file you want log messages to be written to.
}
  \item{level}{
	The level at which the logger is initialized.
}
  \item{logformat}{
	The format string used when writing messages to the log file.
}
}
\examples{
library('log4r')

logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)}
