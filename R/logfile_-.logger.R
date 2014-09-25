#' Set the logfile for a logger object.
#' 
#' Set the logfile for a logger object. Must be a valid path in an already
#' existing directory.
#' 
#' 
#' @aliases logfile<-.logger logfile<-
#' @param x An object of class logger.
#' @param value The path name of a file to be used for logging.
#' @examples
#' 
#' library('log4r')
#' 
#' logger <- create.logger()
#' 
#' logfile(logger) <- 'debug.log'
#' 
#' debug(logger, 'A Debugging Message')
#' @export logfile<-.logger
`logfile<-.logger` <-
function(x, value)
{
  x[['logfile']] <- value
  return(x)
}

