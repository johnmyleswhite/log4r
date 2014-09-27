library('testthat')

library('log4r')

context('Logging levels')

test_that('Creation', {
  expect_that(loglevel(-19), equals(log4r:::DEBUG))
  expect_that(loglevel(-1), equals(log4r:::DEBUG))
  expect_that(loglevel(1), equals(log4r:::DEBUG))
  expect_that(loglevel(2), equals(log4r:::INFO))
  expect_that(loglevel(3), equals(log4r:::WARN))
  expect_that(loglevel(4), equals(log4r:::ERROR))
  expect_that(loglevel(5), equals(log4r:::FATAL))
  expect_that(loglevel(6), equals(log4r:::FATAL))
  expect_that(loglevel(60), equals(log4r:::FATAL))
  expect_that(loglevel("DEBUG"), equals(log4r:::DEBUG))
  expect_that(loglevel("INFO"), equals(log4r:::INFO))
  expect_that(loglevel("WARN"), equals(log4r:::WARN))
  expect_that(loglevel("ERROR"), equals(log4r:::ERROR))
  expect_that(loglevel("FATAL"), equals(log4r:::FATAL))
  expect_error(loglevel("UNLOG"), "unknown logging level: UNLOG")
  expect_error(loglevel("ATA"), "unknown logging level: ATA")
  expect_error(loglevel("WAR"), "unknown logging level: WAR")
  expect_error(loglevel(1:3), "atomic")
  expect_error(loglevel(FALSE), "cannot determine")
})

test_that('Coercion', {
  expect_equal(as.numeric(loglevel("DEBUG")), 1)
  expect_equal(as.character(loglevel("WARN")), "WARN")
  expect_equal(as.loglevel(loglevel("INFO")), loglevel("INFO"))
})

test_that('Available log levels', {
  expect_equal(unname(vapply(available.loglevels(), as.integer, integer(1))), 1:5)
})
