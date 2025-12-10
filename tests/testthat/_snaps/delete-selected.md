# ts_tree_delete

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      ts_tree_delete(ts_tree_select(toml, "owner", "name"))
    Output
      # toml (22 lines)
       1 | # This is a TOML document
       2 | 
       3 | title = "TOML Example"
       4 | 
       5 | [owner]
       6 | dob = 1979-05-27T07:32:00-08:00
       7 | 
       8 | [database]
       9 | enabled = true
      10 | ports = [ 8000, 8001, 8002 ]
      i 12 more lines
      i Use `print(n = ...)` to see more lines

---

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      print(ts_tree_delete(ts_tree_select(toml, "database", "ports", 2)), n = Inf)
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
      11 | ports = [ 8000, 8002 ]
      12 | data = [ ["delta", "phi"], [3.14] ]
      13 | temp_targets = { cpu = 79.5, case = 72.0 }
      14 | 
      15 | [servers]
      16 | 
      17 | [servers.alpha]
      18 | ip = "10.0.0.1"
      19 | role = "frontend"
      20 | 
      21 | [servers.beta]
      22 | ip = "10.0.0.2"
      23 | role = "backend"

---

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      print(ts_tree_delete(ts_tree_select(toml, "servers", "alpha", "role")), n = Inf)
    Output
      # toml (21 lines)
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
      18 | ip = "10.0.0.1"
      19 | [servers.beta]
      20 | ip = "10.0.0.2"
      21 | role = "backend"

# ts_tree_delete table

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      ts_tree_delete(ts_tree_select(toml, "owner"))
    Output
      # toml (19 lines)
       1 | # This is a TOML document
       2 | 
       3 | title = "TOML Example"
       4 | 
       5 | [database]
       6 | enabled = true
       7 | ports = [ 8000, 8001, 8002 ]
       8 | data = [ ["delta", "phi"], [3.14] ]
       9 | temp_targets = { cpu = 79.5, case = 72.0 }
      10 | 
      i 9 more lines
      i Use `print(n = ...)` to see more lines

---

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      print(ts_tree_delete(ts_tree_select(toml, "servers", "beta")), n = Inf)
    Output
      # toml (20 lines)
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
      18 | ip = "10.0.0.1"
      19 | role = "frontend"
      20 | 

# ts_tree_delete pair from inline table

    Code
      toml <- ts_parse_toml(text = "a = { x = 1, y = 2, z = 3 }\nb = 2\n")
      ts_tree_delete(ts_tree_select(toml, "a", "y"))
    Output
      # toml (2 lines)
      1 | a = { x = 1, z = 3 }
      2 | b = 2

# ts_tree_delete AOT element

    Code
      toml <- ts_parse_toml(text = toml_aot_example2())
      ts_tree_delete(ts_tree_select(toml, "products", 2))
    Output
      # toml (12 lines)
       1 | # A TOML document with all types of arrays of tables
       2 | 
       3 |   [[products]]
       4 |   name = "Hammer"
       5 |   sku = 738594937
       6 | 
       7 |   [[products.dimensions]]
       8 |   length = 10.0
       9 |   width = 5.0
      10 |   height = 2.5
      i 2 more lines
      i Use `print(n = ...)` to see more lines

---

    Code
      toml <- ts_parse_toml(text = toml_aot_example2())
      ts_tree_delete(ts_tree_select(toml, "products", TRUE, "dimensions", 1))
    Output
      # toml (12 lines)
       1 | # A TOML document with all types of arrays of tables
       2 | 
       3 |   [[products]]
       4 |   name = "Hammer"
       5 |   sku = 738594937
       6 | 
       7 |   [[products]]
       8 |   name = "Nail"
       9 |   sku = 284758393
      10 |   color = "gray"
      i 2 more lines
      i Use `print(n = ...)` to see more lines

# ts_tree_delete whole AOT

    Code
      toml <- ts_parse_toml(text = toml_aot_example2())
      ts_tree_delete(ts_tree_select(toml, "products"))
    Output
      # toml (3 lines)
      1 | # A TOML document with all types of arrays of tables
      2 | 
      3 |   

# ts_tree_delete subtable in pair

    Code
      toml <- ts_parse_toml(text = "a.b.c = 1\na.b.d = 2\na.e.f = 3\n")
      ts_tree_delete(ts_tree_select(toml, "a", "b"))
    Output
      # toml (1 line)
      1 | a.e.f = 3
    Code
      ts_tree_delete(ts_tree_select(toml, "a"))
    Output
      # toml (0 lines)

# ts_tree_delete subtable in table

    Code
      toml <- ts_parse_toml(text = "x = 1\n[a.b]\nc = 1\nd = 2\n[a.c]\ng = 3\n")
      ts_tree_delete(ts_tree_select(toml, "a", "b"))
    Output
      # toml (3 lines)
      1 | x = 1
      2 | [a.c]
      3 | g = 3
    Code
      ts_tree_delete(ts_tree_select(toml, "a"))
    Output
      # toml (1 line)
      1 | x = 1

# ts_tree_delete nothing to delete

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      ts_tree_delete(ts_tree_select(toml, "nothing"))
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

# ts_tree_delete whole document

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      ts_tree_delete(toml)
    Output
      # toml (0 lines)

# ts_tree_delete deleting from special arrays

    Code
      toml <- ts_parse_toml(text = "arr = [1]\n")
      ts_tree_delete(ts_tree_select(toml, "arr", 1))
    Output
      # toml (1 line)
      1 | arr = []

---

    Code
      toml <- ts_parse_toml(text = "arr = []\n")
      ts_tree_delete(ts_tree_select(toml, "arr", TRUE))
    Output
      # toml (1 line)
      1 | arr = []

---

    Code
      toml <- ts_parse_toml(text = "arr = [1, 2, 3]\n")
      ts_tree_delete(ts_tree_select(toml, "arr", 1))
    Output
      # toml (1 line)
      1 | arr = [2, 3]

---

    Code
      toml <- ts_parse_toml(text = "arr = [1, 2, 3]\n")
      ts_tree_delete(ts_tree_select(toml, "arr", 3))
    Output
      # toml (1 line)
      1 | arr = [1, 2]

# ts_tree_delete, keep trailing ws after the last array element

    Code
      toml <- ts_parse_toml(text = "arr = [1, 2, 3  \n]\n")
      ts_tree_delete(ts_tree_select(toml, "arr", 3))
    Output
      # toml (2 lines)
      1 | arr = [1, 2  
      2 | ]

---

    Code
      toml <- ts_parse_toml(text = "arr = [1, [1,2,3], [1,2,3]  \n]\n")
      ts_tree_delete(ts_tree_select(toml, "arr", 3))
    Output
      # toml (2 lines)
      1 | arr = [1, [1,2,3]  
      2 | ]

