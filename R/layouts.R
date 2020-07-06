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
#'   \code{\link[base]{strptime}}. For some layouts this can be \code{NA} to
#'   elide the timestamp.
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
  verify_time_format(time_format)

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

#' @rdname layouts
#' @aliases bare_log_layout
#' @export
bare_log_layout <- function() {
  function(level, ...) {
    msg <- paste0(..., collapse = "")
    sprintf("%s\n", msg)
  }
}

#' @details \code{json_log_layout} requires the \code{jsonlite} package.
#'
#' @param pretty When \code{TRUE}, format JSON with whitespace and indentation.
#'
#' @rdname layouts
#' @aliases json_log_layout
#' @export
json_log_layout <- function(pretty = FALSE, time_format = "%Y-%m-%d %H:%M:%S") {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("The 'jsonlite' package is required to use this JSON layout.")
  }
  stopifnot(is.logical(pretty))
  if (!is.na(time_format)) {
    stopifnot(is.character(time_format))
    verify_time_format(time_format)
  }

  function(level, ...) {
    fields <- list(...)
    if (is.null(names(fields))) {
      fields <- list(message = paste0(fields, collapse = ""))
    }
    fields$level <- as.character(level)
    fields$time <- if (!is.na(time_format)) fmt_current_time(time_format)
    jsonlite::toJSON(fields, pretty = pretty, auto_unbox = TRUE)
  }
}

# Fast C wrapper of strftime() and localtime(). Use with caution.
fmt_current_time <- function(format) {
  .Call(R_fmt_current_time, format)
}

verify_time_format <- function(time_format) {
  tryCatch(fmt_current_time(time_format), error = function(e) {
    stop("Invalid strptime format string. See ?strptime.", call. = FALSE)
  })
}
