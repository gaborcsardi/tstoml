# quoted key

    Code
      unserialize_toml(text = txt)
    Output
      $`127.0.0.1`
      [1] "value"
      
      $`character encoding`
      [1] "value"
      
      $ʎǝʞ
      [1] "value"
      
      $key2
      [1] "value"
      
      $`quoted "value"`
      [1] "value"
      

# dotted key

    Code
      unserialize_toml(text = txt)
    Output
      $name
      [1] "Orange"
      
      $physical
      $physical$color
      [1] "orange"
      
      $physical$shape
      [1] "round"
      
      
      $site
      $site$google.com
      [1] TRUE
      
      

---

    Code
      unserialize_toml(text = txt2)
    Output
      $fruit
      $fruit$name
      [1] "banana"
      
      $fruit$color
      [1] "yellow"
      
      $fruit$flavor
      [1] "banana"
      
      

# key errors

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `add_dom_pair()`:
      ! Duplicate key definition: name.

---

    Code
      unserialize_toml(text = txt2)
    Condition
      Error in `add_dom_pair()`:
      ! Duplicate key definition: spelling.

# more keys

    Code
      unserialize_toml(text = txt)
    Output
      $fruit
      $fruit$apple
      $fruit$apple$smooth
      [1] TRUE
      
      
      $fruit$orange
      [1] 2
      
      

---

    Code
      unserialize_toml(text = txt)
    Output
      $apple
      $apple$type
      [1] "fruit"
      
      $apple$skin
      [1] "thin"
      
      $apple$color
      [1] "red"
      
      
      $orange
      $orange$type
      [1] "fruit"
      
      $orange$skin
      [1] "thick"
      
      $orange$color
      [1] "orange"
      
      

---

    Code
      unserialize_toml(text = txt2)
    Output
      $apple
      $apple$type
      [1] "fruit"
      
      $apple$skin
      [1] "thin"
      
      $apple$color
      [1] "red"
      
      
      $orange
      $orange$type
      [1] "fruit"
      
      $orange$skin
      [1] "thick"
      
      $orange$color
      [1] "orange"
      
      

---

    Code
      unserialize_toml(text = txt3)
    Output
      $`3`
      $`3`$`14159`
      [1] "pi"
      
      

# key errors 2

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `check_sub_keys()`:
      ! Cannot define subtable under pair: fruit.apple.

# offset date-time

    Code
      unserialize_toml(text = glue(
        "\n          odt1 = 1979-05-27T07:32:00Z\n          odt2 = 1979-05-27T00:32:00-07:00\n          odt3 = 1979-05-27T00:32:00.999999-07:00\n          odt4 = 1979-05-27 07:32:00Z\n        "))
    Output
      $odt1
      [1] "1979-05-27 07:32:00 UTC"
      
      $odt2
      [1] "1979-05-27 07:32:00 UTC"
      
      $odt3
      [1] "1979-05-27 07:32:00 UTC"
      
      $odt4
      [1] "1979-05-27 07:32:00 UTC"
      

# local date-time

    Code
      unserialize_toml(text = glue(
        "\n          ldt1 = 1979-05-27T07:32:00\n          ldt2 = 1979-05-27 07:32:00.999999\n        "))
    Output
      $ldt1
      [1] "1979-05-27 07:32:00 CEST"
      
      $ldt2
      [1] "1979-05-27 07:32:00 CEST"
      

# local date

    Code
      unserialize_toml(text = glue(
        "\n          ld1 = 1979-05-27\n          ld2 = 2000-01-01\n        "))
    Output
      $ld1
      [1] "1979-05-27"
      
      $ld2
      [1] "2000-01-01"
      

# local time

    Code
      unserialize_toml(text = glue(
        "\n          lt1 = 07:32:00\n          lt2 = 00:32:00.999999\n        "))
    Output
      $lt1
      07:32:00
      
      $lt2
      00:32:00.999999
      

# basic string

    Code
      txt <- paste0("str = \"I'm a string. \\\"You can quote me\\\". ",
        "Name\\tJos\\u00E9\\nLocation\\tSF.\"")
      unserialize_toml(text = txt)
    Output
      $str
      [1] "I'm a string. \"You can quote me\". Name\tJosé\nLocation\tSF."
      

# multi-line basic string

    Code
      txt <- paste0("str = \"\"\"\n", "Roses are red\n", "Violets are blue\"\"\"\n")
      unserialize_toml(text = txt)
    Output
      $str
      [1] "Roses are red\nViolets are blue"
      

---

    Code
      unserialize_toml(text = txt)
    Output
      $str1
      [1] "The quick brown fox jumps over the lazy dog."
      
      $str2
      [1] "The quick brown fox jumps over the lazy dog."
      
      $str3
      [1] "The quick brown fox jumps over the lazy dog."
      

---

    Code
      unserialize_toml(text = txt2)
    Output
      $str4
      [1] "Here are two quotation marks: \"\". Simple enough."
      
      $str5
      [1] "Here are three quotation marks: \"\"\"."
      
      $str6
      [1] "Here are fifteen quotation marks: \"\"\"\"\"\"\"\"\"\"\"\"\"\"\"."
      
      $str7
      [1] "\"This,\" she said, \"is just a pointless statement.\""
      

---

    Code
      unserialize_toml(text = txt3)
    Output
      $str
      [1] "single ' quotes work fine"
      

# literal string

    Code
      txt <- "str = 'C:\\Users\\nodejs\\templates\\new'"
      unserialize_toml(text = txt)
    Output
      $str
      [1] "C:\\Users\\nodejs\\templates\\new"
      

---

    Code
      unserialize_toml(text = txt2)
    Output
      $winpath
      [1] "C:\\Users\\nodejs\\templates"
      
      $winpath2
      [1] "\\\\ServerX\\admin$\\system32\\"
      
      $quoted
      [1] "Tom \"Dubs\" Preston-Werner"
      
      $regex
      [1] "<\\i\\c*\\s*>"
      

# multi-line literal string

    Code
      unserialize_toml(text = txt)
    Output
      $regex2
      [1] "I [dw]on't need \\d{2} apples"
      
      $lines
      [1] "The first newline is\ntrimmed in raw strings.\n   All other whitespace\n   is preserved.\n"
      

---

    Code
      unserialize_toml(text = txt2)
    Output
      $quot15
      [1] "Here are fifteen quotation marks: \"\"\"\"\"\"\"\"\"\"\"\"\"\"\""
      
      $apos15
      [1] "Here are fifteen apostrophes: '''''''''''''''"
      
      $str
      [1] "'That,' she said, 'is still pointless.'"
      

# array

    Code
      unserialize_toml(text = txt)
    Output
      $integers
      $integers[[1]]
      [1] 1
      
      $integers[[2]]
      [1] 2
      
      $integers[[3]]
      [1] 3
      
      
      $colors
      $colors[[1]]
      [1] "red"
      
      $colors[[2]]
      [1] "yellow"
      
      $colors[[3]]
      [1] "green"
      
      
      $nested_arrays_of_ints
      $nested_arrays_of_ints[[1]]
      $nested_arrays_of_ints[[1]][[1]]
      [1] 1
      
      $nested_arrays_of_ints[[1]][[2]]
      [1] 2
      
      
      $nested_arrays_of_ints[[2]]
      $nested_arrays_of_ints[[2]][[1]]
      [1] 3
      
      $nested_arrays_of_ints[[2]][[2]]
      [1] 4
      
      $nested_arrays_of_ints[[2]][[3]]
      [1] 5
      
      
      
      $nested_mixed_array
      $nested_mixed_array[[1]]
      $nested_mixed_array[[1]][[1]]
      [1] 1
      
      $nested_mixed_array[[1]][[2]]
      [1] 2
      
      
      $nested_mixed_array[[2]]
      $nested_mixed_array[[2]][[1]]
      [1] "a"
      
      $nested_mixed_array[[2]][[2]]
      [1] "b"
      
      $nested_mixed_array[[2]][[3]]
      [1] "c"
      
      
      
      $string_array
      $string_array[[1]]
      [1] "all"
      
      $string_array[[2]]
      [1] "strings"
      
      $string_array[[3]]
      [1] "are the same"
      
      $string_array[[4]]
      [1] "type"
      
      

---

    Code
      unserialize_toml(text = txt2)
    Output
      $numbers
      $numbers[[1]]
      [1] 0.1
      
      $numbers[[2]]
      [1] 0.2
      
      $numbers[[3]]
      [1] 0.5
      
      $numbers[[4]]
      [1] 1
      
      $numbers[[5]]
      [1] 2
      
      $numbers[[6]]
      [1] 5
      
      
      $contributors
      $contributors[[1]]
      [1] "Foo Bar <foo@example.com>"
      
      $contributors[[2]]
      $contributors[[2]]$name
      [1] "Baz Qux"
      
      $contributors[[2]]$email
      [1] "bazqux@example.com"
      
      $contributors[[2]]$url
      [1] "https://example.com/bazqux"
      
      
      

---

    Code
      unserialize_toml(text = txt3)
    Output
      $integers2
      $integers2[[1]]
      [1] 1
      
      $integers2[[2]]
      [1] 2
      
      $integers2[[3]]
      [1] 3
      
      
      $integers3
      $integers3[[1]]
      [1] 1
      
      $integers3[[2]]
      [1] 2
      
      

# table

    Code
      unserialize_toml(text = txt)
    Output
      $`table-1`
      $`table-1`$key1
      [1] "some string"
      
      $`table-1`$key2
      [1] 123
      
      
      $`table-2`
      $`table-2`$key1
      [1] "another string"
      
      $`table-2`$key2
      [1] 456
      
      

---

    Code
      unserialize_toml(text = txt2)
    Output
      $dog
      $dog$tater.man
      $dog$tater.man$type
      $dog$tater.man$type$name
      [1] "pug"
      
      
      
      

---

    Code
      unserialize_toml(text = txt3)
    Output
      $a
      $a$b
      $a$b$c
      named list()
      
      
      
      $d
      $d$e
      $d$e$f
      named list()
      
      
      
      $g
      $g$h
      $g$h$i
      named list()
      
      
      
      $j
      $j$ʞ
      $j$ʞ$l
      named list()
      
      
      

---

    Code
      unserialize_toml(text = txt4)
    Output
      $x
      $x$y
      $x$y$z
      $x$y$z$w
      named list()
      
      
      
      

---

    Code
      unserialize_toml(text = txt5)
    Condition
      Error in `add_dom_table()`:
      ! Duplicate table definition: fruit.

---

    Code
      unserialize_toml(text = txt6)
    Condition
      Error in `add_dom_table()`:
      ! Cannot redefine array of tables as table: fruit.apple.

---

    Code
      unserialize_toml(text = txt7)
    Output
      $fruit
      $fruit$apple
      named list()
      
      $fruit$orange
      named list()
      
      
      $animal
      named list()
      

---

    Code
      unserialize_toml(text = txt8)
    Output
      $fruit
      $fruit$apple
      named list()
      
      $fruit$orange
      named list()
      
      
      $animal
      named list()
      

---

    Code
      unserialize_toml(text = txt9)
    Output
      $name
      [1] "Fido"
      
      $breed
      [1] "pug"
      
      $owner
      $owner$name
      [1] "Regina Dogman"
      
      $owner$member_since
      [1] "1999-08-04"
      
      

---

    Code
      unserialize_toml(text = txt10)
    Output
      $fruit
      $fruit$apple
      $fruit$apple$color
      [1] "red"
      
      $fruit$apple$taste
      $fruit$apple$taste$sweet
      [1] TRUE
      
      
      
      

---

    Code
      unserialize_toml(text = txt11)
    Output
      $fruit
      $fruit$apple
      $fruit$apple$color
      [1] "red"
      
      $fruit$apple$taste
      $fruit$apple$taste$sweet
      [1] TRUE
      
      
      $fruit$apple$texture
      $fruit$apple$texture$smooth
      [1] TRUE
      
      
      
      

---

    Code
      unserialize_toml(text = txt12)
    Output
      $fruit
      $fruit$apple
      $fruit$apple$color
      [1] "red"
      
      $fruit$apple$taste
      $fruit$apple$taste$sweet
      [1] TRUE
      
      
      
      

---

    Code
      unserialize_toml(text = txt13)
    Output
      $fruit
      $fruit$apple
      $fruit$apple$color
      [1] "red"
      
      $fruit$apple$taste
      $fruit$apple$taste$sweet
      [1] TRUE
      
      
      
      

# inline table

    Code
      unserialize_toml(text = txt)
    Output
      $name
      $name$first
      [1] "Tom"
      
      $name$last
      [1] "Preston-Werner"
      
      
      $point
      $point$x
      [1] 1
      
      $point$y
      [1] 2
      
      
      $animal
      $animal$type
      $animal$type$name
      [1] "pug"
      
      
      

# inline tables are self-contained

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `check_sub_keys()`:
      ! Cannot define subtable under pair: product.type.

# inline tables are consistent

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `check_keys()`:
      ! Cannot define subtable under pair in inline table: b.

---

    Code
      unserialize_toml(text = txt2)
    Condition
      Error in `check_inline_table()`:
      ! Duplicate key definition in inline table: x.

# inline tables cannot add keys or sub-tables to an existing table

    Code
      unserialize_toml(text = txt)
    Condition
      Error in `add_dom_pair()`:
      ! Duplicate key definition: type.

# array of tables

    Code
      unserialize_toml(text = txt)
    Output
      $products
      $products[[1]]
      $products[[1]]$name
      [1] "Hammer"
      
      $products[[1]]$sku
      [1] 738594937
      
      
      $products[[2]]
      named list()
      
      $products[[3]]
      $products[[3]]$name
      [1] "Nail"
      
      $products[[3]]$sku
      [1] 284758393
      
      $products[[3]]$color
      [1] "gray"
      
      
      

---

    Code
      unserialize_toml(text = txt2)
    Output
      $fruits
      $fruits[[1]]
      $fruits[[1]]$name
      [1] "apple"
      
      $fruits[[1]]$physical
      $fruits[[1]]$physical$color
      [1] "red"
      
      $fruits[[1]]$physical$shape
      [1] "round"
      
      
      $fruits[[1]]$varieties
      $fruits[[1]]$varieties[[1]]
      $fruits[[1]]$varieties[[1]]$name
      [1] "red delicious"
      
      
      $fruits[[1]]$varieties[[2]]
      $fruits[[1]]$varieties[[2]]$name
      [1] "granny smith"
      
      
      
      
      $fruits[[2]]
      $fruits[[2]]$name
      [1] "banana"
      
      $fruits[[2]]$varieties
      $fruits[[2]]$varieties[[1]]
      $fruits[[2]]$varieties[[1]]$name
      [1] "plantain"
      
      
      
      
      

---

    Code
      unserialize_toml(text = txt3)
    Condition
      Error in `add_dom_table_array_element()`:
      ! Cannot redefine table as array of tables: fruit.

---

    Code
      unserialize_toml(text = txt4)
    Condition
      Error in `add_dom_table_array_element()`:
      ! Cannot redefine table as array of tables: fruits.

---

    Code
      unserialize_toml(text = txt5)
    Condition
      Error in `add_dom_table()`:
      ! Cannot redefine array of tables as table: fruits.varieties.

---

    Code
      unserialize_toml(text = txt6)
    Condition
      Error in `add_dom_table_array_element()`:
      ! Cannot redefine table as array of tables: fruits.physical.

---

    Code
      unserialize_toml(text = txt7)
    Output
      $points
      $points[[1]]
      $points[[1]]$x
      [1] 1
      
      $points[[1]]$y
      [1] 2
      
      $points[[1]]$z
      [1] 3
      
      
      $points[[2]]
      $points[[2]]$x
      [1] 7
      
      $points[[2]]$y
      [1] 8
      
      $points[[2]]$z
      [1] 9
      
      
      $points[[3]]
      $points[[3]]$x
      [1] 2
      
      $points[[3]]$y
      [1] 4
      
      $points[[3]]$z
      [1] 8
      
      
      

