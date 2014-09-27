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
#' fatal(logger, 'I\'m outta here')
#' @export
levellog <- function(logger, level, message) {
  level <- as.loglevel(level)
  if (logger[['level']] <= level)
    write.message(logger, paste(as.character(level), message))
}

#' @rdname levellog
#' @export
debug <- function(logger, message) { levellog(logger, message, level = DEBUG) }

#' @rdname levellog
#' @export
info <- function(logger, message) { levellog(logger, message, level = INFO) }

#' @rdname levellog
#' @export
warn <- function(logger, message) { levellog(logger, message, level = WARN) }

#' @rdname levellog
#' @export
error <- function(logger, message) { levellog(logger, message, level = ERROR) }

#' @rdname levellog
#' @export
fatal <- function(logger, message) { levellog(logger, message, level = FATAL) }
