`logformat<-.logger` <-
function(x, value)
{
  x[['logformat']] <- value
  return(x)
}
