
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tstoml

<!-- badges: start -->

![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)
[![R-CMD-check](https://github.com/gaborcsardi/tstoml/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/gaborcsardi/tstoml/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/gaborcsardi/tstoml/graph/badge.svg)](https://app.codecov.io/gh/gaborcsardi/tstoml)
<!-- badges: end -->

Extract and manipulate parts of TOML files without touching the
formatting and comments in other parts.

## Installation

You can install the development version of tstoml from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("gaborcsardi/tstoml")
```

## Documentation

See at
[`https://gaborcsardi.github.io/tstoml/`](https://gaborcsardi.github.io/tstoml/reference/index.html/)
and also in the installed package: `help(package = "tstoml")`.

## Quickstart

### Create a tstoml object

Create a tstoml object from a string:

``` r
txt <- r"(
# This is a TOML document

title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00

[database]
enabled = true
ports = [ 8000, 8001, 8002 ]
data = [ ["delta", "phi"], [3.14] ]
temp_targets = { cpu = 79.5, case = 72.0 }

[servers]

[servers.alpha]
ip = "10.0.0.1"
role = "frontend"

[servers.beta]
ip = "10.0.0.2"
role = "backend"
)"
toml <- ts_parse_toml(text = txt)
```

Pretty print a tstoml object:

``` r
toml
```

<picture>
<source media="(prefers-color-scheme: dark)" srcset="man/figures/print-toml-dark.svg">
<img src="man/figures/print-toml.svg" /> </picture>

### Select elements in a tstoml object

``` r
ts_tree_select(toml, "owner")
```

<picture>
<source media="(prefers-color-scheme: dark)" srcset="man/figures/select-table-dark.svg">
<img src="man/figures/select-table.svg" /> </picture>

Select element(s) inside elements:

``` r
ts_tree_select(toml, "owner", "name")
```

<picture>
<source media="(prefers-color-scheme: dark)" srcset="man/figures/select-select-dark.svg">
<img src="man/figures/select-select.svg" /> </picture>

Select element(s) of an array:

``` r
ts_tree_select(toml, "database", "ports", 1:2)
```

<picture>
<source media="(prefers-color-scheme: dark)" srcset="man/figures/select-array-dark.svg">
<img src="man/figures/select-array.svg" /> </picture>

Select multiple keys from a table:

``` r
ts_tree_select(toml, "owner", c("name", "dob"))
```

<picture>
<source media="(prefers-color-scheme: dark)" srcset="man/figures/select-multiple-dark.svg">
<img src="man/figures/select-multiple.svg" /> </picture>

### Delete elements

TODO

### Insert elements

TODO

### Update elements

TODO

# License

MIT © Posit Software, PBC
