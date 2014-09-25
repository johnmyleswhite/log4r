#' Creates a logger object.
#' 
#' Creates a logger object.
#' 
#' 
#' @param logfile The full pathname of the file you want log messages to be
#' written to.
#' @param level The level at which the logger is initialized.
#' @param logformat The format string used when writing messages to the log
#' file.
#' @examples
#' 
#' library('log4r')
#' 
#' logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)
#' @export create.logger
create.logger <-
function(logfile = 'logfile.log', level = log4r:::FATAL, logformat = NULL)
{
  logger <- list(logfile = logfile,
                 level = level,
                 logformat = logformat)
  
  class(logger) <- 'logger'
  
  return(logger)
}
