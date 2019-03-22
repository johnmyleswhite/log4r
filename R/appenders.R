#' Append Logs to a File or the Console
#'
#' The most basic appenders log messages to the console or to a file.
#'
#' @param layout A layout function taking a \code{level} parameter and
#'   additional arguments corresponding to the message. See
#'   \code{\link{default_log_layout}}.
#'
#' @rdname basic_appenders
#' @aliases basic_appenders console_appender
#' @export
console_appender <- function(layout = default_log_layout) {
  file_appender(file = "", layout = layout)
}

#' @param file The file to write messages to.
#' @param append When \code{TRUE}, the file is not truncated when opening for
#'   the first time.
#'
#' @rdname basic_appenders
#' @aliases file_appender
#' @export
file_appender <- function(file, append = TRUE, layout = default_log_layout) {
  stopifnot(is.function(layout))
  function(level, ...) {
    msg <- layout(level, ...)
    cat(msg, file = file, sep = "", append = append)
  }
}
