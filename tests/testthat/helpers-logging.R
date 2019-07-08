expect_file_contains <- function(outfile, regex) {
  expect_true(file.exists(outfile))

  if (file.exists(outfile)) {
    content <- readLines(outfile)

    expect_true(any(grepl(regex, content)))
  }
}
