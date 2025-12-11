# as_count

    Code
      as_count(v1)
    Condition
      Error:
      ! Invalid argument: `v1` must be an integer scalar, not a vector.
    Code
      as_count(v2)
    Condition
      Error:
      ! Invalid argument: `v2` must not be `NA`.
    Code
      as_count(v3)
    Condition
      Error:
      ! Invalid argument: `v3` must be non-negative.
    Code
      as_count(v4)
    Condition
      Error:
      ! Invalid argument: `v4` must be a non-negative integer scalar, but it is a data frame.

# as_choice

    Code
      as_choice(v1, letters[1:5])
    Condition
      Error:
      ! Invalid argument: `v1` must be one of 'a', 'b', 'c', 'd', 'e', but it is 'z'.

---

    Code
      as_choice(v2, letters[1:5])
    Condition
      Error:
      ! Invalid argument: `v2` must be a string scalar, one of 'a', 'b', 'c', 'd', 'e', but it is an integer vector.

# as_toml_float

    Code
      as_toml_float(v1)
    Condition
      Error:
      ! Invalid argument: `v1` contains an atomic numeric vector of length 2. TOML only supports numeric scalars and lists.
    Code
      as_toml_float(v2)
    Condition
      Error:
      ! Invalid argument: `v2` contains an atomic numeric vector of length 1. TOML only supports numeric scalars and lists.

# as_toml_boolean

    Code
      as_toml_boolean(v1)
    Condition
      Error:
      ! Invalid argument: `v1` contains an atomic logical vector of length 2. TOML only supports logical scalars and lists.
    Code
      as_toml_boolean(v2)
    Condition
      Error:
      ! Invalid argument: `v2` contains a logical `NA`. TOML does not support logical `NA` values.
    Code
      as_toml_boolean(v3)
    Condition
      Error:
      ! Invalid argument: `v3` contains an atomic logical vector of length 1. TOML only supports logical scalars and lists.

# as_toml_integer

    Code
      as_toml_integer(v1)
    Condition
      Error:
      ! Invalid argument: `v1` contains an atomic integer vector of length 2. TOML only supports integer scalars and lists.
    Code
      as_toml_integer(v2)
    Condition
      Error:
      ! Invalid argument: `v2` contains an integer `NA`. TOML does not support integer `NA` values.
    Code
      as_toml_integer(v3)
    Condition
      Error:
      ! Invalid argument: `v3` contains an atomic integer vector of length 1. TOML only supports integer scalars and lists.

# default options

    Code
      as_tstoml_options(NULL)
    Output
      $indent_width
      [1] 4
      
      $indent_style
      [1] "space"
      

# as_tstoml_options

    Code
      as_tstoml_options(list(indent_width = 2, indent_style = "space"))
    Output
      $indent_width
      [1] 2
      
      $indent_style
      [1] "space"
      

---

    Code
      as_tstoml_options(v1)
    Condition
      Error:
      ! Invalid argument: `v1` must be a named list of tsjsonc options (see `?tsjsonc_options`), but it is a function.
    Code
      as_tstoml_options(v2)
    Condition
      Error:
      ! Invalid argument: `v2` must be a named list of tsjsonc options (see `?tsjsonc_options`), but not all of its entries are named.
    Code
      as_tstoml_options(v3)
    Condition
      Error:
      ! Invalid argument: `v3` contains unknown tsjsonc option: `foo`. Known tsjsonc options are: `indent_width` and `indent_style`.
    Code
      as_tstoml_options(v4)
    Condition
      Error:
      ! Invalid argument: `v4[["indent_width"]]` must be non-negative.
    Code
      as_tstoml_options(v5)
    Condition
      Error:
      ! Invalid argument: `v5[["indent_style"]]` must be one of 'space', 'tab', but it is 'fancy'.

