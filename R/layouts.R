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

#' @rdname layouts
#' @aliases logfmt_log_layout
#' @export
logfmt_log_layout <- function() {
  time_format <- "%Y-%m-%dT%H:%M:%SZ"

  function(level, ...) {
    fields <- list(...)
    if (is.null(names(fields))) {
      fields <- list(msg = paste0(fields, collapse = ""))
    }
    extra <- list(level = level)
    if (!is.na(time_format)) {
      extra$ts <- fmt_current_time(time_format, TRUE)
    }
    encode_logfmt(c(extra, fields))
  }
}

#' @details \code{json_log_layout} requires the \code{jsonlite} package.
#'
#' @rdname layouts
#' @param include_timestamp Include the current timestamp in the output?
#' @export
json_log_layout <- function(include_timestamp = TRUE) {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("The 'jsonlite' package is required to use this JSON layout.")
  }
  force(include_timestamp)
  time_format <- "%Y-%m-%dT%H:%M:%SZ"

  function(level, ...) {
    fields <- list(...)
    if (is.null(names(fields))) {
      fields <- list(message = paste0(fields, collapse = ""))
    }
    fields$level <- as.character(level)
    if (include_timestamp) {
      fields$time <- fmt_current_time(time_format, TRUE)
    }
    jsonlite::toJSON(fields, auto_unbox = TRUE)
  }
}

# Fast C wrapper of strftime() and localtime(). Use with caution.
fmt_current_time <- function(format, use_utc = FALSE) {
  .Call(R_fmt_current_time, format, use_utc)
}

verify_time_format <- function(time_format) {
  tryCatch(fmt_current_time(time_format), error = function(e) {
    stop("Invalid strptime format string. See ?strptime.", call. = FALSE)
  })
}

encode_logfmt <- function(fields) {
  .Call(R_encode_logfmt, fields, PACKAGE = "log4r")
}
