context("appenders")

test_that("The console appender works correctly", {
  appender <- console_appender(simple_log_layout())
  expect_output(appender("Message"), "Message")
})

test_that("The file appender works correctly", {
  outfile <- tempfile("log")
  appender <- file_appender(outfile, layout = simple_log_layout())

  expect_silent(appender("Message"))
  expect_file_contains(outfile, regex = "Message")
})

test_that("Layout arguments are checked", {
  expect_error(console_appender("notalayout"))
  expect_error(file_appender(tempfile("log"), layout = "notalayout"))
  expect_error(tcp_appender(layout = "notalayout"))
})

test_that("Lazy evaluation does not lead to surprising results", {
  x <- "foo.txt"
  y <- TRUE
  appender <- file_appender(file = x, append = y)
  x <- "bar.txt"
  y <- FALSE

  # Check that mutating the parent environment does not modify them in the
  # frame in which the appender evaluates.
  expect_equal(environment(appender)$file, "foo.txt")
  expect_equal(environment(appender)$append, TRUE)
})
