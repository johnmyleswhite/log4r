context("layouts")

test_that("Basic layouts work correctly", {
  layout <- simple_log_layout()
  expect_match(layout("INFO", "Message"), "Message")
  expect_match(
    layout("INFO", "Message ", "in a", " bottle."),
    "Message in a bottle."
  )

  layout <- default_log_layout()
  expect_match(layout("INFO", "Message"), "Message")
  expect_match(
    layout("INFO", "Message ", "in a", " bottle."),
    "Message in a bottle."
  )

  layout <- bare_log_layout()
  expect_match(layout("INFO", "Message"), "Message")
  expect_match(
    layout("INFO", "Message ", "in a", " bottle."),
    "Message in a bottle."
  )
})

test_that("JSON layouts work correctly", {
  skip_if_not_installed("jsonlite")

  layout <- json_log_layout()
  expect_match(layout("INFO", "Message"), "\"message\":\"Message\"")
  expect_match(layout("INFO", field = "value"), "\"field\":\"value\"")
})

test_that("Wonky times formats are caught early", {
  expect_error(default_log_layout(strrep("%Y", 30)), regex = "Invalid")
})
