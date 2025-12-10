# ts_tree_deleted value

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      toml[[list("owner", "name")]] <- ts_tree_deleted()
      toml
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
      toml[[list("title")]] <- ts_tree_deleted()
      toml
    Output
      # toml (21 lines)
       1 | # This is a TOML document
       2 | 
       3 | [owner]
       4 | name = "Tom Preston-Werner"
       5 | dob = 1979-05-27T07:32:00-08:00
       6 | 
       7 | [database]
       8 | enabled = true
       9 | ports = [ 8000, 8001, 8002 ]
      10 | data = [ ["delta", "phi"], [3.14] ]
      i 11 more lines
      i Use `print(n = ...)` to see more lines

---

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      toml[[list("database", "ports", 2)]] <- ts_tree_deleted()
      print(toml, n = Inf)
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
      toml[[list("servers", "alpha", "role")]] <- ts_tree_deleted()
      print(toml, n = Inf)
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

# ts_tree_deleted table

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      toml[["owner"]] <- ts_tree_deleted()
      toml
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
      toml[[list("servers", "beta")]] <- ts_tree_deleted()
      print(toml, n = Inf)
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

# ts_tree_deleted pair from inline table

    Code
      toml <- ts_parse_toml(text = "a = { x = 1, y = 2, z = 3 }\nb = 2\n")
      toml[[list("a", "y")]] <- ts_tree_deleted()
      toml
    Output
      # toml (2 lines)
      1 | a = { x = 1, z = 3 }
      2 | b = 2

# ts_tree_deleted AOT element

    Code
      toml <- ts_parse_toml(text = toml_aot_example2())
      toml[[list("products", 2)]] <- ts_tree_deleted()
      print(toml, n = Inf)
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
      11 | 
      12 |   

---

    Code
      toml <- ts_parse_toml(text = toml_aot_example2())
      toml[[list("products", TRUE, "dimensions", 1)]] <- ts_tree_deleted()
      print(toml, n = Inf)
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
      11 | 
      12 |   

# ts_tree_deleted whole AOT

    Code
      toml <- ts_parse_toml(text = toml_aot_example2())
      toml[[list("products")]] <- ts_tree_deleted()
      print(toml, n = Inf)
    Output
      # toml (3 lines)
      1 | # A TOML document with all types of arrays of tables
      2 | 
      3 |   

# ts_tree_deleted subtable in pair

    Code
      toml <- ts_parse_toml(text = "a.b.c = 1\na.b.d = 2\na.e.f = 3\n")
      toml[[list("a", "b")]] <- ts_tree_deleted()
      toml
    Output
      # toml (1 line)
      1 | a.e.f = 3
    Code
      toml <- ts_parse_toml(text = "a.b.c = 1\na.b.d = 2\na.e.f = 3\n")
      toml[[list("a")]] <- ts_tree_deleted()
      toml
    Output
      # toml (0 lines)

# ts_tree_deleted subtable in table

    Code
      toml <- ts_parse_toml(text = "x = 1\n[a.b]\nc = 1\nd = 2\n[a.c]\ng = 3\n")
      toml[[list("a", "b")]] <- ts_tree_deleted()
      toml
    Output
      # toml (3 lines)
      1 | x = 1
      2 | [a.c]
      3 | g = 3
    Code
      toml <- ts_parse_toml(text = "x = 1\n[a.b]\nc = 1\nd = 2\n[a.c]\ng = 3\n")
      toml[[list("a")]] <- ts_tree_deleted()
      toml
    Output
      # toml (1 line)
      1 | x = 1

# ts_tree_deleted nothing to delete

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      toml[[list("nothing")]] <- ts_tree_deleted()
      print(toml, n = Inf)
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
      18 | ip = "10.0.0.1"
      19 | role = "frontend"
      20 | 
      21 | [servers.beta]
      22 | ip = "10.0.0.2"
      23 | role = "backend"

# ts_tree_deleted whole document

    Code
      toml <- ts_parse_toml(text = toml_example_text())
      toml[[]] <- ts_tree_deleted()
      toml
    Output
      # toml (0 lines)

# ts_tree_deleted deleting from special arrays

    Code
      toml <- ts_parse_toml(text = "arr = [1]\n")
      toml[[list("arr", 1)]] <- ts_tree_deleted()
      toml
    Output
      # toml (1 line)
      1 | arr = []

---

    Code
      toml <- ts_parse_toml(text = "arr = []\n")
      toml[[list("arr", TRUE)]] <- ts_tree_deleted()
      toml
    Output
      # toml (1 line)
      1 | arr = []

---

    Code
      toml <- ts_parse_toml(text = "arr = [1, 2, 3]\n")
      toml[[list("arr", 1)]] <- ts_tree_deleted()
      toml
    Output
      # toml (1 line)
      1 | arr = [2, 3]

---

    Code
      toml <- ts_parse_toml(text = "arr = [1, 2, 3]\n")
      toml[[list("arr", 3)]] <- ts_tree_deleted()
      toml
    Output
      # toml (1 line)
      1 | arr = [1, 2]

# ts_tree_deleted, keep trailing ws after the last array element

    Code
      toml <- ts_parse_toml(text = "arr = [1, 2, 3  \n]\n")
      toml[[list("arr", 3)]] <- ts_tree_deleted()
      toml
    Output
      # toml (2 lines)
      1 | arr = [1, 2  
      2 | ]

---

    Code
      toml <- ts_parse_toml(text = "arr = [1, [1,2,3], [1,2,3]  \n]\n")
      toml[[list("arr", 3)]] <- ts_tree_deleted()
      toml
    Output
      # toml (2 lines)
      1 | arr = [1, [1,2,3]  
      2 | ]

