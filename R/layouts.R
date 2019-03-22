#' Default Log Message Layout
#'
#' @param level The message level.
#' @param ... Additional message arguments.
#'
#' @export
default_log_layout <- function(level, ...) {
  msg <- paste0(..., collapse = "")
  # This appears to be the fastest way to format timestamps.
  time_fmt <- format.POSIXlt(
    as.POSIXlt(Sys.time()), format = "%Y-%m-%d %H:%M:%S", usetz = FALSE
  )
  sprintf("%-5s [%s] %s\n", level, time_fmt, msg)
}
