test_that("ts_parse_toml", {
  expect_snapshot({
    ts_parse_toml(toml_example_text())
  })
})

test_that("ts_read_toml", {
  tmp <- tempfile(fileext = ".toml")
  on.exit(unlink(tmp), add = TRUE)
  writeLines(toml_example_text(), tmp)
  expect_snapshot(
    {
      ts_read_toml(tmp)
    },
    transform = redact_tempfile
  )
})
