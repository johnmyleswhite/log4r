`format<-.logger` <-
function(x, value)
{
  x[['format']] <- value
  return(x)
}

