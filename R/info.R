info <-
function(logger, message)
{
  if (logger[['level']] > INFO)
  {
    return()
  }
  else
  {
    write.message(logger, paste('INFO', message))
  }
}

