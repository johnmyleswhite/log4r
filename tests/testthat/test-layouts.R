context("layouts")

test_that("Basic layouts work correctly", {
  layout <- simple_log_layout()
  expect_match(layout("INFO", "Message"), "Message")

  layout <- default_log_layout()
  expect_match(layout("INFO", "Message"), "Message")

  layout <- bare_log_layout()
  expect_match(layout("INFO", "Message"), "Message")
})

test_that("Wonky times formats are caught early", {
  expect_error(default_log_layout(strrep("%Y", 30)), regex = "Invalid")
})
