context("verbosity")

test_that("The verbosity() constructor creates equivalent log levels", {
  expect_equal(verbosity(-19), FATAL)
  expect_equal(verbosity(-1), FATAL)
  expect_equal(verbosity(1), FATAL)
  expect_equal(verbosity(2), ERROR)
  expect_equal(verbosity(3), WARN)
  expect_equal(verbosity(4), INFO)
  expect_equal(verbosity(5), DEBUG)
  expect_equal(verbosity(6), TRACE)
  expect_equal(verbosity(60), TRACE)
})
