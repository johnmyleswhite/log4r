#' Set the logging threshold level for a logger dynamically
#'
#' It can sometimes be useful to change the logging threshold level at runtime.
#' The [`level()`] accessor allows doing so.
#'
#' @param x An object of class `"logger"`.
#' @param value One of `"DEBUG"`, `"INFO"`, `"WARN"`, `"ERROR"`, or `"FATAL"`.
#'
#' @examples
#' lgr <- logger()
#' level(lgr) # Prints "INFO".
#' info(lgr, "This message is shown.")
#' level(lgr) <- "FATAL"
#' info(lgr, "This message is now suppressed.")
#' @export
level <- function(x) {
  UseMethod("level", x)
}

#' @rdname level
#' @export
`level<-` <- function(x, value) {
  UseMethod("level<-", x)
}

#' @rdname level
#' @export
level.logger <- function(x) x$threshold

#' @rdname level
#' @export
`level<-.logger` <- function(x, value) {
  x$threshold <- as_level(value)
  x
}

# Converts strings like "INFO" or "ERROR" to the internal level representation.
# For historical reasons we also accept integers.
as_level <- function(i) {
  if (inherits(i, "loglevel")) {
    return(i)
  }

  if (length(i) != 1) {
    stop("The log level must be a string or single integer")
  }

  if (is.numeric(i)) {
    i <- min(i, length(LEVELS))
    i <- max(i, 1)
  } else if (is.character(i)) {
    name <- i
    i <- which(name == levels(LEVELS))
    if (length(i) == 0)
      stop("unknown logging level: ", name)
  } else
    stop("cannot determine loglevel from ", typeof(i), " ", i)

  structure(LEVELS[[i]], class = "loglevel")
}

# Internal constants.
LEVEL_NAMES <- c("DEBUG", "INFO", "WARN", "ERROR", "FATAL")
LEVELS <- factor(LEVEL_NAMES, levels = LEVEL_NAMES, ordered = TRUE)
DEBUG <- as_level("DEBUG")
INFO <- as_level("INFO")
WARN <- as_level("WARN")
ERROR <- as_level("ERROR")
FATAL <- as_level("FATAL")

#' @rdname level
#' @export
available.loglevels <- function() lapply(stats::setNames(nm = LEVEL_NAMES), as_level)
