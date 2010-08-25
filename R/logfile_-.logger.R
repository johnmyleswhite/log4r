`logfile<-.logger` <-
function(x, value)
{
  x[['path']] <- value
  return(x)
}

