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

