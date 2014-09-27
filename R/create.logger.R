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
  logger <- list(logfile = logfile,
                 level = as.loglevel(level),
                 logformat = logformat)

  class(logger) <- 'logger'

  return(logger)
}
