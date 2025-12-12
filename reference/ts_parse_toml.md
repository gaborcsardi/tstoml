# Parse a TOML file or string into a ts_tree_toml object

Parse a TOML file or string into a ts_tree_toml object

## Usage

``` r
ts_parse_toml(text, ranges = NULL, fail_on_parse_error = TRUE, options = NULL)

ts_read_toml(file, ranges = NULL, fail_on_parse_error = TRUE, options = NULL)
```

## Arguments

- text:

  String. Use either `file` or `text`, but not both.

- ranges:

  Can be used to parse part(s) of the input. It must be a data frame
  with integer columns `start_row`, `start_col`, `end_row`, `end_col`,
  `start_byte`, `end_byte`, in this order.

- fail_on_parse_error:

  Logical, whether to error if there are parse errors in the document.
  Default is `TRUE`.

- options:

  Named list of parsing options, see [tstoml
  options](https://gaborcsardi.github.io/tstoml/reference/tstoml_options.md).

- file:

  Path of a file. Use either `file` or `text`, but not both.

## Value

A `ts_tree_toml` object.
