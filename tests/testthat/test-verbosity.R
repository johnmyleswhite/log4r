library('testthat')

library('log4r')

context('Verbosity')

test_that('Verbosity constructor', {
  expect_that(verbosity(-19), equals(log4r:::FATAL))
  expect_that(verbosity(-1), equals(log4r:::FATAL))
  expect_that(verbosity(1), equals(log4r:::FATAL))
  expect_that(verbosity(2), equals(log4r:::ERROR))
  expect_that(verbosity(3), equals(log4r:::WARN))
  expect_that(verbosity(4), equals(log4r:::INFO))
  expect_that(verbosity(5), equals(log4r:::DEBUG))
  expect_that(verbosity(6), equals(log4r:::DEBUG))
  expect_that(verbosity(60), equals(log4r:::DEBUG))
})
