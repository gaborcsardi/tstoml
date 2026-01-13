# Unserialize TOML to R objects

Unserialize TOML to R objects

## Usage

``` r
ts_unserialize_toml(file = NULL, text = NULL, ranges = NULL, options = NULL)
```

## Arguments

- file:

  Path of a file to parse. Use either `file` or `text`, but not both.

- text:

  String to parse. Use either `file` or `text`, but not both.

- ranges:

  Can be used to parse part(s) of the input. It must be a data frame
  with integer columns `start_row`, `start_col`, `end_row`, `end_col`,
  `start_byte`, `end_byte`, in this order.

- options:

  Named list of parsing options, see [tstoml
  options](https://gaborcsardi.github.io/tstoml/reference/tstoml_options.md).
