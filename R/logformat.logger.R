#' Get or set the format string for a logger object.
#'
#' @param x An object of class logger.
#' @param value A string containing a proper format string.
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = 'DEBUG')
#' print(logformat(logger))
#' logformat(logger) <- 'FORMAT STRING'
#' @export
`logformat` <-
  function(x)
  {
    UseMethod('logformat', x)
  }

#' @rdname logformat
#' @export
`logformat<-` <-
function(x, value)
{
  UseMethod('logformat<-', x)
}

#' @rdname logformat
#' @export
`logformat.logger` <-
function(x)
{
  return(x[['logformat']])
}

#' @rdname logformat
#' @export
`logformat<-.logger` <-
  function(x, value)
  {
    x[['logformat']] <- value
    return(x)
  }
