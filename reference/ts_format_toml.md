# Format a TOML file

Format a TOML file

## Usage

``` r
ts_format_toml(file = NULL, text = NULL, options = NULL)
```

## Arguments

- file:

  Path to a TOML file. Use one of `file` or `text`.

- text:

  TOML content as a raw vector or a character vector. Use one of `file`
  or `text`.

- options:

  Named list of parsing and formatting options, see [tstoml
  options](https://gaborcsardi.github.io/tstoml/reference/tstoml_options.md).
