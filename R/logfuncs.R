#' Write messages to logs at a given priority level.
#'
#' @param logger An object of class 'logger'.
#' @param level The desired priority level: a number, a character, or an object
#'   of class 'loglevel'.  Will be coerced using \code{\link{as.loglevel}}.
#' @param message A string to be printed to the log with the corresponding priority level.
#' @seealso \code{\link{loglevel}}
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = "WARN")
#'
#' levellog(logger, 'WARN', 'First warning from our code')
#' debug(logger, 'Debugging our code')
#' info(logger, 'Information about our code')
#' warn(logger, 'Another warning from our code')
#' error(logger, 'An error from our code')
#' fatal(logger, "I'm outta here")
#' @export
levellog <- function(logger, level, message) {
  level <- as.loglevel(level)
  if (logger$threshold > level) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender(level, message)
  }
}

#' @rdname levellog
#' @export
debug <- function(logger, message) log_debug(logger, message)

log_debug <- function(logger, ...) {
  if (logger$threshold > DEBUG) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender("DEBUG", ...)
  }
}

#' @rdname levellog
#' @export
info <- function(logger, message) log_info(logger, message)

log_info <- function(logger, ...) {
  if (logger$threshold > INFO) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender("INFO", ...)
  }
}

#' @rdname levellog
#' @export
warn <- function(logger, message) log_warn(logger, message)

log_warn <- function(logger, ...) {
  if (logger$threshold > WARN) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender("WARN", ...)
  }
}

#' @rdname levellog
#' @export
error <- function(logger, message) log_error(logger, message)

log_error <- function(logger, ...) {
  if (logger$threshold > ERROR) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender("ERROR", ...)
  }
}

#' @rdname levellog
#' @export
fatal <- function(logger, message) log_fatal(logger, message)

log_fatal <- function(logger, ...) {
  # NOTE: It should not be possible to have a higher threshold, so don't check.
  for (appender in logger$appenders) {
    appender("FATAL", ...)
  }
}
