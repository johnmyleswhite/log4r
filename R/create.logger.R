create.logger <-
function(logfile = 'logfile.log', level = log4r:::FATAL, logformat = NULL)
{
  logger <- list(logfile = logfile,
                 level = level,
                 logformat = logformat)
  
  class(logger) <- 'logger'
  
  return(logger)
}
