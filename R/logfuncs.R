auxf <- function(logger, message, level, str) {
 if (logger[['level']] <= level)
   write.message(logger, paste(str, message))
}

#' Write messages to logs at the debugging priority level.
#'
#' @param logger An object of class 'logger'.
#' @param message A string to be printed to the log with priority level
#' \code{log4r:::DEBUG}.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)
#'
#' debug(logger, 'Testing our logger')
#' @export debug
debug <- function(logger, message) { auxf(logger, message, DEBUG, 'DEBUG') }


#' Write messages to logs at the error priority level.
#'
#' @param logger An object of class 'logger'.
#' @param message A string to be printed to the log with priority level
#' \code{log4r:::ERROR}.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'error.log', level = log4r:::ERROR)
#'
#' error(logger, 'Generating an error message.')
#' @export error
error <- function(logger, message) { auxf(logger, message, ERROR, 'ERROR') }


#' Write messages to logs at the fatal priority level.
#'
#' @param logger An object of class 'logger'.
#' @param message A string to be printed to the log with priority level
#' \code{log4r:::FATAL}.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'fatal_error.log', level = log4r:::FATAL)
#'
#' fatal(logger, 'Generating a fatal error message.')
#' @export fatal
fatal <- function(logger, message) { auxf(logger, message, FATAL, 'FATAL') }


#' Write messages to logs at the info priority level.
#'
#' @param logger An object of class 'logger'.
#' @param message A string to be printed to the log with priority level
#' \code{log4r:::INFO}.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'info.log', level = log4r:::INFO)
#'
#' info(logger, 'This is an informational message.')
#' @export info
info <- function(logger, message) { auxf(logger, message, INFO, 'INFO') }


#' Write messages to logs at the warn priority level.
#'
#' @param logger An object of class 'logger'.
#' @param message A string to be printed to the log with priority level
#' \code{log4r:::WARN}.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'warnings.log', level = log4r:::WARN)
#'
#' warn(logger, 'Generating an warning message.')
#' @export warn
warn <- function(logger, message) { auxf(logger, message, WARN, 'WARN') }
