LEVEL_NAMES <- c("DEBUG", "INFO", "WARN", "ERROR", "FATAL")
LEVELS <- setNames(rev(seq_along(LEVEL_NAMES)), rev(LEVEL_NAMES))

#' Converts an integer to a logging level
#'
#' Converts an integer to an logging level defined in this package.
#'
#'
#' @param i An integer from the set 1..5. Otherwise it will be modified
#' sensibly to fit in that range.
#' @return A logging level from the \code{log4r:::LEVELS} array. Giving
#' anything less or equal than 1 will return \code{log4r:::FATAL}. Giving
#' anything larger or equal than 5 will return \code{log4r:::DEBUG}.
#' @examples
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
#' @export verbosity
verbosity <- function(i)
{
  if (length(i) != 1)
    stop("verbosity accepts only atomic values")

  if (is.numeric(i)) {
    i <- ifelse(i > max(LEVELS), max(LEVELS), i)
    i <- ifelse(i < min(LEVELS), min(LEVELS), i)
  } else if (is.character(i)) {
    name <- i
    i <- which(name == LEVEL_NAMES)
    if (length(i) == 0)
      stop("unknown verbosity level: ", name)
  } else
    stop("cannot determine verbosity from ", typeof(i), " ", i)

  structure(LEVELS[max(LEVELS) - i + 1], class = "verbosity")
}

#' @export
print.verbosity <- function(x, ...) cat(LEVEL_NAMES[[x]], "\n")

#' @export
as.numeric.verbosity <- function(x, ...) unclass(unname(x))

DEBUG <- verbosity("DEBUG")
INFO <- verbosity("INFO")
WARN <- verbosity("WARN")
ERROR <- verbosity("ERROR")
FATAL <- verbosity("FATAL")
