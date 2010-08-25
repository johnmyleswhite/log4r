warn <-
function(logger, message)
{
  if (logger[['level']] > WARN)
  {
    return()
  }
  else
  {
    write.message(logger, paste('WARN', message))
  }
}

