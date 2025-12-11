test_that("ts_tree_update", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |> ts_tree_select("owner", "name") |> ts_tree_update("new_name")
    toml |> ts_tree_select("database", "ports", 2) |> ts_tree_update(9090L)
    toml |>
      ts_tree_select("servers", "alpha", "enabled") |>
      ts_tree_update(FALSE)
  })
})

test_that("ts_tree_update multiple values", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml |>
      ts_tree_select("servers", TRUE, "ip") |>
      ts_tree_update("localhost") |>
      print(n = Inf)
  })
})

test_that("update in array of tables", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_aot_example())
    toml |>
      ts_tree_select("products", 2, "name") |>
      ts_tree_update("New Hammer") |>
      print(n = Inf)
  })
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_aot_example())
    toml |>
      ts_tree_select("products", TRUE, "sku") |>
      ts_tree_update(1044L) |>
      print(n = Inf)
  })
})

test_that("ts_tree_update errors", {
  expect_snapshot(error = TRUE, {
    toml <- ts_parse_toml(text = toml_example_text())
    toml |> ts_tree_select("owner") |> ts_tree_update(list(name = "new_name"))
    toml |> ts_tree_select("servers") |> ts_tree_update("invalid")
  })
})

test_that("whitespace is kept", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "a = 1  \n\nb = 2\n")
    toml
    toml |> ts_tree_select("a") |> ts_tree_update(42L)
  })
})

test_that("comments are kept", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "# Comment line\na = 1 # inline comment\n")
    toml
    toml |> ts_tree_select("a") |> ts_tree_update(42L)
  })
})

test_that("update in inline table", {
  expect_snapshot({
    toml <- ts_parse_toml("point = { x = 1, y = 2 }")
    toml |> ts_tree_select("point", "x") |> ts_tree_update(13L)
  })
  expect_snapshot({
    toml <- ts_parse_toml("p1 = { x = 1, y = 2 }\np2 = { x = 3, y = 4 }")
    toml |> ts_tree_select(TRUE, "x") |> ts_tree_update(13L)
  })
})
