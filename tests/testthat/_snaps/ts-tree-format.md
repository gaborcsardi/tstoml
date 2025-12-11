# eliminate newlines

    Code
      tree <- ts_parse_toml("foo=1\n\n\nbar=2")
      ts_tree_format(tree)
    Output
      # toml (2 lines)
      1 | foo = 1
      2 | bar = 2

---

    Code
      tree <- ts_parse_toml("[tab]\nfoo=1\n\n\nbar=2")
      ts_tree_format(tree)
    Output
      # toml (3 lines)
      1 | [tab]
      2 | foo = 1
      3 | bar = 2

# eliminate whitespace

    Code
      tree <- ts_parse_toml("foo     =1    \n   bar=    2")
      ts_tree_format(tree)
    Output
      # toml (2 lines)
      1 | foo = 1
      2 | bar = 2

# keep one empty line between tables

    Code
      tree <- ts_parse_toml("[t1]\nfoo=1\n\n[t2]\n\n\n\n\n[t3]\nbar=2")
      ts_tree_format(tree)
    Output
      # toml (7 lines)
      1 | [t1]
      2 | foo = 1
      3 | 
      4 | [t2]
      5 | 
      6 | [t3]
      7 | bar = 2

---

    Code
      tree <- ts_parse_toml("[[t1]]\nfoo=1\n\n[[t1]]\n\n\n\n\n[[t2]]\nbar=2")
      ts_tree_format(tree)
    Output
      # toml (7 lines)
      1 | [[t1]]
      2 | foo = 1
      3 | 
      4 | [[t1]]
      5 | 
      6 | [[t2]]
      7 | bar = 2

# options

    Code
      tree <- ts_parse_toml("foo     =1    \n   bar=    2")
      ts_tree_format(tree, options = list())
    Output
      # toml (2 lines)
      1 | foo = 1
      2 | bar = 2

# multi-line value

    Code
      tree <- ts_parse_toml("foo = \"\"\"\nThis is a\nmulti-line\nstring.\n\"\"\"")
      ts_tree_format(tree)
    Output
      # toml (5 lines)
      1 | foo = """
      2 | This is a
      3 | multi-line
      4 | string.
      5 | """

---

    Code
      tree <- ts_parse_toml("foo = [1,\n2,\n3,\n4\n]")
      ts_tree_format(tree)
    Output
      # toml (1 line)
      1 | foo = [ 1, 2, 3, 4 ]

# indentation is kept if value is formattted

    Code
      tree <- ts_parse_toml("[table]\n   key = [1,2,3,\n4,5,6]")
      ts_tree_format(ts_tree_select(tree, "table", "key"))
    Output
      # toml (2 lines)
      1 | [table]
      2 |    key = [ 1, 2, 3, 4, 5, 6 ]

# inline table

    Code
      tree <- ts_parse_toml("foo = {a=1,b=2,c=3}")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (1 line)
      1 | foo = { a = 1, b = 2, c = 3 }

# float

    Code
      tree <- ts_parse_toml("foo = 1.2300")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (1 line)
      1 | foo = 1.2300

# boolean

    Code
      tree <- ts_parse_toml("foo = [true,false]")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (1 line)
      1 | foo = [ true, false ]

# date-time

    Code
      tree <- ts_parse_toml("foo = 2024-01-01T12:34:56Z")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (1 line)
      1 | foo = 2024-01-01T12:34:56Z

---

    Code
      tree <- ts_parse_toml("foo = 1979-05-27T07:32:00")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (1 line)
      1 | foo = 1979-05-27T07:32:00

# date

    Code
      tree <- ts_parse_toml("foo = 2024-06-15")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (1 line)
      1 | foo = 2024-06-15

# time

    Code
      tree <- ts_parse_toml("foo = 12:34:56")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (1 line)
      1 | foo = 12:34:56

# comment

    Code
      tree <- ts_parse_toml("# This is a comment\nfoo=1 #c1\nbar=2 # c2")
      ts_tree_format(tree)
    Output
      # toml (3 lines)
      1 | # This is a comment
      2 | foo = 1 # c1
      3 | bar = 2 # c2

---

    Code
      tree <- ts_parse_toml("foo= { x = 1, y = 2 }    #comment")
      ts_tree_format(tree)
    Output
      # toml (1 line)
      1 | foo = { x = 1, y = 2 } # comment

---

    Code
      tree <- ts_parse_toml("#c1\n[tab] # c2\n #c3\nfoo = 1 #c4")
      ts_tree_format(tree)
    Output
      # toml (6 lines)
      1 | # c1
      2 | 
      3 | [tab]
      4 | # c2
      5 | # c3
      6 | foo = 1 # c4

---

    Code
      tree <- ts_parse_toml("foo = [ #c1\n  1, #c2\n  2, #c3\n]")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (5 lines)
      1 | foo = [
      2 |     # c1
      3 |     1,  # c2
      4 |     2,  # c3
      5 | ]

---

    Code
      tree <- ts_parse_toml("foo = [ #c1\n  1 #c2\n,  2 #c3\n]")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (6 lines)
      1 | foo = [
      2 |     # c1
      3 |     1 # c2
      4 |     , 
      5 |     2 # c3
      6 | ]

# format with tabs

    Code
      tree <- ts_parse_toml("foo = [ #c1\n  1, #c2\n  2, #c3\n]")
      ts_tree_format(ts_tree_select(tree, "foo"), options = list(indent_style = "tab"))
    Output
      # toml (5 lines)
      1 | foo = [
      2 | 	# c1
      3 | 	1,  # c2
      4 | 	2,  # c3
      5 | ]

# empty array

    Code
      tree <- ts_parse_toml("foo = [          ]")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (1 line)
      1 | foo = []

---

    Code
      tree <- ts_parse_toml("foo = [    # comment\n      ]")
      ts_tree_format(ts_tree_select(tree, "foo"))
    Output
      # toml (3 lines)
      1 | foo = [
      2 |     # comment
      3 | ]

