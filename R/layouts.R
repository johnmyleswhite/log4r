#' Layouts
#'
#' @description
#'
#' In \href{https://logging.apache.org/log4j/}{log4j} etymology,
#' \strong{Layouts} are how \strong{\link[=appenders]{Appenders}} control the
#' format of messages.
#'
#' Some general-purpose layouts are described below.
#'
#' For implementing your own layouts, see Details.
#'
#' @details
#'
#' Layouts are implemented as functions with the interface
#' \code{function(level, ...)} and returning a single string.
#'
#' @param time_format A valid format string for timestamps. See
#'   \code{\link[base]{strptime}}.
#'
#' @examples
#' # The behaviour of a layout can be seen by using them directly:
#' simple <- simple_log_layout()
#' simple("INFO", "Input has length ", 0, ".")
#'
#' with_timestamp <- default_log_layout()
#' with_timestamp("INFO", "Input has length ", 0, ".")
#'
#' @name layouts
#' @rdname layouts
#' @aliases default_log_layout
#' @export
default_log_layout <- function(time_format = "%Y-%m-%d %H:%M:%S") {
  stopifnot(is.character(time_format))

  # Check that the time format works.
  if (inherits(fmt_current_time(time_format), "try-error")) {
    stop("Invalid strptime format string. See ?strptime.")
  }

  function(level, ...) {
    msg <- paste0(..., collapse = "")
    sprintf("%-5s [%s] %s\n", level, fmt_current_time(time_format), msg)
  }
}

#' @rdname layouts
#' @aliases simple_log_layout
#' @export
simple_log_layout <- function() {
  function(level, ...) {
    msg <- paste0(..., collapse = "")
    sprintf("%-5s - %s\n", level, msg)
  }
}

# Fast C wrapper of strftime() and localtime(). Use with caution.
fmt_current_time <- function(format) {
  .Call(R_fmt_current_time, format)
}
