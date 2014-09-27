#' Set or get the priority level for a logger object.
#'
#' The priority level can be an integer from the set 1..5 (otherwise it will be
#' modified sensibly to fit in that range), or a named logging level
#' (one of \Sexpr{paste0('"', log4r:::LEVEL_NAMES, '"', collapse = ", ")}).
#' An object of class loglevel is also accepted; other input will be coerced
#' using \code{\link{as.loglevel}}.
#'
#' @param x An object of class logger.
#' @param value A loglevel.
#' @seealso \code{\link{loglevel}}
#' @examples
#'
#' library('log4r')
#'
#' logger <- create.logger(logfile = 'debugging.log', level = 1)
#' level(logger)
#' level(logger) <- "FATAL"
#' @export
`level` <-
  function(x)
  {
    UseMethod('level', x)
  }

#' @rdname level
#' @export
`level<-` <-
  function(x, value)
  {
    UseMethod('level<-', x)
  }

#' @rdname level
#' @export
`level.logger` <-
  function(x)
  {
    return(x[['level']])
  }

#' @rdname level
#' @export
`level<-.logger` <-
  function(x, value)
  {
    x[['level']] <- as.loglevel(value)
    return(x)
  }

