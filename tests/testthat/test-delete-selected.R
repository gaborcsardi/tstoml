test_that("delete_selected", {
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |> select("owner", "name") |> delete_selected()
  })
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |>
      select("database", "ports", 2) |>
      delete_selected() |>
      print(n = Inf)
  })
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |>
      select("servers", "alpha", "role") |>
      delete_selected() |>
      print(n = Inf)
  })
})

test_that("delete_selected table", {
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |> select("owner") |> delete_selected()
  })
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |>
      select("servers", "beta") |>
      delete_selected() |>
      print(n = Inf)
  })
})

test_that("delete_selected pair from inline table", {
  expect_snapshot({
    toml <- load_toml(text = "a = { x = 1, y = 2, z = 3 }\nb = 2\n")
    toml |> select("a", "y") |> delete_selected()
  })
})

test_that("delete_selected AOT element", {
  expect_snapshot({
    toml <- load_toml(text = toml_aot_example2())
    toml |> select("products", 2) |> delete_selected()
  })
  expect_snapshot({
    toml <- load_toml(text = toml_aot_example2())
    toml |> select("products", TRUE, "dimensions", 1) |> delete_selected()
  })
})

test_that("delete_selected whole AOT", {
  expect_snapshot({
    toml <- load_toml(text = toml_aot_example2())
    toml |> select("products") |> delete_selected()
  })
})

test_that("delete_selected subtable in pair", {
  expect_snapshot({
    toml <- load_toml(text = "a.b.c = 1\na.b.d = 2\na.e.f = 3\n")
    toml |> select("a", "b") |> delete_selected()
    toml |> select("a") |> delete_selected()
  })
})

test_that("delete_selected subtable in table", {
  expect_snapshot({
    toml <- load_toml(text = "x = 1\n[a.b]\nc = 1\nd = 2\n[a.c]\ng = 3\n")
    toml |> select("a", "b") |> delete_selected()
    toml |> select("a") |> delete_selected()
  })
})

test_that("delete_selected nothing to delete", {
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |> select("nothing") |> delete_selected()
  })
})

test_that("delete_selected whole document", {
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |> delete_selected()
  })
})

test_that("delete_selected deleting from special arrays", {
  # one element
  expect_snapshot({
    toml <- load_toml(text = "arr = [1]\n")
    toml |> select("arr", 1) |> delete_selected()
  })
  # empty
  expect_snapshot({
    toml <- load_toml(text = "arr = []\n")
    toml |> select("arr", TRUE) |> delete_selected()
  })
  # delete first element
  expect_snapshot({
    toml <- load_toml(text = "arr = [1, 2, 3]\n")
    toml |> select("arr", 1) |> delete_selected()
  })
  # delete last element
  expect_snapshot({
    toml <- load_toml(text = "arr = [1, 2, 3]\n")
    toml |> select("arr", 3) |> delete_selected()
  })
})

test_that("delete_selected, keep trailing ws after the last array element", {
  expect_snapshot({
    toml <- load_toml(text = "arr = [1, 2, 3  \n]\n")
    toml |> select("arr", 3) |> delete_selected()
  })
  expect_snapshot({
    toml <- load_toml(text = "arr = [1, [1,2,3], [1,2,3]  \n]\n")
    toml |> select("arr", 3) |> delete_selected()
  })
})
