`level<-.logger` <-
function(x, value)
{
  if (!(value %in% LEVELS))
  {
    stop('Attempt to set an invalid logger level failed.')
  }
  
  x[['level']] <- value
  return(x)
}

