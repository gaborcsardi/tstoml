test_that("max_or_na", {
  expect_snapshot({
    max_or_na(1:10)
    max_or_na(c(1:10, NA))
    max_or_na(c(1:10, NA), na.rm = TRUE)
    max_or_na(integer(0))
    max_or_na(numeric(0))
  })
})
