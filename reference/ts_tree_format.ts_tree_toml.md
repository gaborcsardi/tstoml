# Format the selected TOML elements

Format the selected TOML elements

## Usage

``` r
# S3 method for class 'ts_tree_toml'
ts_tree_format(tree, options = NULL, ...)
```

## Arguments

- tree:

  tstoml object.

- options:

  Named list of parsing options, see [tstoml
  options](https://gaborcsardi.github.io/tstoml/reference/tstoml_options.md).

- ...:

  Reserved for future use.

## Value

The updated tstoml object.

## Details

If `tree` does not have a selection, then all of it is formatted. If
`tree` has an empty selection, then nothing happens.
