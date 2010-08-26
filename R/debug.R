debug <-
function(logger, message)
{
  if (logger[['level']] > DEBUG)
  {
    return()
  }
  else
  {
    write.message(logger, paste('DEBUG', message))
  }
}
