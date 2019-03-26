#' Creates a logger object.
#'
#' @param logfile The full pathname of the file you want log messages to be
#' written to.
#' @param level The level at which the logger is initialized.  Will be coerced
#'   using \code{\link{as.loglevel}}.
#' @param logformat The format string used when writing messages to the log
#' file.
#' @seealso \code{\link{loglevel}}, \code{\link{level.logger}}
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = "DEBUG")
#' @export create.logger
create.logger <-
function(logfile = 'logfile.log', level = 'FATAL', logformat = NULL)
{
  # TODO: Should we issue a deprecation message?
  out <- logger(
    threshold = level, appenders = file_appender(file = logfile)
  )
  out$logfile <- logfile
  out
}

#' Create Logger Objects
#'
#' This is the main interface for configuring logging behaviour. We adopt the
#' well-known \href{https://logging.apache.org/log4j/}{log4j} etymology:
#' \strong{appenders} are destinations (e.g. the console or a file) where messages
#' are written, and the \strong{layout} is the format of the messages. Both
#' appenders and layouts must be implemented as functions.
#'
#' @param threshold The logging threshold level. Messages with a lower priority
#'   level will be discarded. See \code{\link{loglevel}}.
#' @param appenders The logging appenders; both single appenders and a
#'   \code{list()} of them are supported.
#'
#' @return An object of class \code{"logger"}.
#'
#' @export
logger <- function(threshold = "INFO", appenders = console_appender()) {
  threshold <- as.loglevel(threshold)
  if (!is.list(appenders)) {
    appenders <- list(appenders)
  }
  if (!all(vapply(appenders, is.function, logical(1)))) {
    stop("Appenders must be functions.", call. = FALSE)
  }
  structure(
    list(threshold = threshold, appenders = appenders),
    class = "logger"
  )
}
