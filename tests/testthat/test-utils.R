test_that("%||%", {
  expect_equal(NULL %||% "foo", "foo")
  expect_equal("foo" %||% stop("nope"), "foo")
})

test_that("max_or_na", {
  expect_snapshot({
    max_or_na(1:10)
    max_or_na(c(1:10, NA))
    max_or_na(c(1:10, NA), na.rm = TRUE)
    max_or_na(integer(0))
    max_or_na(numeric(0))
  })
})

test_that("middle", {
  expect_equal(middle(integer()), integer())
  expect_equal(middle(1L), integer())
  expect_equal(middle(1:2), integer())
  expect_equal(middle(1:10), 2:9)
})
