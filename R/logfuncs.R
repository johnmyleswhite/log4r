#' Write messages to logs at a given priority level.
#'
#' @param logger An object of class 'logger'.
#' @param level The desired priority level: a number, a character, or an object
#'   of class 'loglevel'.  Will be coerced using \code{\link{as.loglevel}}.
#' @param ... One or more items to be written to the log at the corresponding
#'   priority level.
#' @seealso \code{\link{loglevel}}
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = "WARN")
#'
#' levellog(logger, 'WARN', 'First warning from our code')
#' trace(logger, "Extra debugging information")
#' debug(logger, 'Debugging our code')
#' info(logger, 'Information about our code')
#' warn(logger, 'Another warning from our code')
#' error(logger, 'An error from our code')
#' fatal(logger, "I'm outta here")
#' @export
levellog <- function(logger, level, ...) {
  level <- as.loglevel(level)
  if (logger$threshold > level) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender(level, ...)
  }
}

log_trace <- function(logger, ...) {
  if (logger$threshold > TRACE) return(invisible(NULL))
  for (appender in logger$appenders) {
    appnder("TRACE", ...)
  }
}

log_debug <- function(logger, ...) {
  if (logger$threshold > DEBUG) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender("DEBUG", ...)
  }
}

log_info <- function(logger, ...) {
  if (logger$threshold > INFO) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender("INFO", ...)
  }
}

log_warn <- function(logger, ...) {
  if (logger$threshold > WARN) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender("WARN", ...)
  }
}

log_error <- function(logger, ...) {
  if (logger$threshold > ERROR) return(invisible(NULL))
  for (appender in logger$appenders) {
    appender("ERROR", ...)
  }
}

log_fatal <- function(logger, ...) {
  # NOTE: It should not be possible to have a higher threshold, so don't check.
  for (appender in logger$appenders) {
    appender("FATAL", ...)
  }
}

#' @rdname levellog
#' @export
trace <- log_trace

#' @rdname levellog
#' @export
debug <- log_debug

#' @rdname levellog
#' @export
info <- log_info

#' @rdname levellog
#' @export
warn <- log_warn

#' @rdname levellog
#' @export
error <- log_error

#' @rdname levellog
#' @export
fatal <- log_fatal
