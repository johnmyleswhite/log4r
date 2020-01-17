#' Appenders
#'
#' @description
#'
#' In \href{https://logging.apache.org/log4j/}{log4j} etymology,
#' \strong{Appenders} are destinations where messages are written. Depending on
#' the nature of the destination, the format of the messages may be controlled
#' using a \strong{\link[=layouts]{Layout}}.
#'
#' The most basic appenders log messages to the console or to a file; these are
#' described below.
#'
#' For implementing your own appenders, see Details.
#'
#' @details
#'
#' Appenders are implemented as functions with the interface
#' \code{function(level, ...)}. These functions are expected to write their
#' arguments to a destination and return \code{invisible(NULL)}.
#'
#' @param layout A layout function taking a \code{level} parameter and
#'   additional arguments corresponding to the message. See
#'   \code{\link{layouts}}.
#'
#' @examples
#' # The behaviour of an appender can be seen by using them directly; the
#' # following snippet will write the message to the console.
#' appender <- console_appender()
#' appender("INFO", "Input has length ", 0, ".")
#'
#' @name appenders
#' @rdname appenders
#' @aliases console_appender
#' @export
console_appender <- function(layout = default_log_layout()) {
  file_appender(file = "", layout = layout)
}

#' @param file The file to write messages to.
#' @param append When \code{TRUE}, the file is not truncated when opening for
#'   the first time.
#'
#' @rdname appenders
#' @aliases file_appender
#' @export
file_appender <- function(file, append = TRUE, layout = default_log_layout()) {
  stopifnot(is.function(layout))
  layout <- compiler::cmpfun(layout)
  force(file)
  force(append)
  function(level, ...) {
    msg <- layout(level, ...)
    cat(msg, file = file, sep = "", append = append)
  }
}
