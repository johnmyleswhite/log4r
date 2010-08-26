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
