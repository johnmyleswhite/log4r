#' Get or set the format string for a logger object.
#'
#' @aliases logformat.logger logformat
#' @param x An object of class logger.
#' @param value A string containing a proper format string.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = "DEBUG")
#' print(logformat(logger))
#' logformat(logger) <- 'FORMAT STRING'
#' @export
`logformat.logger` <-
function(x)
{
  return(x[['logformat']])
}

#' @rdname logformat.logger
#' @export
`logformat<-.logger` <-
  function(x, value)
  {
    x[['logformat']] <- value
    return(x)
  }
