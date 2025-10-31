`%||%` <- function(l, r) {
  if (is.null(l)) {
    r
  } else {
    l
  }
}

named_list <- function() {
  structure(list(), names = character())
}

map_int <- function(.x, .f, ...) {
  vapply(.x, .f, integer(1), ...)
}

map_chr <- function(.x, .f, ...) {
  vapply(.x, .f, character(1), ...)
}

map_lgl <- function(.x, .f, ...) {
  vapply(.x, .f, logical(1), ...)
}

na_omit <- function(x) {
  x[!is.na(x)]
}

middle <- function(x) {
  if (length(x) <= 2) {
    x[numeric()]
  } else {
    x[-c(1, length(x))]
  }
}

max_or_na <- function(x) {
  if (length(x)) {
    max(x)
  } else if (is.integer(x)) {
    NA_integer_
  } else {
    NA_real_
  }
}

mkdirp <- function(x) {
  dir.create(x, showWarnings = FALSE, recursive = TRUE)
}

is_named <- function(x) {
  nms <- names(x)
  length(x) == length(nms) && !anyNA(nms) && all(nms != "")
}

# For roxygen2 -----------------------------------------------------------------

# nocov start
doclist <- function(x) {
  paste0("`", x, "`", collapse = ", ")
}
#nocov end
