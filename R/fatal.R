fatal <-
function(logger, message)
{
  if (logger[['level']] > FATAL)
  {
    return()
  }
  else
  {
    write.message(logger, paste('FATAL', message))
  }
}

