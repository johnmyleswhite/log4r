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
#' \strong{\link[=appenders]{Appenders}} are destinations (e.g. the console or
#' a file) where messages are written, and the \strong{\link[=layouts]{Layout}}
#' is the format of the messages.
#'
#' @param threshold The logging threshold level. Messages with a lower priority
#'   level will be discarded. See \code{\link{loglevel}}.
#' @param appenders The logging appenders; both single appenders and a
#'   \code{list()} of them are supported. See \code{\link{appenders}}.
#'   The default value, `NULL`, creates an appender that should work well
#'   in your current environment. For example, if you are inside an `.Rmd`
#'   or `.qmd` it will log to `stderr()`, and if you're running on a CI
#'   service or in Posit connect, it will suppress the timestamps (since
#'   they will typically be added automatically).
#'
#' @return An object of class \code{"logger"}.
#'
#' @examples
#' # By default, messages are logged to the console at the
#' # "INFO" threshold.
#' logger <- logger()
#'
#' info(logger, "Located nearest gas station.")
#' warn(logger, "Ez-Gas sensor network is not available.")
#' debug(logger, "Debug messages are suppressed by default.")
#'
#' @seealso
#'
#' \strong{\link[=appenders]{Appenders}} and \strong{\link[=layouts]{Layouts}}
#' for information on controlling the behaviour of the logger object.
#'
#' @export
logger <- function(threshold = "INFO", appenders = NULL) {
  threshold <- as.loglevel(threshold)

  if (is.null(appenders)) {
    appenders <- default_appender()
  }
  if (!is.list(appenders)) {
    appenders <- list(appenders)
  }
  if (!all(vapply(appenders, is.function, logical(1)))) {
    stop("Appenders must be functions.", call. = FALSE)
  }
  appenders <- lapply(appenders, compiler::cmpfun)
  structure(
    list(threshold = threshold, appenders = appenders),
    class = "logger"
  )
}

default_appender <- function() {
  if (on_ci() || on_connect()) {
    layout <- simple_log_layout()
  } else {
    layout <- default_log_layout()
  }

  if (is_knitr()) {
    stderr_appender(layout)
  } else {
    console_appender(layout)
  }
}

is_knitr <- function() {
  isTRUE(getOption("knitr.in.progress", FALSE))
}

on_ci <- function() {
  isTRUE(as.logical(Sys.getenv("CI")))
}
on_connect <- function() {
  identical(Sys.getenv("RSTUDIO_PRODUCT"), "CONNECT")
}
