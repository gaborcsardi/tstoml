test_that("ts_tree_deleted value", {
  # key from table
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml[[list("owner", "name")]] <- ts_tree_deleted()
    toml
  })

  # key from root
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml[[list("title")]] <- ts_tree_deleted()
    toml
  })

  # array element
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml[[list("database", "ports", 2)]] <- ts_tree_deleted()
    toml |> print(n = Inf)
  })

  # key from subtable
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml[[list("servers", "alpha", "role")]] <- ts_tree_deleted()
    toml |> print(n = Inf)
  })
})

test_that("ts_tree_deleted table", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml[["owner"]] <- ts_tree_deleted()
    toml
  })

  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml[[list("servers", "beta")]] <- ts_tree_deleted()
    toml |> print(n = Inf)
  })
})

test_that("ts_tree_deleted pair from inline table", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "a = { x = 1, y = 2, z = 3 }\nb = 2\n")
    toml[[list("a", "y")]] <- ts_tree_deleted()
    toml
  })
})

test_that("ts_tree_deleted AOT element", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_aot_example2())
    toml[[list("products", 2)]] <- ts_tree_deleted()
    toml |> print(n = Inf)
  })
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_aot_example2())
    toml[[list("products", TRUE, "dimensions", 1)]] <- ts_tree_deleted()
    toml |> print(n = Inf)
  })
})

test_that("ts_tree_deleted whole AOT", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_aot_example2())
    toml[[list("products")]] <- ts_tree_deleted()
    toml |> print(n = Inf)
  })
})

test_that("ts_tree_deleted subtable in pair", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "a.b.c = 1\na.b.d = 2\na.e.f = 3\n")
    toml[[list("a", "b")]] <- ts_tree_deleted()
    toml
    toml <- ts_parse_toml(text = "a.b.c = 1\na.b.d = 2\na.e.f = 3\n")
    toml[[list("a")]] <- ts_tree_deleted()
    toml
  })
})

test_that("ts_tree_deleted subtable in table", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "x = 1\n[a.b]\nc = 1\nd = 2\n[a.c]\ng = 3\n")
    toml[[list("a", "b")]] <- ts_tree_deleted()
    toml
    toml <- ts_parse_toml(text = "x = 1\n[a.b]\nc = 1\nd = 2\n[a.c]\ng = 3\n")
    toml[[list("a")]] <- ts_tree_deleted()
    toml
  })
})

test_that("ts_tree_deleted nothing to delete", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml[[list("nothing")]] <- ts_tree_deleted()
    toml |> print(n = Inf)
  })
})

test_that("ts_tree_deleted whole document", {
  expect_snapshot({
    toml <- ts_parse_toml(text = toml_example_text())
    toml[[]] <- ts_tree_deleted()
    toml
  })
})

test_that("ts_tree_deleted deleting from special arrays", {
  # one element
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1]\n")
    toml[[list("arr", 1)]] <- ts_tree_deleted()
    toml
  })
  # empty
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = []\n")
    toml[[list("arr", TRUE)]] <- ts_tree_deleted()
    toml
  })
  # delete first element
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1, 2, 3]\n")
    toml[[list("arr", 1)]] <- ts_tree_deleted()
    toml
  })
  # delete last element
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1, 2, 3]\n")
    toml[[list("arr", 3)]] <- ts_tree_deleted()
    toml
  })
})

test_that("ts_tree_deleted, keep trailing ws after the last array element", {
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1, 2, 3  \n]\n")
    toml[[list("arr", 3)]] <- ts_tree_deleted()
    toml
  })
  expect_snapshot({
    toml <- ts_parse_toml(text = "arr = [1, [1,2,3], [1,2,3]  \n]\n")
    toml[[list("arr", 3)]] <- ts_tree_deleted()
    toml
  })
})
