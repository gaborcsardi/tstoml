# Delete selected elements from a tstoml object

The formatting of the rest of TOML document is kept as is. Comments
appearing inside the deleted elements are also deleted. Other comments
are left as is.

## Usage

``` r
# S3 method for class 'ts_tree_toml'
ts_tree_delete(tree, ...)
```

## Arguments

- tree:

  tstoml object.

- ...:

  Reserved for future use.

## Value

Modified tstoml object.

## Details

If `toml` has no selection then the the whole document is deleted. If
`toml` has an empty selection, then nothing is delted.

## Examples

``` r
library(ts)
toml <- ts_parse_toml(text = toml_example_text())
toml
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
#> ℹ 13 more lines
#> ℹ Use `print(n = ...)` to see more lines

toml |> ts_tree_select("owner", "name") |> ts_tree_delete()
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
toml |> ts_tree_select("owner") |> ts_tree_delete()
#> # toml (19 lines)
#>  1 | # This is a TOML document
#>  2 | 
#>  3 | title = "TOML Example"
#>  4 | 
#>  5 | [database]
#>  6 | enabled = true
#>  7 | ports = [ 8000, 8001, 8002 ]
#>  8 | data = [ ["delta", "phi"], [3.14] ]
#>  9 | temp_targets = { cpu = 79.5, case = 72.0 }
#> 10 | 
#> ℹ 9 more lines
#> ℹ Use `print(n = ...)` to see more lines
```
