# Serialize an R object to TOML

Create TOML from an R object. Note that this function is not a generic
serializer that can represent any R object in TOML. Also, you cannot
expect that
[`ts_unserialize_toml()`](https://gaborcsardi.github.io/tstoml/reference/ts_unserialize_toml.md)
will do the exact inverse of `ts_serialize_toml()`.

## Usage

``` r
ts_serialize_toml(obj, file = NULL, collapse = FALSE, options = NULL)

ts_toml_table(...)

ts_toml_inline_table(...)

ts_toml_array(...)

ts_toml_array_of_tables(...)
```

## Arguments

- obj:

  R object to serialize.

- file:

  If not `NULL` then the result if written to this file.

- collapse:

  If `file` is `NULL` then whether to return a character scalar or a
  character vector.

- options:

  A named list of `tstoml` options, see
  [`tstoml_options()`](https://gaborcsardi.github.io/tstoml/reference/tstoml_options.md).

- ...:

  Elements of the TOML table, array, inline table or array of tables.

## Value

If `file` is `NULL` then a character scalar (`collapse` = TRUE) or
vector (`collapse` = FALSE). If `file` is not `NULL` then nothing.

## Details

See the examples below on how to create all possible TOML elements with
`ts_serialize_toml()`.

Use `ts_toml_table()` to make a list to be serialized as a TOML table.
All named lists are serialized as TOML tables by default, so this is
only readability.

Use `ts_toml_inline_table()` to make a list to be serialized as an
inline TOML table. By default named lists are serialized as regular TOML
tables, if possible.

Use `ts_toml_array()` to make a list to be serialized as a TOML array.
By default un-named lists are serialized as arrays, unless they are
lists of named lists (which are serialized as arrays of tables). Use
this funtion to mark any list to be serialized as an array.

Use `ts_toml_array_of_tables()` to make a list to be serialized as a
TOML array of tables. It must a list of named lists. By default lists of
named lists are serialized as arrays of tables, so this is only for
readability.

## See also

[`ts_unserialize_toml()`](https://gaborcsardi.github.io/tstoml/reference/ts_unserialize_toml.md)
for the opposite.
