# insert_into_document

    Code
      ts_tree_insert(toml, key = "a", 1)
    Output
      # toml (1 line)
      1 | a = 1.0
    Code
      ts_tree_insert(toml, key = "b", "foobar")
    Output
      # toml (1 line)
      1 | b = "foobar"
    Code
      ts_tree_insert(toml, key = "c", list(1, 2, 3))
    Output
      # toml (1 line)
      1 | c = [ 1.0, 2.0, 3.0 ]
    Code
      ts_tree_insert(toml, key = "d", structure(list(x = 10, y = 20), class = "ts_toml_inline_table"))
    Output
      # toml (1 line)
      1 | d = { x = 10.0, y = 20.0 }
    Code
      ts_tree_insert(toml, key = "e", ts_toml_inline_table(x = 10, y = 20))
    Output
      # toml (1 line)
      1 | e = { x = 10.0, y = 20.0 }
    Code
      ts_tree_insert(toml, key = "f", structure(list(list(x = 10, y = 20)), class = "ts_toml_array"))
    Output
      # toml (1 line)
      1 | f = [ { x = 10.0, y = 20.0 } ]
    Code
      ts_tree_insert(toml, key = "g", ts_toml_array(10, 20))
    Output
      # toml (1 line)
      1 | g = [ 10.0, 20.0 ]

# insert_into_document table

    Code
      ts_tree_insert(toml, key = "table", list(a = 1, b = 2))
    Output
      # toml (3 lines)
      1 | [table]
      2 | a = 1.0
      3 | b = 2.0

---

    Code
      ts_tree_insert(toml2, key = "table2", list(x = 10, y = 20))
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
      ts_tree_insert(toml, key = "array_of_tables", list(list(a = 1, b = 2), list(a = 3)))
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
      ts_tree_insert(ts_tree_select(toml, "arr"), 0)
    Output
      # toml (1 line)
      1 | arr = [0.0]
    Code
      ts_tree_insert(ts_tree_select(toml, "arr"), "foobar")
    Output
      # toml (1 line)
      1 | arr = ["foobar"]
    Code
      ts_tree_insert(ts_tree_select(toml, "arr"), list(1, 2, 3))
    Output
      # toml (1 line)
      1 | arr = [[ 1.0, 2.0, 3.0 ]]
    Code
      ts_tree_insert(ts_tree_select(toml, "arr"), structure(list(x = 10, y = 20),
      class = "ts_toml_inline_table"))
    Output
      # toml (1 line)
      1 | arr = [{ x = 10.0, y = 20.0 }]

---

    Code
      ts_tree_insert(ts_tree_select(toml2, "arr"), 100)
    Output
      # toml (1 line)
      1 | arr = [1, 2, 3,100.0]
    Code
      ts_tree_insert(ts_tree_select(toml2, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,1, 2, 3]
    Code
      ts_tree_insert(ts_tree_select(toml2, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [1, 100.0,2, 3]
    Code
      ts_tree_insert(ts_tree_select(toml2, "arr"), 100, at = Inf)
    Output
      # toml (1 line)
      1 | arr = [1, 2, 3,100.0]

---

    Code
      ts_tree_insert(ts_tree_select(toml3, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,0]
    Code
      ts_tree_insert(ts_tree_select(toml3, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [0,100.0]

---

    Code
      ts_tree_insert(ts_tree_select(toml4, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,1,2]
    Code
      ts_tree_insert(ts_tree_select(toml4, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [1,100.0,2]
    Code
      ts_tree_insert(ts_tree_select(toml4, "arr"), 100, at = 2)
    Output
      # toml (1 line)
      1 | arr = [1,2,100.0]

---

    Code
      ts_tree_insert(ts_tree_select(toml5, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,0,]
    Code
      ts_tree_insert(ts_tree_select(toml5, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [0,100.0,]

---

    Code
      ts_tree_insert(ts_tree_select(toml6, "arr"), 100, at = 0)
    Output
      # toml (1 line)
      1 | arr = [100.0,1,2,]
    Code
      ts_tree_insert(ts_tree_select(toml6, "arr"), 100, at = 1)
    Output
      # toml (1 line)
      1 | arr = [1,100.0,2,]
    Code
      ts_tree_insert(ts_tree_select(toml6, "arr"), 100, at = 2)
    Output
      # toml (1 line)
      1 | arr = [1,2,100.0,]

# insert_into_inline_table

    Code
      ts_tree_insert(ts_tree_select(toml, "it"), 13, key = "a")
    Output
      # toml (1 line)
      1 | it = {a=13.0}
    Code
      ts_tree_insert(ts_tree_select(toml, "it"), "foobar", key = "b")
    Output
      # toml (1 line)
      1 | it = {b="foobar"}
    Code
      ts_tree_insert(ts_tree_select(toml, "it"), list(1, 2, 3), key = "c")
    Output
      # toml (1 line)
      1 | it = {c=[ 1.0, 2.0, 3.0 ]}
    Code
      ts_tree_insert(ts_tree_select(toml, "it"), structure(list(x = 10, y = 20),
      class = "ts_toml_inline_table"), key = "d")
    Output
      # toml (1 line)
      1 | it = {d={ x = 10.0, y = 20.0 }}

---

    Code
      ts_tree_insert(ts_tree_select(toml2, "it"), 13, key = "c")
    Output
      # toml (1 line)
      1 | it = {a = 1, b = 2,c=13.0}
    Code
      ts_tree_insert(ts_tree_select(toml2, "it"), 13, key = "c", at = 0)
    Output
      # toml (1 line)
      1 | it = {c=13.0,a = 1, b = 2}
    Code
      ts_tree_insert(ts_tree_select(toml2, "it"), 13, key = "c", at = 1)
    Output
      # toml (1 line)
      1 | it = {a = 1, c=13.0,b = 2}
    Code
      ts_tree_insert(ts_tree_select(toml2, "it"), 13, key = "c", at = Inf)
    Output
      # toml (1 line)
      1 | it = {a = 1, b = 2,c=13.0}

# insert_into_table pair

    Code
      ts_tree_insert(ts_tree_select(toml, "table"), 2, key = "b")
    Output
      # toml (6 lines)
      1 | [table]
      2 | a = 1
      3 | b = 2.0
      4 | 
      5 | [table2]
      6 | c = 5

# insert_into_table table

    Code
      ts_tree_insert(ts_tree_select(toml, "table"), list(x = 10, y = 20), key = "subtable")
    Output
      # toml (9 lines)
      1 | [table]
      2 | a = 1
      3 | 
      4 | [table.subtable]
      5 | x = 10.0
      6 | y = 20.0
      7 | 
      8 | [table2]
      9 | c = 5

# insert_into_table array of tables

    Code
      toml <- ts_parse_toml(text = "[table]\na = 1\n\n[table2]\nc = 5\n")
      ts_tree_insert(ts_tree_select(toml, "table"), list(list(x = 10, y = 20), list(
        x = 5)), key = "aot")
    Output
      # toml (12 lines)
       1 | [table]
       2 | a = 1
       3 | 
       4 | [[table.aot]]
       5 | x = 10.0
       6 | y = 20.0
       7 | 
       8 | [[table.aot]]
       9 | x = 5.0
      10 | 
      i 2 more lines
      i Use `print(n = ...)` to see more lines

# insert_into_subtable

    Code
      toml <- ts_parse_toml(text = "a.b.c = 1\n")
      ts_tree_insert(ts_tree_select(toml, "a"), 100L, key = "x")
    Output
      # toml (2 lines)
      1 | a.b.c = 1
      2 | a.x = 100
    Code
      ts_tree_insert(ts_tree_select(toml, "a"), list(x = 100L, y = 200L), key = "x")
    Output
      # toml (2 lines)
      1 | a.b.c = 1
      2 | a.x = { x = 100, y = 200 }
    Code
      ts_tree_insert(ts_tree_select(toml, "a"), as.list(1:3), key = "x")
    Output
      # toml (2 lines)
      1 | a.b.c = 1
      2 | a.x = [ 1, 2, 3 ]
    Code
      ts_tree_insert(ts_tree_select(toml, "a"), list(list(x = 100L, y = 200L)), key = "x")
    Output
      # toml (2 lines)
      1 | a.b.c = 1
      2 | a.x = [ { x = 100, y = 200 } ]

---

    Code
      toml <- ts_parse_toml(text = "[a.b]\nc.d.e = 1\n")
      ts_tree_insert(ts_tree_select(toml, "a", "b", "c"), 100L, key = "x")
    Output
      # toml (3 lines)
      1 | [a.b]
      2 | c.d.e = 1
      3 | c.x = 100

---

    Code
      toml <- ts_parse_toml(text = "[a.b]\nc.d.e = 1\n")
      ts_tree_insert(ts_tree_select(toml, "a"), 100L, key = "x")
    Output
      # toml (3 lines)
      1 | a.x = 100
      2 | [a.b]
      3 | c.d.e = 1

---

    Code
      toml <- ts_parse_toml(text = "[[a.b]]\nc.d.e = 1\n")
      ts_tree_insert(ts_tree_select(toml, "a"), 100L, key = "x")
    Output
      # toml (3 lines)
      1 | a.x = 100
      2 | [[a.b]]
      3 | c.d.e = 1

# insert_into_aot_element

    Code
      toml <- ts_parse_toml(text = "[[a]]\nb=1\n\n[[a]]\nb=2\n")
      ts_tree_insert(ts_tree_select(toml, "a", 1), key = "c", 100L)
    Output
      # toml (6 lines)
      1 | [[a]]
      2 | b=1
      3 | c = 100
      4 | 
      5 | [[a]]
      6 | b=2
    Code
      ts_tree_insert(ts_tree_select(toml, "a", 2), key = "c", 100L)
    Output
      # toml (6 lines)
      1 | [[a]]
      2 | b=1
      3 | 
      4 | [[a]]
      5 | b=2
      6 | c = 100
    Code
      ts_tree_insert(ts_tree_select(toml, "a", 1:2), key = "c", 100L)
    Output
      # toml (7 lines)
      1 | [[a]]
      2 | b=1
      3 | c = 100
      4 | 
      5 | [[a]]
      6 | b=2
      7 | c = 100
    Code
      ts_tree_insert(ts_tree_select(toml, "a", 2), key = "c", list(1, 2, 3))
    Output
      # toml (6 lines)
      1 | [[a]]
      2 | b=1
      3 | 
      4 | [[a]]
      5 | b=2
      6 | c = [ 1.0, 2.0, 3.0 ]
    Code
      ts_tree_insert(ts_tree_select(toml, "a", 2), key = "d", structure(list(x = 10,
        y = 20), class = "ts_toml_inline_table"))
    Output
      # toml (6 lines)
      1 | [[a]]
      2 | b=1
      3 | 
      4 | [[a]]
      5 | b=2
      6 | d = { x = 10.0, y = 20.0 }

# insert_into_aot

    Code
      toml <- ts_parse_toml(text = "[[a]]\nb=1\n\n[[a]]\nb=2\n")
      ts_tree_insert(ts_tree_select(toml, "a"), list(b = 3), at = 0)
    Output
      # toml (8 lines)
      1 | [[a]]
      2 | b = 3.0
      3 | 
      4 | [[a]]
      5 | b=1
      6 | 
      7 | [[a]]
      8 | b=2
    Code
      ts_tree_insert(ts_tree_select(toml, "a"), list(b = 3), at = 1)
    Output
      # toml (8 lines)
      1 | [[a]]
      2 | b=1
      3 | 
      4 | [[a]]
      5 | b = 3.0
      6 | 
      7 | [[a]]
      8 | b=2
    Code
      ts_tree_insert(ts_tree_select(toml, "a"), list(b = 3))
    Output
      # toml (8 lines)
      1 | [[a]]
      2 | b=1
      3 | 
      4 | [[a]]
      5 | b=2
      6 | 
      7 | [[a]]
      8 | b = 3.0

---

    Code
      toml <- ts_parse_toml(text = "# prefix\n[[a]]\nb=1\n\n[[a]]\nb=2\n#postfix\n")
      ts_tree_insert(ts_tree_select(toml, "a"), list(b = 3), at = 0)
    Output
      # toml (10 lines)
       1 | # prefix
       2 | [[a]]
       3 | b = 3.0
       4 | 
       5 | [[a]]
       6 | b=1
       7 | 
       8 | [[a]]
       9 | b=2
      10 | #postfix
    Code
      ts_tree_insert(ts_tree_select(toml, "a"), list(b = 3), at = 1)
    Output
      # toml (10 lines)
       1 | # prefix
       2 | [[a]]
       3 | b=1
       4 | 
       5 | [[a]]
       6 | b = 3.0
       7 | 
       8 | [[a]]
       9 | b=2
      10 | #postfix
    Code
      ts_tree_insert(ts_tree_select(toml, "a"), list(b = 3))
    Output
      # toml (10 lines)
       1 | # prefix
       2 | [[a]]
       3 | b=1
       4 | 
       5 | [[a]]
       6 | b=2
       7 | #postfix
       8 | 
       9 | [[a]]
      10 | b = 3.0

