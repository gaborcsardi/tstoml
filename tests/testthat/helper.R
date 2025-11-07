toml_aot_example <- function() {
  '# A TOML document with all types of arrays of tables

  [[products]]
  name = "Hammer"
  sku = 738594937

  [[products]]
  name = "Nail"
  sku = 284758393
  color = "gray"
  '
}

toml_aot_example2 <- function() {
  '# A TOML document with all types of arrays of tables

  [[products]]
  name = "Hammer"
  sku = 738594937

  [[products.dimensions]]
  length = 10.0
  width = 5.0
  height = 2.5

  [[products]]
  name = "Nail"
  sku = 284758393
  color = "gray"

  [[products.dimensions]]
  length = 0.5
  width = 0.25
  height = 0.125
  '
}
