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
#' @seealso \code{\link{tcp_appender}}
#'
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

#' Log Messages via TCP
#'
#' Append messages to arbitrary TCP destinations.
#'
#' @param host Hostname for the socket connection.
#' @param port Port number for the socket connection.
#' @param layout A layout function taking a \code{level} parameter and
#'   additional arguments corresponding to the message.
#' @param timeout Timeout for the connection.
#'
#' @seealso \code{\link{appenders}} for more information on Appenders, and
#'   \code{\link[base]{socketConnection}} for the underlying connection object
#'   used by \code{tcp_appender}.
#'
#' @export
tcp_appender <- function(host, port, layout = default_log_layout(),
                         timeout = getOption("timeout")) {
  stopifnot(is.function(layout))
  layout <- compiler::cmpfun(layout)
  # Use a finalizer pattern to make sure we close the connection.
  env <- new.env(size = 1)
  env$con <- socketConnection(
    host = host, port = port, open = "wb", blocking = TRUE, timeout = timeout
  )
  reg.finalizer(env, function(e) close(e$con), onexit = TRUE)
  function(level, ...) {
    msg <- layout(level, ...)
    writeBin(msg, con = env$con)
  }
}
