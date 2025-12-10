test_that("serialize_toml", {
  tobj <- list(a = list(b = 1L, c = 2.5, d = "hello"), e = TRUE)
  expect_snapshot({
    tobj
    writeLines(ts_serialize_toml(tobj))
  })

  expect_equal(
    ts_serialize_toml(tobj, collapse = TRUE),
    paste(ts_serialize_toml(tobj), collapse = "\n")
  )

  # remove the first empty line
  tobj2 <- list(a = list(b = 1L, c = 2.5, d = "hello"))
  expect_snapshot({
    tobj2
    writeLines(ts_serialize_toml(tobj2))
  })

  tmp <- tempfile(fileext = ".toml")
  expect_null(ts_serialize_toml(tobj, file = tmp))
  expect_equal(readLines(tmp), ts_serialize_toml(tobj))
})

test_that("ts_toml_table", {
  expect_snapshot({
    tbl <- list(tab = ts_toml_table(a = 1L, b = 2.5, c = "hello"))
    writeLines(ts_serialize_toml(tbl))
  })
})

test_that("ts_toml_inline_table", {
  expect_snapshot({
    tbl <- list(tab = ts_toml_inline_table(a = 1L, b = 2.5, c = "hello"))
    writeLines(ts_serialize_toml(tbl))
  })
  expect_snapshot(error = TRUE, {
    ts_toml_inline_table(a = 1, 100)
  })
})

test_that("ts_toml_array", {
  expect_snapshot({
    arr <- list(arr = ts_toml_array(1L, a = 2L, 3L, 4L))
    writeLines(ts_serialize_toml(arr))
  })
})

test_that("ts_toml_array_of_tables", {
  expect_snapshot({
    aot <- list(
      aot = ts_toml_array_of_tables(
        list(name = "Alice", age = 30L),
        list(name = "Bob", age = 25L)
      )
    )
    writeLines(ts_serialize_toml(aot))
  })
  expect_snapshot(error = TRUE, {
    ts_toml_array_of_tables()
  })
  expect_snapshot(error = TRUE, {
    ts_toml_array_of_tables(list(list(1, 2, 3)))
  })
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

test_that("serialize_toml_value", {
  expect_snapshot({
    t <- structure(1763104922, class = c("POSIXct", "POSIXt"), tzone = "UTC")
    ts_serialize_toml_value(t)
    ts_serialize_toml_value(as.POSIXlt(t))
    ts_serialize_toml_value(as.Date("2025-10-31"))
    ts_serialize_toml_value(hms::hms(12, 30, 15))
    ts_serialize_toml_value(list(a = 1, b = 2))
    ts_serialize_toml_value(list(1, 2, 3))
    ts_serialize_toml_value(3.14)
    ts_serialize_toml_value("hello")
    ts_serialize_toml_value(42L)
    ts_serialize_toml_value(TRUE)
  })
})

test_that("array of tables", {
  expect_snapshot({
    aot <- list(
      people = list(
        list(name = "Alice", age = 30L),
        list(name = "Bob", age = 25L)
      )
    )
    writeLines(ts_serialize_toml(aot))
  })

  expect_snapshot({
    aot2 <- list(
      products = list(
        list(
          names = "Hammer",
          sku = 738594937,
          dimensions = list(list(length = 7.0, width = 0.5, height = 0.25))
        ),
        list(
          names = "Nail",
          sku = 284758393,
          color = "gray",
          dimensions = list(list(length = 0.5, width = 0.1, height = 0.1))
        )
      )
    )
    writeLines(ts_serialize_toml(aot2))
  })
})

test_that("float", {
  expect_snapshot({
    writeLines(ts_serialize_toml(list(a = NaN, b = Inf, c = -Inf, d = 3.14)))
  })
})
