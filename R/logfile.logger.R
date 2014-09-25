#' Get the logfile for a logger object.
#' 
#' Get the logfile for a logger object.
#' 
#' 
#' @aliases logfile.logger logfile
#' @param x An object of class logger.
#' @examples
#' 
#' library('log4r')
#' 
#' logger <- create.logger()
#' 
#' print(logfile(logger))
#' @export logfile.logger
`logfile.logger` <-
function(x)
{
  return(x[['logfile']])
}
