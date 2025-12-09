# key errors

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `token_table()`:
      ! could not find function "token_table"

---

    Code
      unserialize_toml(text = txt2)
    Condition
      Error in `token_table()`:
      ! could not find function "token_table"

# key errors 2

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `token_table()`:
      ! could not find function "token_table"

# inline tables are self-contained

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `token_table()`:
      ! could not find function "token_table"

# inline tables are consistent

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `token_table()`:
      ! could not find function "token_table"

---

    Code
      unserialize_toml(text = txt2)
    Condition
      Error in `token_table()`:
      ! could not find function "token_table"

# inline tables cannot add keys or sub-tables to an existing table

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `token_table()`:
      ! could not find function "token_table"

