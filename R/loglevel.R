# Internal use only.
LEVEL_NAMES <- c("DEBUG", "INFO", "WARN", "ERROR", "FATAL")
LEVELS <- factor(LEVEL_NAMES, levels = LEVEL_NAMES, ordered = TRUE)

#' Logging levels
#'
#' Functions for handling logging levels.  With each log entry, a logging level
#' is associated that indicate its severity -- debugging output, informational
#' output, warning message, error message or fatal error.  Each logger only
#' prints log entries where the log level is equal or above its threshold.
#'
#' To specify a logging level, use a character value, e.g. \code{"WARN"},
#' or an integer between 1 and 5. The function \code{available.levels} lists all
#' possible logging levels.
#'
#' @param i An integer from the set 1..5.  Otherwise it will be modified
#'   sensibly to fit in that range.  Alternatively, a named logging level
#'   (one of \Sexpr{paste0('"', log4r:::LEVEL_NAMES, '"', collapse = ", ")}).
#' @param x An object of class "loglevel"
#' @param ... Unused
#' @param v A verbosity level from the set 5..1. For historical reasons, they
#'   do not match the log levels; a verbosity level of 1 corresponds to a
#'   logging level of 5, 2 corresponds to 4, etc.
#' @return An object of class "loglevel"
#' @examples
#' loglevel(2) == loglevel("INFO")
#' loglevel("WARN") < loglevel("ERROR")
#' loglevel(-1)
#' try(loglevel("UNDEFINED"))
#' is.loglevel("DEBUG")
#' is.loglevel(loglevel("DEBUG"))
#' as.numeric(loglevel("FATAL"))
#' available.loglevels()
#'
#' \dontrun{
#' library(optparse)
#' library(log4r)
#'
#' optlist <- list(make_option(c('-v', '--verbosity-level'),
#'   type = "integer",
#'   dest = "verbosity",
#'   default = 1,
#'   help = "Verbosity threshold (5=DEBUG, 4=INFO 3=WARN, 2=ERROR, 1=FATAL)"))
#'
#' optparser <- OptionParser(option_list=optlist)
#' opt <- parse_args(optparser)
#'
#' my.logger <- create.logger(logfile = "", level = verbosity(opt$verbosity))
#'
#' fatal(my.logger, "Fatal message")
#' error(my.logger, "Error message")
#' warn(my.logger, "Warning message")
#' info(my.logger, "Informational message")
#' debug(my.logger, "Debugging message")
#' }
#' @export
loglevel <- function(i)
{
  if (is.loglevel(i))
    return(i)

  if (length(i) != 1)
    stop("loglevel accepts only atomic values")

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

#' @rdname loglevel
#' @export
is.loglevel <- function(x, ...) "loglevel" %in% class(x)

#' @rdname loglevel
#' @export
as.loglevel <- loglevel

#' @rdname loglevel
#' @export
print.loglevel <- function(x, ...) cat(LEVEL_NAMES[[x]], "\n")

#' @rdname loglevel
#' @export
as.numeric.loglevel <- function(x, ...) unclass(unname(x))

#' @rdname loglevel
#' @export
as.character.loglevel <- function(x, ...) LEVEL_NAMES[[x]]

#' @rdname loglevel
#' @export
available.loglevels <- function() lapply(setNames(nm = LEVEL_NAMES), loglevel)

#' @rdname loglevel
#' @export
verbosity <- function(v) {
  if (!is.numeric(v))
    stop("numeric expected")
  loglevel(length(LEVELS) + 1 - v)
}

# Deprecated.
DEBUG <- loglevel("DEBUG")
INFO <- loglevel("INFO")
WARN <- loglevel("WARN")
ERROR <- loglevel("ERROR")
FATAL <- loglevel("FATAL")
