# update_selected

    Code
      toml <- load_toml(text = toml_example_text())
      update_selected(select(toml, "owner", "name"), "new_name")
    Output
      # toml (23 lines)
       1 | # This is a TOML document
       2 | 
       3 | title = "TOML Example"
       4 | 
       5 | [owner]
       6 | name = "new_name"
       7 | dob = 1979-05-27T07:32:00-08:00
       8 | 
       9 | [database]
      10 | enabled = true
      i 13 more lines
      i Use `print(n = ...)` to see more lines
    Code
      update_selected(select(toml, "database", "ports", 2), 9090L)
    Output
      # toml (23 lines)
       1 | # This is a TOML document
       2 | 
       3 | title = "TOML Example"
       4 | 
       5 | [owner]
       6 | name = "Tom Preston-Werner"
       7 | dob = 1979-05-27T07:32:00-08:00
       8 | 
       9 | [database]
      10 | enabled = true
      i 13 more lines
      i Use `print(n = ...)` to see more lines
    Code
      update_selected(select(toml, "servers", "alpha", "enabled"), FALSE)
    Output
      # toml (23 lines)
       1 | # This is a TOML document
       2 | 
       3 | title = "TOML Example"
       4 | 
       5 | [owner]
       6 | name = "Tom Preston-Werner"
       7 | dob = 1979-05-27T07:32:00-08:00
       8 | 
       9 | [database]
      10 | enabled = true
      i 13 more lines
      i Use `print(n = ...)` to see more lines

# update_selected errors

    Code
      toml <- load_toml(text = toml_example_text())
      update_selected(select(toml, "owner"), list(name = "new_name"))
    Condition
      Error in `update_selected()`:
      ! Can only update values (string, integer, float, boolean, offset_date_time, local_date_time, local_date, local_time, array, and inline_table).
    Code
      update_selected(select(toml, "servers"), "invalid")
    Condition
      Error in `update_selected()`:
      ! Can only update values (string, integer, float, boolean, offset_date_time, local_date_time, local_date, local_time, array, and inline_table).

