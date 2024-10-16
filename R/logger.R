#' Create Logger Objects
#'
#' This is the main interface for configuring logging behaviour. We adopt the
#' well-known [log4j](https://logging.apache.org/log4j/) etymology:
#' **[Appenders][appenders]** are destinations (e.g. the console or a file)
#' where messages are written, and the **[Layout][layouts]** is the format of
#' the messages.
#'
#' @param threshold The logging threshold, one of `"DEBUG"`, `"INFO"`, `"WARN"`,
#'   `"ERROR"`, or `"FATAL"`. Messages with a lower severity than the threshold
#'   will be discarded.
#' @param appenders The logging appenders; both single appenders and a `list()`
#'   of them are supported. See **[Appenders][appenders]**.
#'
#' @return An object of class `"logger"`.
#'
#' @examples
#' # By default, messages are logged to the console at the
#' # "INFO" threshold.
#' logger <- logger()
#'
#' log_info(logger, "Located nearest gas station.")
#' log_warn(logger, "Ez-Gas sensor network is not available.")
#' log_debug(logger, "Debug messages are suppressed by default.")
#'
#' @seealso
#'
#' **[Appenders][appenders]** and **[Layouts][layouts]** for information on
#' controlling the behaviour of the logger object.
#'
#' @export
logger <- function(threshold = "INFO", appenders = console_appender()) {
  threshold <- as_level(threshold)
  if (!is.list(appenders)) {
    appenders <- list(appenders)
  }
  if (!all(vapply(appenders, is.function, logical(1)))) {
    cli::cli_abort("{.arg appenders} must be a function or list of functions.")
  }
  appenders <- lapply(appenders, compiler::cmpfun)
  structure(
    list(threshold = threshold, appenders = appenders),
    class = "logger"
  )
}
