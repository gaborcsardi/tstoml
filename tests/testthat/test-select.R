test_that("minimize_selection", {
  toml <- token_table(text = toml_example_text())
  owner <- toml$parent[toml$type == "bare_key" & toml$code == "owner"]
  dob <- toml$id[toml$type == "bare_key" & toml$code == "dob"]
  expect_equal(
    minimize_selection(toml, c(owner, dob)),
    owner
  )
})
