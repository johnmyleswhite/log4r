test_that("The logger threshold works as expected", {
  expect_error(logger(threshold = "UNKNOWN"), "unknown logging level")
  expect_error(logger(threshold = NULL), "must be a string")
  lgr <- logger()
  level(lgr) <- "FATAL"
  expect_snapshot(level(lgr))
})

test_that("Levels can be listed", {
  expect_snapshot(available.loglevels())
})

test_that("The loglevel() constructor works as expected", {
  rlang::local_options(lifecycle_verbosity = "quiet")

  expect_equal(loglevel(-19), DEBUG)
  expect_equal(loglevel(-1), DEBUG)
  expect_equal(loglevel(1), DEBUG)
  expect_equal(loglevel(2), INFO)
  expect_equal(loglevel(3), WARN)
  expect_equal(loglevel(4), ERROR)
  expect_equal(loglevel(5), FATAL)
  expect_equal(loglevel(6), FATAL)
  expect_equal(loglevel(60), FATAL)
  expect_equal(loglevel("DEBUG"), DEBUG)
  expect_equal(loglevel("INFO"), INFO)
  expect_equal(loglevel("WARN"), WARN)
  expect_equal(loglevel("ERROR"), ERROR)
  expect_equal(loglevel("FATAL"), FATAL)

  expect_error(loglevel("UNLOG"), "unknown logging level: UNLOG")
  expect_error(loglevel("ATA"), "unknown logging level: ATA")
  expect_error(loglevel("WAR"), "unknown logging level: WAR")
  expect_error(loglevel(1:3), "must be a string")
  expect_error(loglevel(FALSE), "cannot determine")
})

test_that("Coercion works as expected", {
  rlang::local_options(lifecycle_verbosity = "quiet")

  expect_equal(as.numeric(loglevel("DEBUG")), 1)
  expect_equal(as.character(loglevel("WARN")), "WARN")
  expect_equal(as.loglevel(loglevel("INFO")), loglevel("INFO"))
})

test_that("The verbosity() constructor creates equivalent log levels", {
  rlang::local_options(lifecycle_verbosity = "quiet")

  expect_equal(verbosity(-19), FATAL)
  expect_equal(verbosity(-1), FATAL)
  expect_equal(verbosity(1), FATAL)
  expect_equal(verbosity(2), ERROR)
  expect_equal(verbosity(3), WARN)
  expect_equal(verbosity(4), INFO)
  expect_equal(verbosity(5), DEBUG)
  expect_equal(verbosity(6), DEBUG)
  expect_equal(verbosity(60), DEBUG)
})
