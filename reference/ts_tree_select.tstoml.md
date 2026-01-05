# Select parts of a TOML tree-sitter tree

This function is the heart of ts. To edit a tree-sitter tree, you first
need to select the parts you want to delete or update.

This is the S3 method of the
[`ts::ts_tree_select()`](https://gaborcsardi.github.io/ts/reference/ts_tree_select.html)
generic, for
[tstoml](https://gaborcsardi.github.io/tstoml/reference/tstoml-package.md)
objects.

## Usage

``` r
# S3 method for class 'tstoml'
ts_tree_select(tree, ..., refine = FALSE)
```

## Arguments

- tree:

  A `ts_tree` object as returned by
  [`ts_tree_new()`](https://gaborcsardi.github.io/ts/reference/ts_tree_new.html).

- ...:

  Selection expressions, see details.

- refine:

  Logical, whether to refine the current selection or start a new
  selection.

## Value

A `ts_tree` object with the selected parts.

## Details

A selection starts from the root of the DOM tree, the document node (see
[`ts_tree_dom()`](https://gaborcsardi.github.io/ts/reference/ts_tree_dom.html)),
unless `refine = TRUE` is set, in which case it starts from the current
selection.

A list of selection expressions is applied in order. Each selection
expression selects nodes from the currently selected nodes.

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

NULL

#### By position: integer vector

Selects child nodes by position. Positive indices count from the start,
negative indices count from the end. Zero indices are not allowed.

NULL

#### Matching keys: regular expression

A character scalar named `regex` can be used to select child nodes whose
names match the given regular expression, from nodes with named
children. If a node has no named children, it selects nothing from that
node.

NULL

#### Tree sitter query matches

A character scalar named `query` can be used to select nodes matching a
tree-sitter query. See
[`ts_tree_query()`](https://gaborcsardi.github.io/ts/reference/ts_tree_query.html)
for details on tree-sitter queries.

Instead of a character scalar this can also be a two-element list, where
the first element is the query string and the second element is a
character vector of capture names to select. In this case only nodes
matching the given capture names will be selected.

NULL

#### Explicit node ids

You can use `I(c(...))` to select nodes by their ids directly. This is
for advanced use cases only.

NULL

### Refining selections

If the `refine` argument of
[`ts_tree_select()`](https://gaborcsardi.github.io/ts/reference/ts_tree_select.html)
is `TRUE`, then the selection starts from the already selected elements
(all of them simultanously), instead of starting from the document
element.

### The `[[` and `[[<-` operators

The `[[` operator works similarly to
[`ts_tree_select()`](https://gaborcsardi.github.io/ts/reference/ts_tree_select.html)
on ts_tree objects, but it might be more readable.

The `[[<-` operator works similarly to
[`ts::ts_tree_select<-()`](https://gaborcsardi.github.io/ts/reference/select-set.html),
but it might be more readable.

### Examples

TODO
