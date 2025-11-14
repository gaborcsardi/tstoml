# delete_selected

    Code
      toml <- load_toml(text = toml_example_text())
      delete_selected(select(toml, "owner", "name"))
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
      toml <- load_toml(text = toml_example_text())
      print(delete_selected(select(toml, "database", "ports", 2)), n = Inf)
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
      toml <- load_toml(text = toml_example_text())
      print(delete_selected(select(toml, "servers", "alpha", "role")), n = Inf)
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

# delete_selected table

    Code
      toml <- load_toml(text = toml_example_text())
      delete_selected(select(toml, "owner"))
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
      11 | [servers]
      12 | 
      13 | [servers.alpha]
      14 | ip = "10.0.0.1"
      15 | role = "frontend"
      16 | 
      17 | [servers.beta]
      18 | ip = "10.0.0.2"
      19 | role = "backend"

---

    Code
      toml <- load_toml(text = toml_example_text())
      print(delete_selected(select(toml, "servers", "beta")), n = Inf)
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

# delete_selected pair from inline table

    Code
      toml <- load_toml(text = "a = { x = 1, y = 2, z = 3 }\nb = 2\n")
      delete_selected(select(toml, "a", "y"))
    Output
      # toml (2 lines)
      1 | a = { x = 1, z = 3 }
      2 | b = 2

# delete_selected AOT element

    Code
      toml <- load_toml(text = toml_aot_example2())
      delete_selected(select(toml, "products", 2))
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
      toml <- load_toml(text = toml_aot_example2())
      delete_selected(select(toml, "products", TRUE, "dimensions", 1))
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

# delete_selected whole AOT

    Code
      toml <- load_toml(text = toml_aot_example2())
      delete_selected(select(toml, "products"))
    Output
      # toml (3 lines)
      1 | # A TOML document with all types of arrays of tables
      2 | 
      3 |   

# delete_selected subtable in pair

    Code
      toml <- load_toml(text = "a.b.c = 1\na.b.d = 2\na.e.f = 3\n")
      delete_selected(select(toml, "a", "b"))
    Output
      # toml (1 line)
      1 | a.e.f = 3
    Code
      delete_selected(select(toml, "a"))
    Output
      # toml (0 lines)

# delete_selected subtable in table

    Code
      toml <- load_toml(text = "x = 1\n[a.b]\nc = 1\nd = 2\n[a.c]\ng = 3\n")
      delete_selected(select(toml, "a", "b"))
    Output
      # toml (3 lines)
      1 | x = 1
      2 | [a.c]
      3 | g = 3
    Code
      delete_selected(select(toml, "a"))
    Output
      # toml (1 line)
      1 | x = 1

# delete_selected nothing to delete

    Code
      toml <- load_toml(text = toml_example_text())
      delete_selected(toml)
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

# delete_selected deleting from special arrays

    Code
      toml <- load_toml(text = "arr = [1]\n")
      delete_selected(select(toml, "arr", 1))
    Output
      # toml (1 line)
      1 | arr = []

---

    Code
      toml <- load_toml(text = "arr = []\n")
      delete_selected(select(toml, "arr", TRUE))
    Output
      # toml (1 line)
      1 | arr = []

---

    Code
      toml <- load_toml(text = "arr = [1, 2, 3]\n")
      delete_selected(select(toml, "arr", 1))
    Output
      # toml (1 line)
      1 | arr = [2, 3]

---

    Code
      toml <- load_toml(text = "arr = [1, 2, 3]\n")
      delete_selected(select(toml, "arr", 3))
    Output
      # toml (1 line)
      1 | arr = [1, 2]

# delete_selected, keep trailing ws after the last array element

    Code
      toml <- load_toml(text = "arr = [1, 2, 3  \n]\n")
      delete_selected(select(toml, "arr", 3))
    Output
      # toml (2 lines)
      1 | arr = [1, 2  
      2 | ]

---

    Code
      toml <- load_toml(text = "arr = [1, [1,2,3], [1,2,3]  \n]\n")
      delete_selected(select(toml, "arr", 3))
    Output
      # toml (2 lines)
      1 | arr = [1, [1,2,3]  
      2 | ]

