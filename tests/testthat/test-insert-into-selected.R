test_that("insert_into_document", {
  toml <- load_toml(text = "")
  expect_snapshot({
    insert_into_selected(toml, key = "a", 1)
    insert_into_selected(toml, key = "b", "foobar")
    insert_into_selected(toml, key = "c", list(1, 2, 3))
    insert_into_selected(
      toml,
      key = "d",
      structure(list(x = 10, y = 20), class = "ts_toml_inline_table")
    )
    insert_into_selected(toml, key = "e", ts_toml_inline_table(x = 10, y = 20))
    insert_into_selected(
      toml,
      key = "f",
      structure(list(list(x = 10, y = 20)), class = "ts_toml_array")
    )
    insert_into_selected(toml, key = "g", ts_toml_array(10, 20))
  })
})

test_that("insert_into_document table", {
  toml <- load_toml(text = "")
  expect_snapshot({
    insert_into_selected(toml, key = "table", list(a = 1, b = 2))
  })

  toml2 <- load_toml(text = "a = 1\n\n[table]\nb = 2\n")
  expect_snapshot({
    insert_into_selected(toml2, key = "table2", list(x = 10, y = 20))
  })
})

test_that("insert_into_document array of tables", {
  toml <- load_toml(text = "")
  expect_snapshot({
    insert_into_selected(
      toml,
      key = "array_of_tables",
      list(list(a = 1, b = 2), list(a = 3))
    )
  })
})

test_that("insert_into_array", {
  toml <- load_toml(text = "arr = []")
  expect_snapshot({
    toml |> select("arr") |> insert_into_selected(0)
    toml |> select("arr") |> insert_into_selected("foobar")
    toml |> select("arr") |> insert_into_selected(list(1, 2, 3))
    toml |>
      select("arr") |>
      insert_into_selected(
        structure(list(x = 10, y = 20), class = "ts_toml_inline_table")
      )
  })

  toml2 <- load_toml(text = "arr = [1, 2, 3]")
  expect_snapshot({
    toml2 |> select("arr") |> insert_into_selected(100)
    toml2 |> select("arr") |> insert_into_selected(100, at = 0)
    toml2 |> select("arr") |> insert_into_selected(100, at = 1)
    toml2 |> select("arr") |> insert_into_selected(100, at = Inf)
  })

  toml3 <- load_toml(text = "arr = [0]")
  expect_snapshot({
    toml3 |> select("arr") |> insert_into_selected(100, at = 0)
    toml3 |> select("arr") |> insert_into_selected(100, at = 1)
  })

  toml4 <- load_toml(text = "arr = [1,2]")
  expect_snapshot({
    toml4 |> select("arr") |> insert_into_selected(100, at = 0)
    toml4 |> select("arr") |> insert_into_selected(100, at = 1)
    toml4 |> select("arr") |> insert_into_selected(100, at = 2)
  })

  toml5 <- load_toml(text = "arr = [0,]")
  expect_snapshot({
    toml5 |> select("arr") |> insert_into_selected(100, at = 0)
    toml5 |> select("arr") |> insert_into_selected(100, at = 1)
  })

  toml6 <- load_toml(text = "arr = [1,2,]")
  expect_snapshot({
    toml6 |> select("arr") |> insert_into_selected(100, at = 0)
    toml6 |> select("arr") |> insert_into_selected(100, at = 1)
    toml6 |> select("arr") |> insert_into_selected(100, at = 2)
  })
})

test_that("insert_into_inline_table", {
  toml <- load_toml(text = "it = {}")
  expect_snapshot({
    toml |> select("it") |> insert_into_selected(13, key = "a")
    toml |> select("it") |> insert_into_selected("foobar", key = "b")
    toml |> select("it") |> insert_into_selected(list(1, 2, 3), key = "c")
    toml |>
      select("it") |>
      insert_into_selected(
        structure(list(x = 10, y = 20), class = "ts_toml_inline_table"),
        key = "d"
      )
  })

  toml2 <- load_toml(text = "it = {a = 1, b = 2}")
  expect_snapshot({
    toml2 |> select("it") |> insert_into_selected(13, key = "c")
    toml2 |> select("it") |> insert_into_selected(13, key = "c", at = 0)
    toml2 |> select("it") |> insert_into_selected(13, key = "c", at = 1)
    toml2 |> select("it") |> insert_into_selected(13, key = "c", at = Inf)
  })
})

test_that("insert_into_table pair", {
  toml <- load_toml(text = "[table]\na = 1\n\n[table2]\nc = 5\n")
  expect_snapshot({
    toml |> select("table") |> insert_into_selected(2, key = "b")
  })
})

test_that("insert_into_table table", {
  toml <- load_toml(text = "[table]\na = 1\n\n[table2]\nc = 5\n")
  expect_snapshot({
    toml |>
      select("table") |>
      insert_into_selected(list(x = 10, y = 20), key = "subtable")
  })
})

test_that("insert_into_table array of tables", {
  expect_snapshot({
    toml <- load_toml(text = "[table]\na = 1\n\n[table2]\nc = 5\n")
    toml |>
      select("table") |>
      insert_into_selected(list(list(x = 10, y = 20), list(x = 5)), key = "aot")
  })
})

test_that("insert_into_subtable", {
  expect_snapshot({
    toml <- load_toml(text = "a.b.c = 1\n")
    toml |> select("a") |> insert_into_selected(100L, key = "x")
    toml |>
      select("a") |>
      insert_into_selected(list(x = 100L, y = 200L), key = "x")
    toml |> select("a") |> insert_into_selected(as.list(1:3), key = "x")
    toml |>
      select("a") |>
      insert_into_selected(list(list(x = 100L, y = 200L)), key = "x")
  })

  expect_snapshot({
    toml <- load_toml(text = "[a.b]\nc.d.e = 1\n")
    toml |> select("a", "b", "c") |> insert_into_selected(100L, key = "x")
  })

  expect_snapshot({
    toml <- load_toml(text = "[a.b]\nc.d.e = 1\n")
    toml |> select("a") |> insert_into_selected(100L, key = "x")
  })

  expect_snapshot({
    toml <- load_toml(text = "[[a.b]]\nc.d.e = 1\n")
    toml |> select("a") |> insert_into_selected(100L, key = "x")
  })
})

test_that("insert_into_aot_element", {
  expect_snapshot({
    toml <- load_toml(text = "[[a]]\nb=1\n\n[[a]]\nb=2\n")
    toml |> select("a", 1) |> insert_into_selected(key = "c", 100L)
    toml |> select("a", 2) |> insert_into_selected(key = "c", 100L)
    toml |> select("a", 1:2) |> insert_into_selected(key = "c", 100L)
    toml |>
      select("a", 2) |>
      insert_into_selected(key = "c", list(1, 2, 3))
    toml |>
      select("a", 2) |>
      insert_into_selected(
        key = "d",
        structure(list(x = 10, y = 20), class = "ts_toml_inline_table")
      )
  })
})
