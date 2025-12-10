test_that("ts_tree_delete", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |> ts_tree_select("owner", "name") |> ts_tree_delete()
  })
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |>
      ts_tree_select("database", "ports", 2) |>
      ts_tree_delete() |>
      print(n = Inf)
  })
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |>
      ts_tree_select("servers", "alpha", "role") |>
      ts_tree_delete() |>
      print(n = Inf)
  })
})

test_that("ts_tree_delete table", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |> ts_tree_select("owner") |> ts_tree_delete()
  })
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |>
      ts_tree_select("servers", "beta") |>
      ts_tree_delete() |>
      print(n = Inf)
  })
})

test_that("ts_tree_delete pair from inline table", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "a = { x = 1, y = 2, z = 3 }\nb = 2\n")
    toml |> ts_tree_select("a", "y") |> ts_tree_delete()
  })
})

test_that("ts_tree_delete AOT element", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_aot_example2())
    toml |> ts_tree_select("products", 2) |> ts_tree_delete()
  })
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_aot_example2())
    toml |>
      ts_tree_select("products", TRUE, "dimensions", 1) |>
      ts_tree_delete()
  })
})

test_that("ts_tree_delete whole AOT", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_aot_example2())
    toml |> ts_tree_select("products") |> ts_tree_delete()
  })
})

test_that("ts_tree_delete subtable in pair", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "a.b.c = 1\na.b.d = 2\na.e.f = 3\n")
    toml |> ts_tree_select("a", "b") |> ts_tree_delete()
    toml |> ts_tree_select("a") |> ts_tree_delete()
  })
})

test_that("ts_tree_delete subtable in table", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "x = 1\n[a.b]\nc = 1\nd = 2\n[a.c]\ng = 3\n")
    toml |> ts_tree_select("a", "b") |> ts_tree_delete()
    toml |> ts_tree_select("a") |> ts_tree_delete()
  })
})

test_that("ts_tree_delete nothing to delete", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |> ts_tree_select("nothing") |> ts_tree_delete()
  })
})

test_that("ts_tree_delete whole document", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |> ts_tree_delete()
  })
})

test_that("ts_tree_delete deleting from special arrays", {
  # one element
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1]\n")
    toml |> ts_tree_select("arr", 1) |> ts_tree_delete()
  })
  # empty
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = []\n")
    toml |> ts_tree_select("arr", TRUE) |> ts_tree_delete()
  })
  # delete first element
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1, 2, 3]\n")
    toml |> ts_tree_select("arr", 1) |> ts_tree_delete()
  })
  # delete last element
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1, 2, 3]\n")
    toml |> ts_tree_select("arr", 3) |> ts_tree_delete()
  })
})

test_that("ts_tree_delete, keep trailing ws after the last array element", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1, 2, 3  \n]\n")
    toml |> ts_tree_select("arr", 3) |> ts_tree_delete()
  })
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1, [1,2,3], [1,2,3]  \n]\n")
    toml |> ts_tree_select("arr", 3) |> ts_tree_delete()
  })
})
