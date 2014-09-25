#' Set the priority level for a logger object.
#'
#' The priority level can be one of:
#' \code{log4r:::DEBUG}, \code{log4r:::INFO}, \code{log4r:::WARN},
#' \code{log4r:::ERROR} or \code{log4r:::FATAL}
#'
#'
#' @aliases level<-.logger level<-
#' @param x An object of class logger.
#' @param value A level input, specified using the symbolic constants
#' \code{log4r:::DEBUG}, \code{log4r:::INFO}, \code{log4r:::WARN},
#' \code{log4r:::ERROR} and \code{log4r:::FATAL}.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)
#'
#' level(logger) <- log4r:::FATAL
#' @export level<-.logger
`level<-.logger` <-
function(x, value)
{
  x[['level']] <- loglevel(value)
  return(x)
}
