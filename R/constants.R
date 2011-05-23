DEBUG <- 1
INFO <- 2
WARN <- 3
ERROR <- 4
FATAL <- 5
LEVELS <- seq(DEBUG, FATAL)

verbosity <- function(i) {
  i <- ifelse(i>max(LEVELS), max(LEVELS), i)
  i <- ifelse(i<min(LEVELS), min(LEVELS), i)
  return(LEVELS[max(LEVELS)-i+1])
}
