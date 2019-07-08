context("loglevel")

test_that("The loglevel() constructor works as expected", {
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
  expect_error(loglevel(1:3), "atomic")
  expect_error(loglevel(FALSE), "cannot determine")
})

test_that("Coercion works as expected", {
  expect_equal(as.numeric(loglevel("DEBUG")), 1)
  expect_equal(as.character(loglevel("WARN")), "WARN")
  expect_equal(as.loglevel(loglevel("INFO")), loglevel("INFO"))
})

test_that("All log levels are available", {
  expect_equal(unname(vapply(available.loglevels(), as.integer, integer(1))), 1:5)
})
