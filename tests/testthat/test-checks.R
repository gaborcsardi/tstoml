test_that("is_string", {
  expect_true(is_string("a"))
  expect_true(is_string(NA_character_, na = TRUE))

  expect_false(is_string(1))
  expect_false(is_string(TRUE))
  expect_false(is_string(c("a", "b")))
  expect_false(is_string(character()))
  expect_false(is_string(NA_character_))
})

test_that("is_count", {
  expect_true(is_count(1))
  expect_true(is_count(10L))
  expect_true(is_count(0))

  expect_false(is_count(-1))
  expect_false(is_count(1.5))
  expect_false(is_count("1"))
  expect_false(is_count(c(1, 2)))
  expect_false(is_count(NA_integer_))
  expect_false(is_count(0, positive = TRUE))
})

test_that("as_count", {
  expect_null(as_count(NULL, null = TRUE))
  expect_equal(as_count(1), 1L)
  expect_equal(as_count(10L), 10L)
  expect_equal(as_count("100"), 100L)

  v1 <- 1:3
  v2 <- NA_integer_
  v3 <- -1
  v4 <- mtcars
  expect_snapshot(error = TRUE, {
    as_count(v1)
    as_count(v2)
    as_count(v3)
    as_count(v4)
  })
})

test_that("as_choice", {
  expect_equal(as_choice("a", letters), "a")
  expect_equal(as_choice("X", letters), "x")

  v1 <- "z"
  expect_snapshot(error = TRUE, {
    as_choice(v1, letters[1:5])
  })

  v2 <- 1:10
  expect_snapshot(error = TRUE, {
    as_choice(v2, letters[1:5])
  })
})

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

test_that("default options", {
  expect_snapshot({
    as_tstoml_options(NULL)
  })
})

test_that("as_tstoml_options", {
  expect_snapshot({
    as_tstoml_options(list(indent_width = 2, indent_style = "space"))
  })

  v1 <- 1:10
  v2 <- list("foo" = "bar", "baz")
  v3 <- list(foo = "bar")
  v4 <- list(indent_width = -2)
  v5 <- list(indent_style = "fancy")
  expect_snapshot(error = TRUE, {
    as_tstoml_options(v1)
    as_tstoml_options(v2)
    as_tstoml_options(v3)
    as_tstoml_options(v4)
    as_tstoml_options(v5)
  })
})
