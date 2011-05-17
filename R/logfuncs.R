auxf <- function(logger, message, level, str) {
 if (logger[['level']] <= level)
   write.message(logger, paste(str, message))
}

debug <- function(logger, message) { auxf(logger, message, DEBUG, 'DEBUG') }
error <- function(logger, message) { auxf(logger, message, ERROR, 'ERROR') }
fatal <- function(logger, message) { auxf(logger, message, FATAL, 'FATAL') }
info <- function(logger, message) { auxf(logger, message, INFO, 'INFO') }
warn <- function(logger, message) { auxf(logger, message, WARN, 'WARN') }
