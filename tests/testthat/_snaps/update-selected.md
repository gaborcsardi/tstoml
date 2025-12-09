# ts_tree_update

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      ts_tree_update(ts_tree_select(toml, "owner", "name"), "new_name")
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
      ts_tree_update(ts_tree_select(toml, "database", "ports", 2), 9090L)
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
      ts_tree_update(ts_tree_select(toml, "servers", "alpha", "enabled"), FALSE)
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

# ts_tree_update multiple values

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      print(ts_tree_update(ts_tree_select(toml, "servers", TRUE, "ip"), "localhost"),
      n = Inf)
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
      11 | ports = [ 8000, 8001, 8002 ]
      12 | data = [ ["delta", "phi"], [3.14] ]
      13 | temp_targets = { cpu = 79.5, case = 72.0 }
      14 | 
      15 | [servers]
      16 | 
      17 | [servers.alpha]
      18 | ip = "localhost"
      19 | role = "frontend"
      20 | 
      21 | [servers.beta]
      22 | ip = "localhost"
      23 | role = "backend"

# ts_tree_update errors

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      ts_tree_update(ts_tree_select(toml, "owner"), list(name = "new_name"))
    Condition
      Error in `ts_tree_update.ts_tree_toml()`:
      ! Can only update values (string, integer, float, boolean, offset_date_time, local_date_time, local_date, local_time, array, and inline_table).
    Code
      ts_tree_update(ts_tree_select(toml, "servers"), "invalid")
    Condition
      Error in `ts_tree_update.ts_tree_toml()`:
      ! Can only update values (string, integer, float, boolean, offset_date_time, local_date_time, local_date, local_time, array, and inline_table).

# whitespace is kept

    Code
      toml <- ts_parse_toml(text = "a = 1  \n\nb = 2\n")
      toml
    Output
      # toml (3 lines)
      1 | a = 1  
      2 | 
      3 | b = 2
    Code
      ts_tree_update(ts_tree_select(toml, "a"), 42L)
    Output
      # toml (3 lines)
      1 | a = 42  
      2 | 
      3 | b = 2

# comments are kept

    Code
      toml <- ts_parse_toml(text = "# Comment line\na = 1 # inline comment\n")
      toml
    Output
      # toml (2 lines)
      1 | # Comment line
      2 | a = 1 # inline comment
    Code
      ts_tree_update(ts_tree_select(toml, "a"), 42L)
    Output
      # toml (2 lines)
      1 | # Comment line
      2 | a = 42 # inline comment

