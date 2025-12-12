# tstoml quickstart

tstoml quickstart

## Details

### Create a tstoml object

Create a tstoml object from a string:

    txt <- r"(
    # This is a TOML document

    title = "TOML Example"

    [owner]
    name = "Tom Preston-Werner"
    dob = 1979-05-27T07:32:00-08:00

    [database]
    enabled = true
    ports = [ 8000, 8001, 8002 ]
    data = [ ["delta", "phi"], [3.14] ]
    temp_targets = { cpu = 79.5, case = 72.0 }

    [servers]

    [servers.alpha]
    ip = "10.0.0.1"
    role = "frontend"

    [servers.beta]
    ip = "10.0.0.2"
    role = "backend"
    )"
    toml <- ts_parse_toml(text = txt)

Pretty print a tstoml object:

    toml

    #> # toml (24 lines)
    #>  1 | 
    #>  2 | # This is a TOML document
    #>  3 | 
    #>  4 | title = "TOML Example"
    #>  5 | 
    #>  6 | [owner]
    #>  7 | name = "Tom Preston-Werner"
    #>  8 | dob = 1979-05-27T07:32:00-08:00
    #>  9 | 
    #> 10 | [database]
    #> ℹ 14 more lines
    #> ℹ Use `print(n = ...)` to see more lines

### Select elements in a tstoml object

    ts_tree_select(toml, "owner")

    #> # toml (24 lines, 1 selected element)
    #>   ...
    #>    3  | 
    #>    4  | title = "TOML Example"
    #>    5  | 
    #> >  6  | [owner]
    #> >  7  | name = "Tom Preston-Werner"
    #> >  8  | dob = 1979-05-27T07:32:00-08:00
    #> >  9  | 
    #>   10  | [database]
    #>   11  | enabled = true
    #>   12  | ports = [ 8000, 8001, 8002 ]
    #>   ...

Select element(s) inside elements:

    ts_tree_select(toml, "owner", "name")

    #> # toml (24 lines, 1 selected element)
    #>   ...
    #>    4  | title = "TOML Example"
    #>    5  | 
    #>    6  | [owner]
    #> >  7  | name = "Tom Preston-Werner"
    #>    8  | dob = 1979-05-27T07:32:00-08:00
    #>    9  | 
    #>   10  | [database]
    #>   ...

Select element(s) of an array:

    ts_tree_select(toml, "database", "ports", 1:2)

    #> # toml (24 lines, 2 selected elements)
    #>   ...
    #>    9  | 
    #>   10  | [database]
    #>   11  | enabled = true
    #> > 12  | ports = [ 8000, 8001, 8002 ]
    #>   13  | data = [ ["delta", "phi"], [3.14] ]
    #>   14  | temp_targets = { cpu = 79.5, case = 72.0 }
    #>   15  | 
    #>   ...

Select multiple keys from a table:

    ts_tree_select(toml, "owner", c("name", "dob"))

    #> # toml (24 lines, 2 selected elements)
    #>   ...
    #>    4  | title = "TOML Example"
    #>    5  | 
    #>    6  | [owner]
    #> >  7  | name = "Tom Preston-Werner"
    #> >  8  | dob = 1979-05-27T07:32:00-08:00
    #>    9  | 
    #>   10  | [database]
    #>   11  | enabled = true
    #>   ...

### Delete elements

Delete selected elements:

    ts_tree_select(toml, "owner", "name") |> ts_tree_delete()

    #> # toml (22 lines)
    #>  1 | # This is a TOML document
    #>  2 | 
    #>  3 | title = "TOML Example"
    #>  4 | 
    #>  5 | [owner]
    #>  6 | dob = 1979-05-27T07:32:00-08:00
    #>  7 | 
    #>  8 | [database]
    #>  9 | enabled = true
    #> 10 | ports = [ 8000, 8001, 8002 ]
    #> ℹ 12 more lines
    #> ℹ Use `print(n = ...)` to see more lines

### Insert elements

Insert a key-value pair into the document:

    ts_tree_insert(toml, key = "new_key", "new_value")

    #> # toml (25 lines)
    #>  1 | # This is a TOML document
    #>  2 | 
    #>  3 | title = "TOML Example"
    #>  4 | 
    #>  5 | 
    #>  6 | new_key = "new_value"
    #>  7 | [owner]
    #>  8 | name = "Tom Preston-Werner"
    #>  9 | dob = 1979-05-27T07:32:00-08:00
    #> 10 | 
    #> ℹ 15 more lines
    #> ℹ Use `print(n = ...)` to see more lines

Insert a key-value pair into a table:

    ts_tree_select(toml, "owner") |> ts_tree_insert(key = "dpt", "Engineering")

    #> # toml (24 lines)
    #>  1 | # This is a TOML document
    #>  2 | 
    #>  3 | title = "TOML Example"
    #>  4 | 
    #>  5 | [owner]
    #>  6 | name = "Tom Preston-Werner"
    #>  7 | dob = 1979-05-27T07:32:00-08:00
    #>  8 | dpt = "Engineering"
    #>  9 | 
    #> 10 | [database]
    #> ℹ 14 more lines
    #> ℹ Use `print(n = ...)` to see more lines

Insert an element into an array:

    ts_tree_select(toml, "database", "ports") |>
      ts_tree_insert(10000L) |>
      print(n = 100)

    #> # toml (23 lines)
    #>  1 | # This is a TOML document
    #>  2 | 
    #>  3 | title = "TOML Example"
    #>  4 | 
    #>  5 | [owner]
    #>  6 | name = "Tom Preston-Werner"
    #>  7 | dob = 1979-05-27T07:32:00-08:00
    #>  8 | 
    #>  9 | [database]
    #> 10 | enabled = true
    #> 11 | ports = [ 8000, 8001, 8002, 10000 ]
    #> 12 | data = [ ["delta", "phi"], [3.14] ]
    #> 13 | temp_targets = { cpu = 79.5, case = 72.0 }
    #> 14 | 
    #> 15 | [servers]
    #> 16 | 
    #> 17 | [servers.alpha]
    #> 18 | ip = "10.0.0.1"
    #> 19 | role = "frontend"
    #> 20 | 
    #> 21 | [servers.beta]
    #> 22 | ip = "10.0.0.2"
    #> 23 | role = "backend"

Insert a new table into the document:

    ts_tree_insert(toml, key = "new_table", list(a = 1, b = 2)) |>
      print(n = 100)

    #> # toml (27 lines)
    #>  1 | # This is a TOML document
    #>  2 | 
    #>  3 | title = "TOML Example"
    #>  4 | 
    #>  5 | [owner]
    #>  6 | name = "Tom Preston-Werner"
    #>  7 | dob = 1979-05-27T07:32:00-08:00
    #>  8 | 
    #>  9 | [database]
    #> 10 | enabled = true
    #> 11 | ports = [ 8000, 8001, 8002 ]
    #> 12 | data = [ ["delta", "phi"], [3.14] ]
    #> 13 | temp_targets = { cpu = 79.5, case = 72.0 }
    #> 14 | 
    #> 15 | [servers]
    #> 16 | 
    #> 17 | [servers.alpha]
    #> 18 | ip = "10.0.0.1"
    #> 19 | role = "frontend"
    #> 20 | 
    #> 21 | [servers.beta]
    #> 22 | ip = "10.0.0.2"
    #> 23 | role = "backend"
    #> 24 | 
    #> 25 | [new_table]
    #> 26 | a = 1.0
    #> 27 | b = 2.0

Insert a new array of tables into the document:

    ts_tree_insert(toml, key = "new_aot",
      list(list(x = 1), list(x = 2))) |>
      print(n = 100)

    #> # toml (29 lines)
    #>  1 | # This is a TOML document
    #>  2 | 
    #>  3 | title = "TOML Example"
    #>  4 | 
    #>  5 | [owner]
    #>  6 | name = "Tom Preston-Werner"
    #>  7 | dob = 1979-05-27T07:32:00-08:00
    #>  8 | 
    #>  9 | [database]
    #> 10 | enabled = true
    #> 11 | ports = [ 8000, 8001, 8002 ]
    #> 12 | data = [ ["delta", "phi"], [3.14] ]
    #> 13 | temp_targets = { cpu = 79.5, case = 72.0 }
    #> 14 | 
    #> 15 | [servers]
    #> 16 | 
    #> 17 | [servers.alpha]
    #> 18 | ip = "10.0.0.1"
    #> 19 | role = "frontend"
    #> 20 | 
    #> 21 | [servers.beta]
    #> 22 | ip = "10.0.0.2"
    #> 23 | role = "backend"
    #> 24 | 
    #> 25 | [[new_aot]]
    #> 26 | x = 1.0
    #> 27 | 
    #> 28 | [[new_aot]]
    #> 29 | x = 2.0

### Update elements

Update an existing element:

    ts_tree_select(toml, "title") |> ts_tree_update("A New TOML Example")

    #> # toml (23 lines)
    #>  1 | # This is a TOML document
    #>  2 | 
    #>  3 | title = "A New TOML Example"
    #>  4 | 
    #>  5 | [owner]
    #>  6 | name = "Tom Preston-Werner"
    #>  7 | dob = 1979-05-27T07:32:00-08:00
    #>  8 | 
    #>  9 | [database]
    #> 10 | enabled = true
    #> ℹ 13 more lines
    #> ℹ Use `print(n = ...)` to see more lines

Update multiple emements at once:

    ts_tree_select(toml, "servers", c("alpha", "beta"), "ip") |>
      ts_tree_update("192.168.1.23") |>
      print(n = 100)

    #> # toml (23 lines)
    #>  1 | # This is a TOML document
    #>  2 | 
    #>  3 | title = "TOML Example"
    #>  4 | 
    #>  5 | [owner]
    #>  6 | name = "Tom Preston-Werner"
    #>  7 | dob = 1979-05-27T07:32:00-08:00
    #>  8 | 
    #>  9 | [database]
    #> 10 | enabled = true
    #> 11 | ports = [ 8000, 8001, 8002 ]
    #> 12 | data = [ ["delta", "phi"], [3.14] ]
    #> 13 | temp_targets = { cpu = 79.5, case = 72.0 }
    #> 14 | 
    #> 15 | [servers]
    #> 16 | 
    #> 17 | [servers.alpha]
    #> 18 | ip = "192.168.1.23"
    #> 19 | role = "frontend"
    #> 20 | 
    #> 21 | [servers.beta]
    #> 22 | ip = "192.168.1.23"
    #> 23 | role = "backend"
