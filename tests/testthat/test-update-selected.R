test_that("update_selected", {
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |> select("owner", "name") |> update_selected("new_name")
    toml |> select("database", "ports", 2) |> update_selected(9090L)
    toml |> select("servers", "alpha", "enabled") |> update_selected(FALSE)
  })
})

test_that("update_selected multiple values", {
  expect_snapshot({
    toml <- load_toml(text = toml_example_text())
    toml |>
      select("servers", TRUE, "ip") |>
      update_selected("localhost") |>
      print(n = Inf)
  })
})

test_that("update_selected errors", {
  expect_snapshot(error = TRUE, {
    toml <- load_toml(text = toml_example_text())
    toml |> select("owner") |> update_selected(list(name = "new_name"))
    toml |> select("servers") |> update_selected("invalid")
  })
})

test_that("whitespace is kept", {
  expect_snapshot({
    toml <- load_toml(text = "a = 1  \n\nb = 2\n")
    toml
    toml |> select("a") |> update_selected(42L)
  })
})

test_that("comments are kept", {
  expect_snapshot({
    toml <- load_toml(text = "# Comment line\na = 1 # inline comment\n")
    toml
    toml |> select("a") |> update_selected(42L)
  })
})
