error <-
function(logger, message)
{
  if (logger[['level']] > ERROR)
  {
    return()
  }
  else
  {
    write.message(logger, paste('ERROR', message))
  }
}
