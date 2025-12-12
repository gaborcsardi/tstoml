# Replace selected TOML values with new content

Replace all selected elements with a new element. If `toml` has no
selection then the whole document is replaced. If `toml` has an empty
selection, then nothing happens.

## Usage

``` r
# S3 method for class 'ts_tree_toml'
ts_tree_update(tree, new, options = NULL, ...)
```

## Arguments

- tree:

  A tstoml object

- new:

  A R object to be converted to TOML using
  [`ts_serialize_toml_value()`](https://gaborcsardi.github.io/tstoml/reference/ts_serialize_toml_value.md)
  and used as the new value.

- options:

  A named list of `tstoml` options, see
  [`tstoml_options()`](https://gaborcsardi.github.io/tstoml/reference/tstoml_options.md).
  Passed to
  [`ts_serialize_toml_value()`](https://gaborcsardi.github.io/tstoml/reference/ts_serialize_toml_value.md).

- ...:

  Reserved for future use.
