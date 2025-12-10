# serialize_toml

    Code
      tobj
    Output
      $a
      $a$b
      [1] 1
      
      $a$c
      [1] 2.5
      
      $a$d
      [1] "hello"
      
      
      $e
      [1] TRUE
      
    Code
      writeLines(serialize_toml(tobj))
    Output
      e = true
      
      [a]
      b = 1
      c = 2.5
      d = "hello"

---

    Code
      tobj2
    Output
      $a
      $a$b
      [1] 1
      
      $a$c
      [1] 2.5
      
      $a$d
      [1] "hello"
      
      
    Code
      writeLines(serialize_toml(tobj2))
    Output
      [a]
      b = 1
      c = 2.5
      d = "hello"

# ts_toml_table

    Code
      tbl <- list(tab = ts_toml_table(a = 1L, b = 2.5, c = "hello"))
      writeLines(serialize_toml(tbl))
    Output
      [tab]
      a = 1
      b = 2.5
      c = "hello"

# ts_toml_inline_table

    Code
      tbl <- list(tab = ts_toml_inline_table(a = 1L, b = 2.5, c = "hello"))
      writeLines(serialize_toml(tbl))
    Output
      tab = { a = 1, b = 2.5, c = "hello" }

---

    Code
      ts_toml_inline_table(a = 1, 100)
    Condition
      Error in `ts_toml_inline_table()`:
      ! All elements of TOML tables must be named.

# ts_toml_array

    Code
      arr <- list(arr = ts_toml_array(1L, a = 2L, 3L, 4L))
      writeLines(serialize_toml(arr))
    Output
      arr = [ 1, 2, 3, 4 ]

# ts_toml_array_of_tables

    Code
      aot <- list(aot = ts_toml_array_of_tables(list(name = "Alice", age = 30L), list(
        name = "Bob", age = 25L)))
      writeLines(serialize_toml(aot))
    Output
      [[aot]]
      name = "Alice"
      age = 30
      
      [[aot]]
      name = "Bob"
      age = 25

---

    Code
      ts_toml_array_of_tables()
    Condition
      Error in `ts_toml_array_of_tables()`:
      ! TOML array of tables must have at least one element.

---

    Code
      ts_toml_array_of_tables(list(list(1, 2, 3)))
    Condition
      Error in `ts_toml_array_of_tables()`:
      ! All elements of a TOML array of tables must be named lists.

# stl_inline

    Code
      now
    Output
      [1] "2025-10-31 10:38:54 CET"
    Code
      stl_inline(now)
    Output
      [1] "2025-10-31T10:38:54+01:00"

---

    Code
      now2
    Output
      [1] "2025-10-31 10:38:54 CET"
    Code
      stl_inline(now2)
    Output
      [1] "2025-10-31T10:38:54"

---

    Code
      today
    Output
      [1] "2025-10-31"
    Code
      stl_inline(today)
    Output
      [1] "2025-10-31"

---

    Code
      dt
    Output
      01:05:13.125
    Code
      stl_inline(dt)
    Output
      [1] "01:05:13.125000"

---

    Code
      inline_table
    Output
      $a
      [1] 1
      
      $b
      $b[[1]]
      [1] 1
      
      $b[[2]]
      [1] 2
      
      $b[[3]]
      [1] 3
      
      
    Code
      stl_inline(inline_table)
    Output
      [1] "{ a = 1.0, b = [ 1, 2, 3 ] }"

---

    Code
      a
    Output
      complex(0)
    Code
      stl_inline(a)
    Condition
      Error:
      ! Invalid argument: `a`. Cannot convert an empty complex vector to TOML.

# serialize_toml_value

    Code
      t <- structure(1763104922, class = c("POSIXct", "POSIXt"), tzone = "UTC")
      serialize_toml_value(t)
    Output
      [1] "2025-11-14T07:22:02+00:00"
    Code
      serialize_toml_value(as.POSIXlt(t))
    Output
      [1] "2025-11-14T07:22:02"
    Code
      serialize_toml_value(as.Date("2025-10-31"))
    Output
      [1] "2025-10-31"
    Code
      serialize_toml_value(hms::hms(12, 30, 15))
    Output
      [1] "15:30:12.000000"
    Code
      serialize_toml_value(list(a = 1, b = 2))
    Output
      [1] "{ a = 1.0, b = 2.0 }"
    Code
      serialize_toml_value(list(1, 2, 3))
    Output
      [1] "[ 1.0, 2.0, 3.0 ]"
    Code
      serialize_toml_value(3.14)
    Output
      [1] "3.14"
    Code
      serialize_toml_value("hello")
    Output
      [1] "\"hello\""
    Code
      serialize_toml_value(42L)
    Output
      [1] "42"
    Code
      serialize_toml_value(TRUE)
    Output
      [1] "true"

# array of tables

    Code
      aot <- list(people = list(list(name = "Alice", age = 30L), list(name = "Bob",
        age = 25L)))
      writeLines(serialize_toml(aot))
    Output
      [[people]]
      name = "Alice"
      age = 30
      
      [[people]]
      name = "Bob"
      age = 25

---

    Code
      aot2 <- list(products = list(list(names = "Hammer", sku = 738594937,
        dimensions = list(list(length = 7, width = 0.5, height = 0.25))), list(names = "Nail",
        sku = 284758393, color = "gray", dimensions = list(list(length = 0.5, width = 0.1,
          height = 0.1)))))
      writeLines(serialize_toml(aot2))
    Output
      [[products]]
      names = "Hammer"
      sku = 738594937.0
      
      [[products.dimensions]]
      length = 7.0
      width = 0.5
      height = 0.25
      
      [[products]]
      names = "Nail"
      sku = 284758393.0
      color = "gray"
      
      [[products.dimensions]]
      length = 0.5
      width = 0.1
      height = 0.1

# float

    Code
      writeLines(serialize_toml(list(a = NaN, b = Inf, c = -Inf, d = 3.14)))
    Output
      a = nan
      b = inf
      c = -inf
      d = 3.14

