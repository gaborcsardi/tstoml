# Select parts of a TOML tree-sitter tree

This function is the heart of ts. To edit a tree-sitter tree, you first
need to select the parts you want to delete or update.

This is the S3 method of the
[`ts::ts_tree_select()`](https://rdrr.io/pkg/ts/man/ts_tree_select.html)
generic, for
[tstoml](https://gaborcsardi.github.io/tstoml/reference/tstoml-package.md)
objects.

## Usage

``` r
# S3 method for class 'ts_tree_toml'
ts_tree_select(tree, ..., refine = FALSE)
```

## Arguments

- tree:

  A `ts_tree` object as returned by
  [`ts_tree_new()`](https://rdrr.io/pkg/ts/man/ts_tree_new.html).

- ...:

  Selection expressions, see details.

- refine:

  Logical, whether to refine the current selection or start a new
  selection.

## Value

A `ts_tree` object with the selected parts.

## Details

The selection process is iterative. Selection expressions (selectors)
are applied one by one, and each selector selects nodes from the
currently selected nodes. For each selector, it is applied individually
to each currently selected node, and the results are concatenated.

The selection process starts from the root of the DOM tree, the document
node (see
[`ts_tree_dom()`](https://rdrr.io/pkg/ts/man/ts_tree_dom.html)), unless
`refine = TRUE` is set, in which case it starts from the current
selection.

See the various types of selection expressions below.

### Selectors

#### All elements: `TRUE`

Selects all child nodes of the current nodes.

 

    toml <- tstoml::ts_parse_toml('
      a = 1
      b = [10, 20, 30]
      [c]
      c1 = true
      c2 = []
    ')
    toml |> ts_tree_select(c("b", "c"), TRUE)

    #> # toml (6 lines, 5 selected elements)
    #>   1 | 
    #>   2 |   a = 1
    #> > 3 |   b = [10, 20, 30]
    #>   4 |   [c]
    #> > 5 |   c1 = true
    #> > 6 |   c2 = []

#### Specific keys: character vector

Selects child nodes with the given names from nodes with named children.
If a node has no named children, it selects nothing from that node.

 

    toml <- tstoml::ts_parse_toml('
      a = 1
      b = [10, 20, 30]
      [c]
      c1 = true
      c2 = []
    ')
    toml |> ts_tree_select(c("a", "c"), "c1")

    #> # toml (6 lines, 1 selected element)
    #>   2 |   a = 1
    #>   3 |   b = [10, 20, 30]
    #>   4 |   [c]
    #> > 5 |   c1 = true
    #>   6 |   c2 = []

#### By position: integer vector

Selects child nodes by position. Positive indices count from the start,
negative indices count from the end. Zero indices are not allowed.

 

    toml <- tstoml::ts_parse_toml('
      a = 1
      b = [10, 20, 30]
      [c]
      c1 = true
      c2 = []
    ')
    toml |> ts_tree_select(c("b", "c"), -1)

    #> # toml (6 lines, 2 selected elements)
    #>   1 | 
    #>   2 |   a = 1
    #> > 3 |   b = [10, 20, 30]
    #>   4 |   [c]
    #>   5 |   c1 = true
    #> > 6 |   c2 = []

#### Matching keys: regular expression

A character scalar named `regex` can be used to select child nodes whose
names match the given regular expression, from nodes with named
children. If a node has no named children, it selects nothing from that
node.

 

    toml <- tstoml::ts_parse_toml(
     'apple = 1\nalmond = 2\nbanana = 3\ncherry = 4\n'
    )
    toml |> ts_tree_select(regex = "^a")

    #> # toml (4 lines, 2 selected elements)
    #> > 1 | apple = 1
    #> > 2 | almond = 2
    #>   3 | banana = 3
    #>   4 | cherry = 4

#### Tree sitter query matches

A character scalar named `query` can be used to select nodes matching a
tree-sitter query. See
[`ts_tree_query()`](https://rdrr.io/pkg/ts/man/ts_tree_query.html) for
details on tree-sitter queries.

Instead of a character scalar this can also be a two-element list, where
the first element is the query string and the second element is a
character vector of capture names to select. In this case only nodes
matching the given capture names will be selected.

See
[`tstoml::ts_language_toml()`](https://gaborcsardi.github.io/tstoml/reference/ts_language_toml.md)
for details on the TOML grammar.

This example selects all integers in the TOML document.

 

    toml <- tstoml::ts_parse_toml(
      'a = 1\nb = [10, 20, 30]\nc = { c1 = true, c2 = 100 }\n'
    )
    toml |> ts_tree_select(query = "(integer) @integer")

    #> # toml (3 lines, 5 selected elements)
    #> > 1 | a = 1
    #> > 2 | b = [10, 20, 30]
    #> > 3 | c = { c1 = true, c2 = 100 }

#### Explicit node ids

You can use `I(c(...))` to select nodes by their ids directly. This is
for advanced use cases only.

 

    toml <- tstoml::ts_parse_toml(
      'a = 1\nb = [10, 20, 30]\nc = { c1 = true, c2 = [] }\n'
    )
    ts_tree_dom(toml)

    #> document (1)
    #> ├─value (5) # a
    #> ├─array (9) # b
    #> │ ├─value (11)
    #> │ ├─value (13)
    #> │ └─value (15)
    #> └─inline_table (20) # c
    #>   ├─value (25) # c1
    #>   └─array (30) # c2

 

    toml |> ts_tree_select(I(9))

    #> # toml (3 lines, 1 selected element)
    #>   1 | a = 1
    #> > 2 | b = [10, 20, 30]
    #>   3 | c = { c1 = true, c2 = [] }

### Refining selections

If the `refine` argument of
[`ts_tree_select()`](https://rdrr.io/pkg/ts/man/ts_tree_select.html) is
`TRUE`, then the selection starts from the already selected elements
(all of them simultanously), instead of starting from the document
element.

 

    toml <- tstoml::ts_parse_toml(
      '[table]\na = 1\nb = [10, 20, 30]\nc = { c1 = true, c2 = [] }\n'
    )
    toml <- toml |> ts_tree_select("table", "b")

 

    # selects the first two elements in the document node, ie. "table"
    toml |> ts_tree_select(1:2)

    #> # toml (4 lines, 1 selected element)
    #> > 1 | [table]
    #> > 2 | a = 1
    #> > 3 | b = [10, 20, 30]
    #> > 4 | c = { c1 = true, c2 = [] }

 

    # selects the first two elements inside "table" and "b"
    toml |> ts_tree_select(1:2, refine = TRUE)

    #> # toml (4 lines, 2 selected elements)
    #>   1 | [table]
    #>   2 | a = 1
    #> > 3 | b = [10, 20, 30]
    #>   4 | c = { c1 = true, c2 = [] }

### The `ts_tree_select<-()` replacement function

The [`ts_tree_select<-()`](https://rdrr.io/pkg/ts/man/select-set.html)
replacement function works similarly to the combination of
[`ts_tree_select()`](https://rdrr.io/pkg/ts/man/ts_tree_select.html) and
[`ts_tree_update()`](https://rdrr.io/pkg/ts/man/ts_tree_update.html),
but it might be more readable.

 

    toml <- tstoml::ts_parse_toml(
      '[table]\na = 1\nb = [10, 20, 30]\nc = { c1 = true, c2 = [] }\n'
    )
    toml

    #> # toml (4 lines)
    #> 1 | [table]
    #> 2 | a = 1
    #> 3 | b = [10, 20, 30]
    #> 4 | c = { c1 = true, c2 = [] }

 

    toml |> ts_tree_select("table", "b", 1)

    #> # toml (4 lines, 1 selected element)
    #>   1 | [table]
    #>   2 | a = 1
    #> > 3 | b = [10, 20, 30]
    #>   4 | c = { c1 = true, c2 = [] }

 

    ts_tree_select(toml, "table", "b", 1) <- 100
    toml

    #> # toml (4 lines)
    #> 1 | [table]
    #> 2 | a = 1
    #> 3 | b = [100.0, 20, 30]
    #> 4 | c = { c1 = true, c2 = [] }

### The `[[` and `[[<-` operators

The `[[` operator works similarly to the combination of
[`ts_tree_select()`](https://rdrr.io/pkg/ts/man/ts_tree_select.html) and
[`ts_tree_unserialize()`](https://rdrr.io/pkg/ts/man/ts_tree_unserialize.html),
but it might be more readable.

 

    toml <- tstoml::ts_parse_toml(
      '[table]\na = 1\nb = [10, 20, 30]\nc = { c1 = true, c2 = [] }\n'
    )
    toml |> ts_tree_select("table", "b", 1)

    #> # toml (4 lines, 1 selected element)
    #>   1 | [table]
    #>   2 | a = 1
    #> > 3 | b = [10, 20, 30]
    #>   4 | c = { c1 = true, c2 = [] }

 

    toml[[list("table", "b", 1)]]

    #> [[1]]
    #> [1] 10
    #>

The `[[<-` operator works similarly to the combination of
[`ts_tree_select()`](https://rdrr.io/pkg/ts/man/ts_tree_select.html) and
[`ts_tree_update()`](https://rdrr.io/pkg/ts/man/ts_tree_update.html),
(and also to the replacement function
[`ts_tree_select<-()`](https://rdrr.io/pkg/ts/man/select-set.html)), but
it might be more readable.

 

    toml <- tstoml::ts_parse_toml(
      '[table]\na = 1\nb = [10, 20, 30]\nc = { c1 = true, c2 = [] }\n'
    )
    toml

    #> # toml (4 lines)
    #> 1 | [table]
    #> 2 | a = 1
    #> 3 | b = [10, 20, 30]
    #> 4 | c = { c1 = true, c2 = [] }

 

    toml |> ts_tree_select("table", "b", 1)

    #> # toml (4 lines, 1 selected element)
    #>   1 | [table]
    #>   2 | a = 1
    #> > 3 | b = [10, 20, 30]
    #>   4 | c = { c1 = true, c2 = [] }

 

    toml[[list("table", "b", 1)]] <- 100
    toml

    #> # toml (4 lines)
    #> 1 | [table]
    #> 2 | a = 1
    #> 3 | b = [100.0, 20, 30]
    #> 4 | c = { c1 = true, c2 = [] }

### Examples

 

    txt <- r"(
    # This is a TOML documenttitle = "TOML Example"[owner]
    name = "Tom Preston-Werner"
    dob = 1979-05-27T07:32:00-08:00[database]
    enabled = true
    ports = [ 8000, 8001, 8002 ]
    data = [ ["delta", "phi"], [3.14] ]
    temp_targets = { cpu = 79.5, case = 72.0 }[servers][servers.alpha]
    ip = "10.0.0.1"
    role = "frontend"[servers.beta]
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

Select elements in a tstoml object

 

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
