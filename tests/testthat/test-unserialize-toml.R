test_that("unserialize_toml empty document", {
  expect_equal(
    unserialize_toml(text = ""),
    structure(list(), names = character())
  )
})

test_that("bare key", {
  expect_equal(
    unserialize_toml(text = "key = 1"),
    list(key = 1L)
  )
})

test_that("quoted key", {
  expect_equal(
    unserialize_toml(text = '"key with spaces" = 2'),
    list("key with spaces" = 2L)
  )
})

test_that("quoted key UTF-8", {
  if (!l10n_info()[["UTF-8"]]) {
    skip("Not UTF-8")
  }
  txt <-
    '"127.0.0.1" = "value"
"character encoding" = "value"
"ʎǝʞ" = "value"
\'key2\' = "value"
\'quoted "value"\' = "value"
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })
})

test_that("dotted key", {
  txt <-
    'name = "Orange"
physical.color = "orange"
physical.shape = "round"
site."google.com" = true
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })
  txt2 <-
    'fruit.name = "banana"     # this is best practice
fruit. color = "yellow"    # same as fruit.color
fruit . flavor = "banana"   # same as fruit.flavor
  '
  expect_snapshot({
    unserialize_toml(text = txt2)
  })
})

test_that("key errors", {
  txt <-
    '# DO NOT DO THIS
name = "Tom"
name = "Pradyun"
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt)
  })

  txt2 <-
    '# THIS WILL NOT WORK
spelling = "favorite"
"spelling" = "favourite"
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt2)
  })
})

test_that("more keys", {
  txt <-
    '# This makes the key "fruit" into a table.
fruit.apple.smooth = true

# So then you can add to the table "fruit" like so:
fruit.orange = 2
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })
})

test_that("key errors 2", {
  txt <-
    '# THE FOLLOWING IS INVALID

# This defines the value of fruit.apple to be an integer.
fruit.apple = 1

# But then this treats fruit.apple like it\'s a table.
# You can\'t turn an integer into a table.
fruit.apple.smooth = true
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt)
  })
})

test_that("more keys", {
  txt <-
    '# VALID BUT DISCOURAGED

apple.type = "fruit"
orange.type = "fruit"

apple.skin = "thin"
orange.skin = "thick"

apple.color = "red"
orange.color = "orange"
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })

  txt2 <-
    '# RECOMMENDED

apple.type = "fruit"
apple.skin = "thin"
apple.color = "red"

orange.type = "fruit"
orange.skin = "thick"
orange.color = "orange"
'
  expect_snapshot({
    unserialize_toml(text = txt2)
  })

  txt3 <-
    '3.14159 = "pi"
'
  expect_snapshot({
    unserialize_toml(text = txt3)
  })
})

test_that("integers", {
  expect_equal(
    unserialize_toml(
      text = "
          int1 = +99
          int2 = 42
          int3 = 0

          int4 = -17
          int5 = 1_000
          int6 = 5_349_221
          int7 = 53_49_221  # Indian number system grouping
          int8 = 1_2_3_4_5  # VALID but discouraged

          # hexadecimal with prefix `0x`
          hex1 = 0xDEADBEE
          hex2 = 0xdeadbee
          hex3 = 0xdead_bee

          # octal with prefix `0o`
          oct1 = 0o01234567
          oct2 = 0o755 # useful for Unix file permissions

          # binary with prefix `0b`
          bin1 = 0b11010110
    "
    ),
    list(
      int1 = 99L,
      int2 = 42L,
      int3 = 0L,
      int4 = -17L,
      int5 = 1000L,
      int6 = 5349221L,
      int7 = 5349221L,
      int8 = 12345L,
      hex1 = 0xDEADBEE,
      hex2 = 0xDEADBEE,
      hex3 = 0xDEADBEE,
      oct1 = strtoi("1234567", base = 8L),
      oct2 = strtoi("755", base = 8L),
      bin1 = strtoi("11010110", base = 2L)
    )
  )
})

test_that("float", {
  expect_equal(
    unserialize_toml(
      text = "
        # fractional
        flt1 = +1.0
        flt2 = 3.1415
        flt3 = -0.01

        # exponent
        flt4 = 5e+22
        flt5 = 1e06
        flt6 = -2E-2

        # both
        flt7 = 6.626e-34

        flt8 = 224_617.445_991_228

        # infinity
        sf1 = inf  # positive infinity
        sf2 = +inf # positive infinity
        sf3 = -inf # negative infinity

        # not a number
        sf4 = nan  # actual sNaN/qNaN encoding is implementation-specific
        sf5 = +nan # same as `nan`
        sf6 = -nan # valid, actual encoding is implementation-specific
      "
    ),
    list(
      flt1 = 1.0,
      flt2 = 3.1415,
      flt3 = -0.01,
      flt4 = 5e+22,
      flt5 = 1e+06,
      flt6 = -2e-2,
      flt7 = 6.626e-34,
      flt8 = 224617.445991228,
      sf1 = Inf,
      sf2 = Inf,
      sf3 = -Inf,
      sf4 = NaN,
      sf5 = NaN,
      sf6 = NaN
    )
  )
})

test_that("boolean", {
  expect_equal(
    unserialize_toml(text = "key = true"),
    list(key = TRUE)
  )
  expect_equal(
    unserialize_toml(text = "key = false"),
    list(key = FALSE)
  )
})

test_that("offset date-time", {
  expect_snapshot({
    unserialize_toml(
      text = "
          odt1 = 1979-05-27T07:32:00Z
          odt2 = 1979-05-27T00:32:00-07:00
          odt3 = 1979-05-27T00:32:00.999999-07:00
          odt4 = 1979-05-27 07:32:00Z
        "
    )
  })
})

test_that("local date-time", {
  withr::local_timezone("UTC")
  expect_snapshot({
    unserialize_toml(
      text = "
          ldt1 = 1979-05-27T07:32:00
          ldt2 = 1979-05-27 07:32:00.999999
        "
    )
  })
})

test_that("local date", {
  expect_snapshot({
    unserialize_toml(
      text = "
          ld1 = 1979-05-27
          ld2 = 2000-01-01
        "
    )
  })
  expect_equal(
    class(unserialize_toml(text = "ld1 = 1979-05-27")$ld1),
    "Date"
  )
})

test_that("local time", {
  loadNamespace("hms")
  expect_snapshot({
    unserialize_toml(
      text = "
          lt1 = 07:32:00
          lt2 = 00:32:00.999999
        "
    )
  })
  expect_equal(
    class(unserialize_toml(text = "lt1 = 07:32:00")$lt1),
    c("hms", "difftime")
  )
})

test_that("basic string", {
  if (!l10n_info()[["UTF-8"]]) {
    skip("Not UTF-8")
  }
  expect_snapshot({
    txt <- paste0(
      'str = "I\'m a string. \\"You can quote me\\". ',
      'Name\\tJos\\u00E9\\nLocation\\tSF."'
    )
    unserialize_toml(text = txt)
  })
})

test_that("multi-line basic string", {
  expect_snapshot({
    txt <- paste0(
      'str = """\n',
      'Roses are red\n',
      'Violets are blue"""\n'
    )
    unserialize_toml(text = txt)
  })

  txt <-
    '# The following strings are byte-for-byte equivalent:
str1 = "The quick brown fox jumps over the lazy dog."

str2 = """
The quick brown \\


  fox jumps over \\
    the lazy dog."""

str3 = """\\
       The quick brown \\
       fox jumps over \\
       the lazy dog.\\
       """
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })

  txt2 <-
    'str4 = """Here are two quotation marks: "". Simple enough."""
# str5 = """Here are three quotation marks: """."""  # INVALID
str5 = """Here are three quotation marks: ""\\"."""
str6 = """Here are fifteen quotation marks: ""\\"""\\"""\\"""\\"""\\"."""

# "This," she said, "is just a pointless statement."
str7 = """"This," she said, "is just a pointless statement.""""
'
  expect_snapshot({
    unserialize_toml(text = txt2)
  })

  txt3 <- 'str = """single \' quotes work fine"""'
  expect_snapshot({
    unserialize_toml(text = txt3)
  })
})

test_that("literal string", {
  expect_snapshot({
    txt <- "str = 'C:\\Users\\nodejs\\templates\\new'"
    unserialize_toml(text = txt)
  })
  txt2 <-
    '# What you see is what you get.
winpath  = \'C:\\Users\\nodejs\\templates\'
winpath2 = \'\\\\ServerX\\admin$\\system32\\\'
quoted   = \'Tom "Dubs" Preston-Werner\'
regex    = \'<\\i\\c*\\s*>\'
'
  expect_snapshot({
    unserialize_toml(text = txt2)
  })
})

test_that("multi-line literal string", {
  txt <-
    'regex2 = \'\'\'I [dw]on\'t need \\d{2} apples\'\'\'
lines  = \'\'\'
The first newline is
trimmed in raw strings.
   All other whitespace
   is preserved.
\'\'\'
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })

  txt2 <-
    'quot15 = \'\'\'Here are fifteen quotation marks: """""""""""""""\'\'\'

# apos15 = \'\'\'Here are fifteen apostrophes: \'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'\'  # INVALID
apos15 = "Here are fifteen apostrophes: \'\'\'\'\'\'\'\'\'\'\'\'\'\'\'"

# \'That,\' she said, \'is still pointless.\'
str = \'\'\'\'That,\' she said, \'is still pointless.\'\'\'\'
'
  expect_snapshot({
    unserialize_toml(text = txt2)
  })
})

test_that("array", {
  txt <-
    'integers = [ 1, 2, 3 ]
colors = [ "red", "yellow", "green" ]
nested_arrays_of_ints = [ [ 1, 2 ], [3, 4, 5] ]
nested_mixed_array = [ [ 1, 2 ], ["a", "b", "c"] ]
string_array = [ "all", \'strings\', """are the same""", \'\'\'type\'\'\' ]
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })

  txt2 <-
    '# Mixed-type arrays are allowed
numbers = [ 0.1, 0.2, 0.5, 1, 2, 5 ]
contributors = [
  "Foo Bar <foo@example.com>",
  { name = "Baz Qux", email = "bazqux@example.com", url = "https://example.com/bazqux" }
]
'
  expect_snapshot({
    unserialize_toml(text = txt2)
  })

  txt3 <-
    'integers2 = [
  1, 2, 3
]

integers3 = [
  1,
  2, # this is ok
]
'
  expect_snapshot({
    unserialize_toml(text = txt3)
  })
})

test_that("table", {
  expect_equal(
    unserialize_toml(text = "[table]"),
    list(table = structure(list(), names = character()))
  )
  txt <-
    '[table-1]
key1 = "some string"
key2 = 123

[table-2]
key1 = "another string"
key2 = 456
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })

  txt2 <-
    '[dog."tater.man"]
type.name = "pug"
'
  expect_snapshot({
    unserialize_toml(text = txt2)
  })

  txt4 <-
    '# [x] you
# [x.y] don\'t
# [x.y.z] need these
[x.y.z.w] # for this to work

[x] # defining a super-table afterward is ok
'
  expect_snapshot({
    unserialize_toml(text = txt4)
  })

  txt5 <-
    '# DO NOT DO THIS

[fruit]
apple = "red"

[fruit]
orange = "orange"
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt5)
  })

  txt6 <-
    '# DO NOT DO THIS EITHER

[fruit]
apple = "red"

[fruit.apple]
texture = "smooth"
'

  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt6)
  })

  txt7 <-
    '# VALID BUT DISCOURAGED
[fruit.apple]
[animal]
[fruit.orange]
'
  expect_snapshot({
    unserialize_toml(text = txt7)
  })

  txt8 <-
    '# RECOMMENDED
[fruit.apple]
[fruit.orange]
[animal]
'
  expect_snapshot({
    unserialize_toml(text = txt8)
  })

  txt9 <-
    '# Top-level table begins.
name = "Fido"
breed = "pug"

# Top-level table ends.
[owner]
name = "Regina Dogman"
member_since = 1999-08-04
'
  expect_snapshot({
    unserialize_toml(text = txt9)
  })

  txt10 <-
    'fruit.apple.color = "red"
# Defines a table named fruit
# Defines a table named fruit.apple

fruit.apple.taste.sweet = true
# Defines a table named fruit.apple.taste
# fruit and fruit.apple were already created
'
  expect_snapshot({
    unserialize_toml(text = txt10)
  })

  txt11 <-
    '[fruit]
apple.color = "red"
apple.taste.sweet = true

# [fruit.apple]  # INVALID
# [fruit.apple.taste]  # INVALID

[fruit.apple.texture]  # you can add sub-tables
smooth = true
'
  expect_snapshot({
    unserialize_toml(text = txt11)
  })

  txt12 <-
    '[fruit]
apple.color = "red"
apple.taste.sweet = true

[fruit.apple]  # INVALID in the docs, but allowed by us
'

  expect_snapshot({
    unserialize_toml(text = txt12)
  })

  txt13 <-
    '[fruit]
apple.color = "red"
apple.taste.sweet = true

# [fruit.apple]  # INVALID
[fruit.apple.taste]  # INVALID
'
  expect_snapshot({
    unserialize_toml(text = txt13)
  })
})

test_that("table, UTF-8", {
  if (!l10n_info()[["UTF-8"]]) {
    skip("Not UTF-8")
  }
  txt3 <-
    '[a.b.c]            # this is best practice
[ d.e.f ]          # same as [d.e.f]
[ g .  h  . i ]    # same as [g.h.i]
[ j . "ʞ" . \'l\' ]  # same as [j."ʞ".\'l\']
'
  expect_snapshot({
    unserialize_toml(text = txt3)
  })
})

test_that("inline table", {
  txt <-
    'name = { first = "Tom", last = "Preston-Werner" }
point = { x = 1, y = 2 }
animal = { type.name = "pug" }
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })
})

test_that("inline tables are self-contained", {
  txt <- '
[product]
type = { name = "Nail" }
type.edible = false  # INVALID
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt)
  })
})

test_that("inline tables are consistent", {
  txt <- '
a = { b = 1, b.b = 2 }  # INVALID
'

  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt)
  })

  txt2 <- '
a = { a = { a = { x.x = 2, x = 1 } } }  # INVALID
  '

  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt2)
  })
})

test_that("inline tables cannot add keys or sub-tables to an existing table", {
  txt <-
    '[product]
type.name = "Nail"
type = { edible = false }  # INVALID
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt)
  })
})

test_that("array of tables", {
  txt <-
    '[[products]]
name = "Hammer"
sku = 738594937

[[products]]  # empty table within the array

[[products]]
name = "Nail"
sku = 284758393

color = "gray"
'
  expect_snapshot({
    unserialize_toml(text = txt)
  })

  txt2 <-
    '[[fruits]]
name = "apple"

[fruits.physical]  # subtable
color = "red"
shape = "round"

[[fruits.varieties]]  # nested array of tables
name = "red delicious"

[[fruits.varieties]]
name = "granny smith"


[[fruits]]
name = "banana"

[[fruits.varieties]]
name = "plantain"
'
  expect_snapshot({
    unserialize_toml(text = txt2)
  })

  txt3 <-
    '# INVALID TOML DOC
[fruit.physical]  # subtable, but to which parent element should it belong?
color = "red"
shape = "round"

[[fruit]]  # parser must throw an error upon discovering that "fruit" is
           # an array rather than a table
name = "apple"
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt3)
  })

  txt4 <-
    '# INVALID TOML DOC
fruits = []

[[fruits]] # Not allowed
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt4)
  })

  txt5 <-
    '# INVALID TOML DOC
[[fruits]]
name = "apple"

[[fruits.varieties]]
name = "red delicious"

# INVALID: This table conflicts with the previous array of tables
[fruits.varieties]
name = "granny smith"
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt5)
  })

  txt6 <-
    '[fruits.physical]
color = "red"
shape = "round"

# INVALID: This array of tables conflicts with the previous table
[[fruits.physical]]
color = "green"
'
  expect_snapshot(error = TRUE, {
    unserialize_toml(text = txt6)
  })

  txt7 <-
    'points = [ { x = 1, y = 2, z = 3 },
           { x = 7, y = 8, z = 9 },
           { x = 2, y = 4, z = 8 } ]
'
  expect_snapshot({
    unserialize_toml(text = txt7)
  })
})
