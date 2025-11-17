test_that("minimize_selection", {
  toml <- token_table(text = toml_example_text())
  owner <- toml$parent[toml$type == "bare_key" & toml$code == "owner"]
  dob <- toml$id[toml$type == "bare_key" & toml$code == "dob"]
  expect_equal(
    minimize_selection(toml, c(owner, dob)),
    owner
  )
})

test_that("get_selection", {
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    get_selection(toml, default = FALSE)
    get_selection(toml)
    get_selection(toml |> select("owner"))
  })
})

test_that("get_selected_nodes", {
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    get_selected_nodes(toml, default = FALSE)
    get_selected_nodes(toml)
    get_selected_nodes(toml |> select("owner"))
    get_selected_nodes(toml |> select("owner", 1))
  })
})

test_that("select 1", {
  # some basics only, more specific tests are below
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    toml |> select("owner")
    toml |> select("servers", "alpha", "ip")
    toml |> select("servers", "beta", 2)
  })
})

test_that("select 2", {
  toml <- load_toml(text = toml_example_text())
  expect_null(
    toml |> select(NULL) |> get_selection(default = FALSE)
  )
})

test_that("[[.tstoml 1", {
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    toml[["owner"]]
    toml[["servers", "alpha", "ip"]]
    toml[["servers", "beta", 2]]
  })
})

test_that("[[.tstoml 2", {
  toml <- load_toml(text = "a=1\nb=2\n")
  expect_snapshot({
    toml[[]]
  })
})

test_that("sel_ids", {
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    sel_ids(11)
    toml |> select(sel_ids(11))
  })
})

test_that("select_query", {
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    toml |> select_query("(float) @float")
  })

  # select all ip = <string> values
  expect_snapshot({
    toml |>
      select_query(
        "((pair (bare_key) @key (string) @str) (#eq? @key \"ip\"))",
        "str"
      )
  })

  # error
  expect_snapshot(error = TRUE, {
    toml |> select_query("(float) @float", "bad")
  })

  # nothing selected
  expect_snapshot({
    toml |>
      select_query("(table_array_element) @aot")
  })
})

test_that("select_refine", {
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    toml |> select("owner") |> select_refine("name")
  })
})

test_that("select1", {
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    toml |> select(sel_ids(11))
    toml |> select("owner", TRUE)
  })
  expect_snapshot(error = TRUE, {
    toml |> select("owner", FALSE)
  })
})

test_that("select1_true", {
  withr::local_options(cli.num_colors = 256)
  # inside an AOT element
  toml <- load_toml(text = toml_aot_example())
  expect_snapshot({
    toml |> select("products")
    toml |> select("products", TRUE)
    toml |> select("products", TRUE, TRUE)
  })

  # in document
  expect_snapshot({
    load_toml(text = "a=1\nb=2\n[tab]\nc=3\n") |> select(TRUE)
  })

  # dotted key in document
  expect_snapshot({
    load_toml(text = "[a.b.c]\nx=1\n") |> select(TRUE)
  })

  expect_snapshot({
    load_toml(text = "a.b.c=1\nb=2\nc=3") |> select(TRUE)
  })

  # in subtable (in table)
  expect_snapshot({
    txt <- "[a.b.c]\na=1\nb=2\n"
    print(load_toml(text = txt)[], n = Inf)
    load_toml(text = txt) |> select("a", TRUE)
    load_toml(text = txt) |> select("a", TRUE) |> get_selection()
    load_toml(text = txt) |> select("a", TRUE, TRUE)
    load_toml(text = txt) |> select("a", TRUE, TRUE) |> get_selection()
  })

  # in subtable
  expect_snapshot({
    txt <- "a.b.c = 1"
    print(load_toml(text = txt)[], n = Inf)
    load_toml(text = txt) |> select("a", TRUE)
    load_toml(text = txt) |> select("a", TRUE) |> get_selection()
    load_toml(text = txt) |> select("a", TRUE, TRUE)
    load_toml(text = txt) |> select("a", TRUE, TRUE) |> get_selection()
  })

  # in inline table
  expect_snapshot({
    txt <- "a = { b = { c = 1, d = 2 }, e = 3 }"
    print(load_toml(text = txt)[], n = Inf)
    load_toml(text = txt) |> select("a", TRUE)
    load_toml(text = txt) |> select("a", TRUE) |> get_selection()
    load_toml(text = txt) |> select("a", TRUE, TRUE)
    load_toml(text = txt) |> select("a", TRUE, TRUE) |> get_selection()
  })

  # in inline table with dotted key
  expect_snapshot({
    txt <- "a = { b.c.d = 1, d = 2 }"
    print(load_toml(text = txt)[], n = Inf)
    load_toml(text = txt) |> select("a", TRUE)
    load_toml(text = txt) |> select("a", TRUE, TRUE)
    load_toml(text = txt) |> select("a", TRUE, TRUE, TRUE)
  })

  # in array
  expect_snapshot({
    txt <- "a = [ 1, 2, 3 ]"
    load_toml(text = txt) |> select("a", TRUE)
    load_toml(text = txt) |> select("a", TRUE, TRUE)
  })
})

test_that("select1_key", {
  withr::local_options(cli.num_colors = 256)
  toml <- load_toml(text = toml_example_text())
  expect_snapshot({
    toml |> select("owner")
    toml |> select("owner", "name")
    toml |> select("nothere")
    toml |> select("owner", "nothere")
  })

  # in AOT elements
  toml <- load_toml(text = toml_aot_example())
  expect_snapshot({
    toml |> select("products")
    toml |> select("products", TRUE, "name")
    toml |> select("products", TRUE, "notthere")
  })

  # in subtables (tables)
  toml <- load_toml(text = "[a.b.c]\nx=1\ny=2\n")
  expect_snapshot({
    toml |> select("a")
    toml |> select("a", "b")
    toml |> select("a", "b", "c")
    toml |> select("a", "b", "notthere")
  })

  # in subtables (pairs)
  toml <- load_toml(text = "a.b.c=1\nd=2\n")
  expect_snapshot({
    toml |> select("a")
    toml |> select("a", "b")
    toml |> select("a", "b", "c")
    toml |> select("a", "b", "notthere")
  })

  # in inline tables
  toml <- load_toml(text = "a = { b = { c = 1, d = 2 }, e = 3 }")
  expect_snapshot({
    toml |> select("a")
    toml |> select("a", "b")
    toml |> select("a", "b", "c")
    toml |> select("a", "b", "notthere")
  })

  # in inline tables with dotted keys
  toml <- load_toml(text = "a = { b.c = 1, d = 2 }")
  expect_snapshot({
    toml |> select("a")
    toml |> select("a", "b")
    toml |> select("a", "b", "c")
    toml |> select("a", "b", "notthere")
  })

  # scalars, arrays, etc.
  toml <- load_toml(text = "a = [ 1, 2, 3 ]")
  expect_snapshot({
    toml |> select("a")
    toml |> select("a", "notthere")
    toml |> select("a", 1)
    toml |> select("a", 1, "notthere")
  })
})

test_that("select1_numeric", {
  withr::local_options(cli.num_colors = 256)
  # zero indices
  toml <- load_toml(text = toml_example_text())
  expect_snapshot(error = TRUE, {
    toml |> select(0)
  })

  # in AOT elements
  toml <- load_toml(text = toml_aot_example())
  expect_snapshot({
    toml |> select("products")
    toml |> select("products", TRUE, 1)
    toml |> select("products", TRUE, -1)
    toml |> select("products", TRUE, c(1, -1))
  })

  # selecting AOT elements by position
  expect_snapshot({
    toml |> select("products", 1)
    toml |> select("products", -1)
  })

  # in subtables (tables)
  toml <- load_toml(text = "[a.b.c]\nx=1\ny=2\n")
  expect_snapshot({
    toml |> select("a")
    toml |> select("a", 1)
    toml |> select("a", 1, 1)
    toml |> select("a", 1, 2)
  })

  # in subtables (pairs)
  toml <- load_toml(text = "a.b.c=1\nd=2\n")
  expect_snapshot({
    toml |> select("a")
    toml |> select("a", 1)
    toml |> select("a", 1, 1)
    toml |> select("a", 1, 2)
  })

  # elements in AOTS
  toml <- load_toml(text = toml_aot_example())
  expect_snapshot({
    toml |> select("products", 1)
    toml |> select("products", -1)
    toml |> select("products", 1, "name")
  })
})
