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
})
