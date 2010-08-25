library('testthat')

library('log4r')

logger <- create.logger()
expect_that(logger, is_a('logger'))

logfile(logger) <- file.path('base.log')
expect_that(logger[['path']], equals(file.path('base.log')))

level(logger) <- log4r:::DEBUG
expect_that(logger[['level']], equals(1))

level(logger) <- log4r:::INFO
expect_that(logger[['level']], equals(2))

level(logger) <- log4r:::WARN
expect_that(logger[['level']], equals(3))

level(logger) <- log4r:::ERROR
expect_that(logger[['level']], equals(4))

level(logger) <- log4r:::FATAL
expect_that(logger[['level']], equals(5))

# debug(logger, 'A Debugging Message')
# info(logger, 'An Info Message')
# warn(logger, 'A Warning Message')
# error(logger, 'An Error Message')
# fatal(logger, 'A Fatal Error Message')
