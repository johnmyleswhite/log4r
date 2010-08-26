`logfile<-.logger` <-
function(x, value)
{
  x[['logfile']] <- value
  return(x)
}

