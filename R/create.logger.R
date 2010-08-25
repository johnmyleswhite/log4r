create.logger <-
function(path = 'logfile.log', level = FATAL, format = NULL)
{
  logger <- list(path = path,
                 level = level,
                 format = format)
  
  class(logger) <- 'logger'
  
  return(logger)
}

