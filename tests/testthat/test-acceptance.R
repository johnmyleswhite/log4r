library('testthat')

library('log4r')

context('Acceptance')

test_that('Creation', {
  logger <- create.logger()
  expect_that(logger, is_a('logger'))

  logfile(logger) <- file.path('base.log')
  expect_that(logfile(logger), equals(file.path('base.log')))
})

test_that('Logger levels', {
  logger <- create.logger()
  logfile(logger) <- file.path('base.log')

  level(logger) <- log4r:::DEBUG
  expect_true(level(logger) == 1)

  level(logger) <- log4r:::INFO
  expect_true(level(logger) == 2)

  level(logger) <- log4r:::WARN
  expect_true(level(logger) == 3)

  level(logger) <- log4r:::ERROR
  expect_true(level(logger) == 4)

  level(logger) <- log4r:::FATAL
  expect_true(level(logger) == 5)

  unlink(logfile(logger))
})

test_that('Creation of log file on first log entry', {
  logger <- create.logger()
  logfile(logger) <- file.path('base.log')
  level(logger) <- log4r:::DEBUG

  debug(logger, 'A Debugging Message')
  expect_that(file.exists(logfile(logger)), is_true())

  unlink(logfile(logger))

  info(logger, 'An Info Message')
  expect_that(file.exists(logfile(logger)), is_true())

  unlink(logfile(logger))

  warn(logger, 'A Warning Message')
  expect_that(file.exists(logfile(logger)), is_true())

  unlink(logfile(logger))

  error(logger, 'An Error Message')
  expect_that(file.exists(logfile(logger)), is_true())

  unlink(logfile(logger))

  fatal(logger, 'A Fatal Error Message')
  expect_that(file.exists(logfile(logger)), is_true())

  unlink(logfile(logger))
})

test_that('No creation of log file with insufficient level', {
  logger <- create.logger()
  logfile(logger) <- file.path('base.log')

  level(logger) <- "INFO"
  debug(logger, 'A Debugging Message')
  expect_that(file.exists(logfile(logger)), is_false())

  level(logger) <- "WARN"
  info(logger, 'An Info Message')
  expect_that(file.exists(logfile(logger)), is_false())

  level(logger) <- "ERROR"
  warn(logger, 'A Warning Message')
  expect_that(file.exists(logfile(logger)), is_false())

  level(logger) <- "FATAL"
  error(logger, 'An Error Message')
  expect_that(file.exists(logfile(logger)), is_false())

  fatal(logger, 'A Fatal Error Message')
  expect_that(file.exists(logfile(logger)), is_true())

  unlink(logfile(logger))
})
