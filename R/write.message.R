#' A hidden function for handling the writing of logging messages.
#'
#' @param logger An object of class logger.
#' @param message A message to be written to the log file. The current
#' timestamp will be appended to this message.
write.message <-
function(logger, message)
{
  output.string <- paste('[',
                         Sys.time(),
                         ']',
                         message,
                         '\n',
                         sep = ' ')
  cat(output.string,
      file = logger[['logfile']],
      append = TRUE)
}
