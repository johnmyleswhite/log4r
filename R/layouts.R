#' Default Log Message Layout
#'
#' @param time_format A valid format string for timestamps. See
#'   \code{\link[base]{strptime}}.
#'
#' @export
default_log_layout <- function(time_format = "%Y-%m-%d %H:%M:%S") {
  stopifnot(is.character(time_format))

  function(level, ...) {
    msg <- paste0(..., collapse = "")
    # This appears to be the fastest way to format timestamps.
    time_fmt <- format.POSIXlt(
      as.POSIXlt(Sys.time()), format = time_format, usetz = FALSE
    )
    sprintf("%-5s [%s] %s\n", level, time_fmt, msg)
  }
}
