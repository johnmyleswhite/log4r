#' Get the format string for a logger object.
#'
#' @aliases logformat.logger logformat
#' @param x An object of class logger.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = log4r:::DEBUG)
#'
#' print(logformat(logger))
#' @export logformat.logger
`logformat.logger` <-
function(x)
{
  return(x[['logformat']])
}
