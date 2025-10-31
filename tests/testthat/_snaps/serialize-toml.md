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

