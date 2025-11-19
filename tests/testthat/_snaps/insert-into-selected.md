# insert_into_document

    Code
      insert_into_selected(toml, key = "a", 1)
    Output
      # toml (1 line)
      1 | a = 1.0
    Code
      insert_into_selected(toml, key = "b", "foobar")
    Output
      # toml (1 line)
      1 | b = "foobar"
    Code
      insert_into_selected(toml, key = "c", list(1, 2, 3))
    Output
      # toml (1 line)
      1 | c = [ 1.0, 2.0, 3.0 ]
    Code
      insert_into_selected(toml, key = "d", structure(list(x = 10, y = 20), class = "ts_toml_inline_table"))
    Output
      # toml (1 line)
      1 | d = { x = 10.0, y = 20.0 }
    Code
      insert_into_selected(toml, key = "d", structure(list(list(x = 10, y = 20)),
      class = "ts_toml_array"))
    Output
      # toml (1 line)
      1 | d = [ { x = 10.0, y = 20.0 } ]

# insert_into_document table

    Code
      insert_into_selected(toml, key = "table", list(a = 1, b = 2))
    Output
      # toml (3 lines)
      1 | [table]
      2 | a = 1.0
      3 | b = 2.0

---

    Code
      insert_into_selected(toml2, key = "table2", list(x = 10, y = 20))
    Output
      # toml (8 lines)
      1 | a = 1
      2 | 
      3 | [table]
      4 | b = 2
      5 | 
      6 | [table2]
      7 | x = 10.0
      8 | y = 20.0

# insert_into_document array of tables

    Code
      insert_into_selected(toml, key = "array_of_tables", list(list(a = 1, b = 2),
      list(a = 3)))
    Output
      # toml (6 lines)
      1 | [[array_of_tables]]
      2 | a = 1.0
      3 | b = 2.0
      4 | 
      5 | [[array_of_tables]]
      6 | a = 3.0

# insert_into_array

    Code
      insert_into_selected(select(toml, "arr"), 0)
    Output
      # toml (1 line)
      1 | arr = [0.0]
    Code
      insert_into_selected(select(toml, "arr"), "foobar")
    Output
      # toml (1 line)
      1 | arr = ["foobar"]
    Code
      insert_into_selected(select(toml, "arr"), list(1, 2, 3))
    Output
      # toml (1 line)
      1 | arr = [[ 1.0, 2.0, 3.0 ]]
    Code
      insert_into_selected(select(toml, "arr"), structure(list(x = 10, y = 20),
      class = "ts_toml_inline_table"))
    Output
      # toml (1 line)
      1 | arr = [{ x = 10.0, y = 20.0 }]

---

    Code
      insert_into_selected(select(toml2, "arr"), 100)
    Output
      # toml (1 line)
      1 | arr = [1, 2, 3,100.0]
    Code
      insert_into_selected(select(toml2, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,1, 2, 3]
    Code
      insert_into_selected(select(toml2, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [1, 100.0,2, 3]
    Code
      insert_into_selected(select(toml2, "arr"), 100, at = Inf)
    Output
      # toml (1 line)
      1 | arr = [1, 2, 3,100.0]

---

    Code
      insert_into_selected(select(toml3, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,0]
    Code
      insert_into_selected(select(toml3, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [0,100.0]

---

    Code
      insert_into_selected(select(toml4, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,1,2]
    Code
      insert_into_selected(select(toml4, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [1,100.0,2]
    Code
      insert_into_selected(select(toml4, "arr"), 100, at = 2)
    Output
      # toml (1 line)
      1 | arr = [1,2,100.0]

---

    Code
      insert_into_selected(select(toml5, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,0,]
    Code
      insert_into_selected(select(toml5, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [0,100.0,]

---

    Code
      insert_into_selected(select(toml6, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,1,2,]
    Code
      insert_into_selected(select(toml6, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [1,100.0,2,]
    Code
      insert_into_selected(select(toml6, "arr"), 100, at = 2)
    Output
      # toml (1 line)
      1 | arr = [1,2,100.0,]

# insert_into_inline_table

    Code
      insert_into_selected(select(toml, "it"), 13, key = "a")
    Output
      # toml (1 line)
      1 | it = {a=13.0}
    Code
      insert_into_selected(select(toml, "it"), "foobar", key = "b")
    Output
      # toml (1 line)
      1 | it = {b="foobar"}
    Code
      insert_into_selected(select(toml, "it"), list(1, 2, 3), key = "c")
    Output
      # toml (1 line)
      1 | it = {c=[ 1.0, 2.0, 3.0 ]}
    Code
      insert_into_selected(select(toml, "it"), structure(list(x = 10, y = 20), class = "ts_toml_inline_table"),
      key = "d")
    Output
      # toml (1 line)
      1 | it = {d={ x = 10.0, y = 20.0 }}

---

    Code
      insert_into_selected(select(toml2, "it"), 13, key = "c")
    Output
      # toml (1 line)
      1 | it = {a = 1, b = 2,c=13.0}
    Code
      insert_into_selected(select(toml2, "it"), 13, key = "c", at = 0)
    Output
      # toml (1 line)
      1 | it = {c=13.0,a = 1, b = 2}
    Code
      insert_into_selected(select(toml2, "it"), 13, key = "c", at = 1)
    Output
      # toml (1 line)
      1 | it = {a = 1, c=13.0,b = 2}
    Code
      insert_into_selected(select(toml2, "it"), 13, key = "c", at = Inf)
    Output
      # toml (1 line)
      1 | it = {a = 1, b = 2,c=13.0}

