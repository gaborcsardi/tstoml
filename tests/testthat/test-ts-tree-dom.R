test_that("ts_tree_dom", {
  expect_snapshot({
    toml <- ts_parse_toml(toml_example_text())
    ts_tree_dom(toml)
  })
  expect_snapshot({
    toml <- ts_parse_toml(toml_aot_example())
    ts_tree_dom(toml)
  })
  expect_snapshot({
    toml <- ts_parse_toml(toml_aot_example2())
    ts_tree_dom(toml)
  })
})
