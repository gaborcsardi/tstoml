test_that("serialize_toml", {
  tobj <- list(a = list(b = 1L, c = 2.5, d = "hello"), e = TRUE)
  expect_snapshot({
    tobj
    writeLines(serialize_toml(tobj))
  })

  expect_equal(
    serialize_toml(tobj, collapse = TRUE),
    paste(serialize_toml(tobj), collapse = "\n")
  )

  # remove the first empty line
  tobj2 <- list(a = list(b = 1L, c = 2.5, d = "hello"))
  expect_snapshot({
    tobj2
    writeLines(serialize_toml(tobj2))
  })

  tmp <- tempfile(fileext = ".toml")
  expect_null(serialize_toml(tobj, file = tmp))
  expect_equal(readLines(tmp), serialize_toml(tobj))
})

test_that("get_stl_type", {
  expect_equal(get_stl_type(1L), "pair")
  expect_equal(get_stl_type(list(list(1, 2, 3))), "pair")
  expect_equal(get_stl_type(list()), "pair")

  expect_equal(get_stl_type(list(a = 1L, b = 2L)), "table")
  expect_equal(get_stl_type(structure(list(), names = character())), "table")

  expect_equal(
    get_stl_type(list(list(a = 1L), list(a = 2L))),
    "array_of_tables"
  )
})

test_that("stl_inline", {
  now <- structure(
    1761903534.125,
    class = c("POSIXct", "POSIXt"),
    tzone = "CET"
  )
  expect_snapshot({
    now
    stl_inline(now)
  })

  now2 <- as.POSIXlt(now)
  expect_snapshot({
    now2
    stl_inline(now2)
  })

  today <- as.Date("2025-10-31")
  expect_snapshot({
    today
    stl_inline(today)
  })

  dt <- hms::hms(13.125, 5, 1)
  expect_snapshot({
    dt
    stl_inline(dt)
  })

  inline_table <- list(a = 1, b = as.list(1:3))
  expect_snapshot({
    inline_table
    stl_inline(inline_table)
  })

  a <- complex()
  expect_snapshot(error = TRUE, {
    a
    stl_inline(a)
  })
})
