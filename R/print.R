#' @export

print.tstoml <- function(x, n = 10, ...) {
  writeLines(format(x, n = n, ...))
  invisible(x)
}

#' @export

format.tstoml <- function(x, n = 10, ...) {
  sel <- get_selected_nodes(x, default = FALSE)
  if (length(sel) > 0) {
    # TODO: format_tstoml_selection(x, n = n, ...)
    format_tstoml_noselection(x, n = n, ...)
  } else {
    format_tstoml_noselection(x, n = n, ...)
  }
}

format_tstoml_noselection <- function(x, n = 10, ...) {
  lns <- strsplit(rawToChar(attr(x, "text")), "\r?\n")[[1]]
  nc <- length(lns)
  sc <- min(nc, n)
  lns <- utils::head(lns, sc)
  num <- cli::col_grey(format(seq_len(sc)))

  sel <- get_selection(x, default = FALSE)

  grey <- cli::col_grey

  sfn <- if (!is.null(attr(x, "file"))) paste0(basename(attr(x, "file")), ", ")

  c(
    if (is.null(sel)) {
      grey(glue("# toml ({sfn}{nc} line{plural(nc)})"))
    } else {
      grey(glue("# toml ({sfn}{nc} line{plural(nc)}, 0 selected elements)"))
    },
    paste0(num, if (sc) cli::col_grey(" | "), lns),
    if (nc > sc) {
      c(
        grey(glue("{cli::symbol$info} {nc-sc} more line{plural(nc-sc)}")),
        grey(glue("{cli::symbol$info} Use `print(n = ...)` to see more lines"))
      )
    }
  )
}

plural <- function(x) {
  if (x != 1) {
    "s"
  } else {
    ""
  }
}
