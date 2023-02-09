test_that('Creation', {
  logger <- create.logger()
  expect_s3_class(logger, "logger")

  logfile(logger) <- file.path('base.log')
  expect_equal(logfile(logger), file.path('base.log'))
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
  expect_true(file.exists(logfile(logger)))

  unlink(logfile(logger))

  info(logger, 'An Info Message')
  expect_true(file.exists(logfile(logger)))

  unlink(logfile(logger))

  warn(logger, 'A Warning Message')
  expect_true(file.exists(logfile(logger)))

  unlink(logfile(logger))

  error(logger, 'An Error Message')
  expect_true(file.exists(logfile(logger)))

  unlink(logfile(logger))

  fatal(logger, 'A Fatal Error Message')
  expect_true(file.exists(logfile(logger)))

  unlink(logfile(logger))
})

test_that('No creation of log file with insufficient level', {
  logger <- create.logger()
  logfile(logger) <- file.path('base.log')

  level(logger) <- "INFO"
  debug(logger, 'A Debugging Message')
  expect_false(file.exists(logfile(logger)))

  level(logger) <- "WARN"
  info(logger, 'An Info Message')
  expect_false(file.exists(logfile(logger)))

  level(logger) <- "ERROR"
  warn(logger, 'A Warning Message')
  expect_false(file.exists(logfile(logger)))

  level(logger) <- "FATAL"
  error(logger, 'An Error Message')
  expect_false(file.exists(logfile(logger)))

  fatal(logger, 'A Fatal Error Message')
  expect_true(file.exists(logfile(logger)))

  unlink(logfile(logger))
})
