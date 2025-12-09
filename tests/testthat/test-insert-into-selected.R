test_that("insert_into_document", {
  toml <- ts_parse_toml(text = "")
  expect_snapshot({
    ts_tree_insert(toml, key = "a", 1)
    ts_tree_insert(toml, key = "b", "foobar")
    ts_tree_insert(toml, key = "c", list(1, 2, 3))
    ts_tree_insert(
      toml,
      key = "d",
      structure(list(x = 10, y = 20), class = "ts_toml_inline_table")
    )
    ts_tree_insert(toml, key = "e", ts_toml_inline_table(x = 10, y = 20))
    ts_tree_insert(
      toml,
      key = "f",
      structure(list(list(x = 10, y = 20)), class = "ts_toml_array")
    )
    ts_tree_insert(toml, key = "g", ts_toml_array(10, 20))
  })
})

test_that("insert_into_document table", {
  toml <- ts_parse_toml(text = "")
  expect_snapshot({
    ts_tree_insert(toml, key = "table", list(a = 1, b = 2))
  })

  toml2 <- ts_parse_toml(text = "a = 1\n\n[table]\nb = 2\n")
  expect_snapshot({
    ts_tree_insert(toml2, key = "table2", list(x = 10, y = 20))
  })
})

test_that("insert_into_document array of tables", {
  toml <- ts_parse_toml(text = "")
  expect_snapshot({
    ts_tree_insert(
      toml,
      key = "array_of_tables",
      list(list(a = 1, b = 2), list(a = 3))
    )
  })
})

test_that("insert_into_array", {
  toml <- ts_parse_toml(text = "arr = []")
  expect_snapshot({
    toml |> ts_tree_select("arr") |> ts_tree_insert(0)
    toml |> ts_tree_select("arr") |> ts_tree_insert("foobar")
    toml |> ts_tree_select("arr") |> ts_tree_insert(list(1, 2, 3))
    toml |>
      ts_tree_select("arr") |>
      ts_tree_insert(
        structure(list(x = 10, y = 20), class = "ts_toml_inline_table")
      )
  })

  toml2 <- ts_parse_toml(text = "arr = [1, 2, 3]")
  expect_snapshot({
    toml2 |> ts_tree_select("arr") |> ts_tree_insert(100)
    toml2 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 0)
    toml2 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 1)
    toml2 |> ts_tree_select("arr") |> ts_tree_insert(100, at = Inf)
  })

  toml3 <- ts_parse_toml(text = "arr = [0]")
  expect_snapshot({
    toml3 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 0)
    toml3 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 1)
  })

  toml4 <- ts_parse_toml(text = "arr = [1,2]")
  expect_snapshot({
    toml4 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 0)
    toml4 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 1)
    toml4 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 2)
  })

  toml5 <- ts_parse_toml(text = "arr = [0,]")
  expect_snapshot({
    toml5 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 0)
    toml5 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 1)
  })

  toml6 <- ts_parse_toml(text = "arr = [1,2,]")
  expect_snapshot({
    toml6 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 0)
    toml6 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 1)
    toml6 |> ts_tree_select("arr") |> ts_tree_insert(100, at = 2)
  })
})

test_that("insert_into_inline_table", {
  toml <- ts_parse_toml(text = "it = {}")
  expect_snapshot({
    toml |> ts_tree_select("it") |> ts_tree_insert(13, key = "a")
    toml |> ts_tree_select("it") |> ts_tree_insert("foobar", key = "b")
    toml |> ts_tree_select("it") |> ts_tree_insert(list(1, 2, 3), key = "c")
    toml |>
      ts_tree_select("it") |>
      ts_tree_insert(
        structure(list(x = 10, y = 20), class = "ts_toml_inline_table"),
        key = "d"
      )
  })

  toml2 <- ts_parse_toml(text = "it = {a = 1, b = 2}")
  expect_snapshot({
    toml2 |> ts_tree_select("it") |> ts_tree_insert(13, key = "c")
    toml2 |> ts_tree_select("it") |> ts_tree_insert(13, key = "c", at = 0)
    toml2 |> ts_tree_select("it") |> ts_tree_insert(13, key = "c", at = 1)
    toml2 |> ts_tree_select("it") |> ts_tree_insert(13, key = "c", at = Inf)
  })
})

test_that("insert_into_table pair", {
  toml <- ts_parse_toml(text = "[table]\na = 1\n\n[table2]\nc = 5\n")
  expect_snapshot({
    toml |> ts_tree_select("table") |> ts_tree_insert(2, key = "b")
  })
})

test_that("insert_into_table table", {
  toml <- ts_parse_toml(text = "[table]\na = 1\n\n[table2]\nc = 5\n")
  expect_snapshot({
    toml |>
      ts_tree_select("table") |>
      ts_tree_insert(list(x = 10, y = 20), key = "subtable")
  })
})

test_that("insert_into_table array of tables", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "[table]\na = 1\n\n[table2]\nc = 5\n")
    toml |>
      ts_tree_select("table") |>
      ts_tree_insert(list(list(x = 10, y = 20), list(x = 5)), key = "aot")
  })
})

test_that("insert_into_subtable", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "a.b.c = 1\n")
    toml |> ts_tree_select("a") |> ts_tree_insert(100L, key = "x")
    toml |>
      ts_tree_select("a") |>
      ts_tree_insert(list(x = 100L, y = 200L), key = "x")
    toml |> ts_tree_select("a") |> ts_tree_insert(as.list(1:3), key = "x")
    toml |>
      ts_tree_select("a") |>
      ts_tree_insert(list(list(x = 100L, y = 200L)), key = "x")
  })

  expect_snapshot({
    toml <- ts_parse_toml(text = "[a.b]\nc.d.e = 1\n")
    toml |> ts_tree_select("a", "b", "c") |> ts_tree_insert(100L, key = "x")
  })

  expect_snapshot({
    toml <- ts_parse_toml(text = "[a.b]\nc.d.e = 1\n")
    toml |> ts_tree_select("a") |> ts_tree_insert(100L, key = "x")
  })

  expect_snapshot({
    toml <- ts_parse_toml(text = "[[a.b]]\nc.d.e = 1\n")
    toml |> ts_tree_select("a") |> ts_tree_insert(100L, key = "x")
  })
})

test_that("insert_into_aot_element", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "[[a]]\nb=1\n\n[[a]]\nb=2\n")
    toml |> ts_tree_select("a", 1) |> ts_tree_insert(key = "c", 100L)
    toml |> ts_tree_select("a", 2) |> ts_tree_insert(key = "c", 100L)
    toml |> ts_tree_select("a", 1:2) |> ts_tree_insert(key = "c", 100L)
    toml |>
      ts_tree_select("a", 2) |>
      ts_tree_insert(key = "c", list(1, 2, 3))
    toml |>
      ts_tree_select("a", 2) |>
      ts_tree_insert(
        key = "d",
        structure(list(x = 10, y = 20), class = "ts_toml_inline_table")
      )
  })
})

test_that("insert_into_aot", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "[[a]]\nb=1\n\n[[a]]\nb=2\n")
    toml |> ts_tree_select("a") |> ts_tree_insert(list(b = 3), at = 0)
    toml |> ts_tree_select("a") |> ts_tree_insert(list(b = 3), at = 1)
    toml |> ts_tree_select("a") |> ts_tree_insert(list(b = 3))
  })
  expect_snapshot({
    toml <- ts_parse_toml(
      text = "# prefix\n[[a]]\nb=1\n\n[[a]]\nb=2\n#postfix\n"
    )
    toml |> ts_tree_select("a") |> ts_tree_insert(list(b = 3), at = 0)
    toml |> ts_tree_select("a") |> ts_tree_insert(list(b = 3), at = 1)
    toml |> ts_tree_select("a") |> ts_tree_insert(list(b = 3))
  })
})
