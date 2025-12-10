test_that("get_selection", {
  toml <- ts_parse_toml(toml_example_text())
  expect_snapshot({
    ts_tree_selection(toml, default = FALSE)
    ts_tree_selection(toml)
    ts_tree_selection(toml |> ts_tree_select("owner"))
  })
})

test_that("get_selected_nodes", {
  toml <- ts_parse_toml(toml_example_text())
  expect_snapshot({
    ts_tree_selected_nodes(toml, default = FALSE)
    ts_tree_selected_nodes(toml)
    ts_tree_selected_nodes(toml |> ts_tree_select("owner"))
  })
})

test_that("select 1", {
  # some basics only, more specific tests are below
  toml <- ts_parse_toml(toml_example_text())
  expect_snapshot({
    toml |> ts_tree_select("owner")
    toml |> ts_tree_select("servers", "alpha", "ip")
    toml |> ts_tree_select("servers", "beta", 2)
  })
})

test_that("select 2", {
  toml <- ts_parse_toml(toml_example_text())
  expect_null(
    toml |> ts_tree_select(NULL) |> ts_tree_selection(default = FALSE)
  )
})

test_that("[[.tstoml 1", {
  toml <- ts_parse_toml(toml_example_text())
  expect_snapshot({
    toml[["owner"]]
    toml[["servers", "alpha", "ip"]]
    toml[["servers", "beta", 2]]
  })
})

test_that("[[.tstoml 2", {
  toml <- ts_parse_toml("a=1\nb=2\n")
  expect_snapshot({
    toml[[]]
  })
})

test_that("I()", {
  toml <- ts_parse_toml(toml_example_text())
  expect_snapshot({
    toml |> ts_tree_select(I(11))
  })
})

test_that("select_query", {
  toml <- ts_parse_toml(toml_example_text())
  expect_snapshot({
    toml |> ts_tree_select(query = "(float) @float")
  })

  # select all ip = <string> values
  expect_snapshot({
    toml |>
      ts_tree_select(
        query = list(
          "((pair (bare_key) @key (string) @str) (#eq? @key \"ip\"))",
          "str"
        )
      )
  })

  # error
  expect_snapshot(error = TRUE, {
    toml |> ts_tree_select(query = list("(float) @float", "bad"))
  })

  # nothing selected
  expect_snapshot({
    toml |> ts_tree_select(query = "(table_array_element) @aot")
  })
})

test_that("select refine = TRUE", {
  toml <- ts_parse_toml(toml_example_text())
  expect_snapshot({
    toml |> ts_tree_select("owner") |> ts_tree_select(refine = TRUE, "name")
  })
})

test_that("select1", {
  toml <- ts_parse_toml(toml_example_text())
  expect_snapshot({
    toml |> ts_tree_select(I(11))
    toml |> ts_tree_select("owner", TRUE)
  })
  expect_snapshot(error = TRUE, {
    toml |> ts_tree_select("owner", FALSE)
  })
})

test_that("select1_true", {
  withr::local_options(cli.num_colors = 256)
  # inside an AOT element
  toml <- ts_parse_toml(toml_aot_example())
  expect_snapshot({
    toml |> ts_tree_select("products")
    toml |> ts_tree_select("products", TRUE)
    toml |> ts_tree_select("products", TRUE, TRUE)
  })

  # in document
  expect_snapshot({
    ts_parse_toml("a=1\nb=2\n[tab]\nc=3\n") |> ts_tree_select(TRUE)
  })

  # dotted key in document
  expect_snapshot({
    ts_parse_toml("[a.b.c]\nx=1\n") |> ts_tree_select(TRUE)
  })

  expect_snapshot({
    ts_parse_toml("a.b.c=1\nb=2\nc=3") |> ts_tree_select(TRUE)
  })

  # in subtable (in table)
  expect_snapshot({
    txt <- "[a.b.c]\na=1\nb=2\n"
    print(ts_parse_toml(txt)[], n = Inf)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE) |> ts_tree_selection()
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE) |> ts_tree_selection()
  })

  # in subtable
  expect_snapshot({
    txt <- "a.b.c = 1"
    print(ts_parse_toml(txt)[], n = Inf)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE) |> ts_tree_selection()
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE) |> ts_tree_selection()
  })

  # in inline table
  expect_snapshot({
    txt <- "a = { b = { c = 1, d = 2 }, e = 3 }"
    print(ts_parse_toml(txt)[], n = Inf)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE) |> ts_tree_selection()
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE) |> ts_tree_selection()
  })

  # in inline table with dotted key
  expect_snapshot({
    txt <- "a = { b.c.d = 1, d = 2 }"
    print(ts_parse_toml(txt)[], n = Inf)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE, TRUE)
  })

  # in array
  expect_snapshot({
    txt <- "a = [ 1, 2, 3 ]"
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE)
    ts_parse_toml(txt) |> ts_tree_select("a", TRUE, TRUE)
  })
})

test_that("select1_key", {
  withr::local_options(cli.num_colors = 256)
  toml <- ts_parse_toml(text = toml_example_text())
  expect_snapshot({
    toml |> ts_tree_select("owner")
    toml |> ts_tree_select("owner", "name")
    toml |> ts_tree_select("nothere")
    toml |> ts_tree_select("owner", "nothere")
  })

  # in AOT elements
  toml <- ts_parse_toml(text = toml_aot_example())
  expect_snapshot({
    toml |> ts_tree_select("products")
    toml |> ts_tree_select("products", TRUE, "name")
    toml |> ts_tree_select("products", TRUE, "notthere")
  })

  # in subtables (tables)
  toml <- ts_parse_toml(text = "[a.b.c]\nx=1\ny=2\n")
  expect_snapshot({
    toml |> ts_tree_select("a")
    toml |> ts_tree_select("a", "b")
    toml |> ts_tree_select("a", "b", "c")
    toml |> ts_tree_select("a", "b", "notthere")
  })

  # in subtables (pairs)
  toml <- ts_parse_toml(text = "a.b.c=1\nd=2\n")
  expect_snapshot({
    toml |> ts_tree_select("a")
    toml |> ts_tree_select("a", "b")
    toml |> ts_tree_select("a", "b", "c")
    toml |> ts_tree_select("a", "b", "notthere")
  })

  # in inline tables
  toml <- ts_parse_toml(text = "a = { b = { c = 1, d = 2 }, e = 3 }")
  expect_snapshot({
    toml |> ts_tree_select("a")
    toml |> ts_tree_select("a", "b")
    toml |> ts_tree_select("a", "b", "c")
    toml |> ts_tree_select("a", "b", "notthere")
  })

  # in inline tables with dotted keys
  toml <- ts_parse_toml(text = "a = { b.c = 1, d = 2 }")
  expect_snapshot({
    toml |> ts_tree_select("a")
    toml |> ts_tree_select("a", "b")
    toml |> ts_tree_select("a", "b", "c")
    toml |> ts_tree_select("a", "b", "notthere")
  })

  # scalars, arrays, etc.
  toml <- ts_parse_toml(text = "a = [ 1, 2, 3 ]")
  expect_snapshot({
    toml |> ts_tree_select("a")
    toml |> ts_tree_select("a", "notthere")
    toml |> ts_tree_select("a", 1)
    toml |> ts_tree_select("a", 1, "notthere")
  })
})

test_that("select1_numeric", {
  withr::local_options(cli.num_colors = 256)
  # zero indices
  toml <- ts_parse_toml(text = toml_example_text())
  expect_snapshot(error = TRUE, {
    toml |> ts_tree_select(0)
  })

  # in AOT elements
  toml <- ts_parse_toml(text = toml_aot_example())
  expect_snapshot({
    toml |> ts_tree_select("products")
    toml |> ts_tree_select("products", TRUE, 1)
    toml |> ts_tree_select("products", TRUE, -1)
    toml |> ts_tree_select("products", TRUE, c(1, -1))
  })

  # selecting AOT elements by position
  expect_snapshot({
    toml |> ts_tree_select("products", 1)
    toml |> ts_tree_select("products", -1)
  })

  # in subtables (tables)
  toml <- ts_parse_toml(text = "[a.b.c]\nx=1\ny=2\n")
  expect_snapshot({
    toml |> ts_tree_select("a")
    toml |> ts_tree_select("a", 1)
    toml |> ts_tree_select("a", 1, 1)
    toml |> ts_tree_select("a", 1, 2)
  })

  # in subtables (pairs)
  toml <- ts_parse_toml(text = "a.b.c=1\nd=2\n")
  expect_snapshot({
    toml |> ts_tree_select("a")
    toml |> ts_tree_select("a", 1)
    toml |> ts_tree_select("a", 1, 1)
    toml |> ts_tree_select("a", 1, 2)
  })

  # elements in AOTS
  toml <- ts_parse_toml(text = toml_aot_example())
  expect_snapshot({
    toml |> ts_tree_select("products", 1)
    toml |> ts_tree_select("products", -1)
    toml |> ts_tree_select("products", 1, "name")
  })
})
