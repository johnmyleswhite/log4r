#' Get or set the logfile for a logger object.
#'
#' @param x An object of class logger.
#' @param value The path name of a file to be used for logging. Must be a valid
#'   path in an already existing directory
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger()
#' print(logfile(logger))
#' logfile(logger) <- 'debug.log'
#' debug(logger, 'A Debugging Message')
#' @export
`logfile` <-
  function(x)
  {
    UseMethod('logfile', x)
  }

#' @rdname logfile
#' @export
`logfile<-` <-
  function(x, value)
  {
    UseMethod('logfile<-', x)
  }

#' @rdname logfile
#' @export
`logfile.logger` <-
  function(x)
  {
    return(x[['logfile']])
  }

#' @rdname logfile
#' @export
`logfile<-.logger` <-
  function(x, value)
  {
    x[['logfile']] <- value
    return(x)
  }
