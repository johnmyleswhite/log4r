#' Layouts
#'
#' @description
#'
#' In [log4j](https://logging.apache.org/log4j/) etymology, **Layouts** are how
#' **[Appenders][appenders]** control the format of messages.
#'
#' Some general-purpose layouts are described below.
#'
#' For implementing your own layouts, see Details.
#'
#' @details
#'
#' Layouts are implemented as functions with the interface
#' `function(level, ...)` and returning a single string.
#'
#' @param time_format A valid format string for timestamps. See
#'   [base::strptime()]. For some layouts this can be `NA` to elide the
#'   timestamp.
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
  timestamp <- fmt_current_time(time_format, FALSE)

  function(level, ...) {
    msg <- paste0(..., collapse = "")
    sprintf("%-5s [%s] %s\n", level, timestamp(), msg)
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
  timestamp <- fmt_current_time("%Y-%m-%dT%H:%M:%OSZ", TRUE)

  function(level, ...) {
    fields <- list(...)
    if (is.null(names(fields))) {
      fields <- list(msg = paste0(fields, collapse = ""))
    }
    extra <- list(level = level, ts = timestamp())
    encode_logfmt(c(extra, fields))
  }
}

#' @details `json_log_layout` requires the `jsonlite` package.
#'
#' @rdname layouts
#' @aliases json_log_layout
#' @export
json_log_layout <- function() {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("The 'jsonlite' package is required to use this JSON layout.")
  }
  timestamp <- fmt_current_time("%Y-%m-%dT%H:%M:%OSZ", TRUE)

  function(level, ...) {
    fields <- list(...)
    if (is.null(names(fields))) {
      fields <- list(message = paste0(fields, collapse = ""))
    }
    fields$level <- as.character(level)
    fields$time <- timestamp()
    sprintf("%s\n", jsonlite::toJSON(fields, auto_unbox = TRUE))
  }
}

# Given a strftime format string, return a fast function that outputs the
# current time in that format. This is about 1000x faster than using
# format(Sys.now()).
fmt_current_time <- function(format, use_utc = FALSE) {
  if (!grepl("%OS", format, fixed = TRUE)) {
    return(compiler::cmpfun(function() {
      .Call(R_fmt_current_time, format, use_utc, FALSE, NULL, PACKAGE = "log4r")
    }))
  }
  # If we need fractional seconds, break formatting into three pieces: (1) the
  # bit before %OS; (2) %S plus fractional seconds; and (3) the bit after %OS,
  # if any.
  split <- strsplit(format, "%OS[0-9]?")[[1]]
  prefix <- paste0(split[1], "%S")
  suffix <- NULL
  if (length(split) > 1) {
    suffix <- split[2]
  }
  compiler::cmpfun(function() {
    .Call(R_fmt_current_time, prefix, use_utc, TRUE, suffix, PACKAGE = "log4r")
  })
}

verify_time_format <- function(time_format) {
  tryCatch(fmt_current_time(time_format)(), error = function(e) {
    stop("Invalid strptime format string. See ?strptime.", call. = FALSE)
  })
}

encode_logfmt <- function(fields) {
  .Call(R_encode_logfmt, fields, PACKAGE = "log4r")
}
