test_that("eliminate newlines", {
  expect_snapshot({
    tree <- ts_parse_toml("foo=1\n\n\nbar=2")
    tree |> ts_tree_format()
  })
  expect_snapshot({
    tree <- ts_parse_toml("[tab]\nfoo=1\n\n\nbar=2")
    tree |> ts_tree_format()
  })
})

test_that("eliminate whitespace", {
  expect_snapshot({
    tree <- ts_parse_toml("foo     =1    \n   bar=    2")
    tree |> ts_tree_format()
  })
})

test_that("keep one empty line between tables", {
  expect_snapshot({
    tree <- ts_parse_toml("[t1]\nfoo=1\n\n[t2]\n\n\n\n\n[t3]\nbar=2")
    tree |> ts_tree_format()
  })
  expect_snapshot({
    tree <- ts_parse_toml("[[t1]]\nfoo=1\n\n[[t1]]\n\n\n\n\n[[t2]]\nbar=2")
    tree |> ts_tree_format()
  })
})

test_that("options", {
  expect_snapshot({
    tree <- ts_parse_toml("foo     =1    \n   bar=    2")
    tree |> ts_tree_format(options = list())
  })
})

test_that("multi-line value", {
  expect_snapshot({
    tree <- ts_parse_toml('foo = """\nThis is a\nmulti-line\nstring.\n"""')
    tree |> ts_tree_format()
  })
  expect_snapshot({
    tree <- ts_parse_toml('foo = [1,\n2,\n3,\n4\n]')
    tree |> ts_tree_format()
  })
})

test_that("indentation is kept if value is formattted", {
  expect_snapshot({
    tree <- ts_parse_toml("[table]\n   key = [1,2,3,\n4,5,6]")
    tree |> ts_tree_select("table", "key") |> ts_tree_format()
  })
})

test_that("inline table", {
  expect_snapshot({
    tree <- ts_parse_toml("foo = {a=1,b=2,c=3}")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
})

test_that("float", {
  expect_snapshot({
    tree <- ts_parse_toml("foo = 1.2300")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
})

test_that("boolean", {
  expect_snapshot({
    tree <- ts_parse_toml("foo = [true,false]")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
})

test_that("date-time", {
  expect_snapshot({
    tree <- ts_parse_toml("foo = 2024-01-01T12:34:56Z")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
  expect_snapshot({
    tree <- ts_parse_toml("foo = 1979-05-27T07:32:00")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
})

test_that("date", {
  expect_snapshot({
    tree <- ts_parse_toml("foo = 2024-06-15")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
})

test_that("time", {
  expect_snapshot({
    tree <- ts_parse_toml("foo = 12:34:56")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
})

test_that("comment", {
  expect_snapshot({
    tree <- ts_parse_toml("# This is a comment\nfoo=1 #c1\nbar=2 # c2")
    tree |> ts_tree_format()
  })
  expect_snapshot({
    tree <- ts_parse_toml("foo= { x = 1, y = 2 }    #comment")
    tree |> ts_tree_format()
  })
  expect_snapshot({
    tree <- ts_parse_toml("#c1\n[tab] # c2\n #c3\nfoo = 1 #c4")
    tree |> ts_tree_format()
  })
  expect_snapshot({
    tree <- ts_parse_toml("foo = [ #c1\n  1, #c2\n  2, #c3\n]")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
  # comma after comment
  expect_snapshot({
    tree <- ts_parse_toml("foo = [ #c1\n  1 #c2\n,  2 #c3\n]")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
})

test_that("format with tabs", {
  expect_snapshot({
    tree <- ts_parse_toml("foo = [ #c1\n  1, #c2\n  2, #c3\n]")
    tree |>
      ts_tree_select("foo") |>
      ts_tree_format(options = list(indent_style = "tab"))
  })
})

test_that("empty array", {
  expect_snapshot({
    tree <- ts_parse_toml("foo = [          ]")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
  expect_snapshot({
    tree <- ts_parse_toml("foo = [    # comment\n      ]")
    tree |> ts_tree_select("foo") |> ts_tree_format()
  })
})
