test_that("ts_format_toml", {
  expect_snapshot({
    writeLines(ts_format_toml(text = "foo=1\n\n\nbar=2"))
  })
  expect_snapshot({
    writeLines(ts_format_toml(text = "foo=1\n\n\nbar=2", options = list()))
  })
})
