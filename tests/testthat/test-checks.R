test_that("as_toml_float", {
  expect_equal(as_toml_float(3.14), 3.14)
  expect_equal(as_toml_float(-2.71), -2.71)
  expect_equal(as_toml_float(0), 0)
  expect_equal(as_toml_float(1L), 1)
  expect_equal(as_toml_float(NA_real_), NaN)
  expect_equal(as_toml_float(NA_integer_), NaN)
  expect_equal(as_toml_float(NaN), NaN)

  v1 <- c(1.0, 2.0)
  v2 <- "3.14"
  expect_snapshot(error = TRUE, {
    as_toml_float(v1)
    as_toml_float(v2)
  })
})

test_that("as_toml_boolean", {
  expect_equal(as_toml_boolean(TRUE), TRUE)
  expect_equal(as_toml_boolean(FALSE), FALSE)

  v1 <- c(TRUE, FALSE)
  v2 <- NA
  v3 <- "TRUE"
  expect_snapshot(error = TRUE, {
    as_toml_boolean(v1)
    as_toml_boolean(v2)
    as_toml_boolean(v3)
  })
})

test_that("as_toml_integer", {
  expect_equal(as_toml_integer(42L), 42L)
  expect_equal(as_toml_integer(-7L), -7L)
  expect_equal(as_toml_integer(0L), 0L)

  v1 <- c(1L, 2L)
  v2 <- NA_integer_
  v3 <- 3.14
  expect_snapshot(error = TRUE, {
    as_toml_integer(v1)
    as_toml_integer(v2)
    as_toml_integer(v3)
  })
})
