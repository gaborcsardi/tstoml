#' @export

load_toml <- function(
  file = NULL,
  text = NULL,
  ranges = NULL,
  options = NULL
) {
  # if (!missing(options)) {
  #   check_named_arg(options)
  # }
  # options <- as_tstoml_options(options)
  # if (is.null(text) + is.null(file) != 1) {
  #   stop(cnd(
  #     "Invalid arguments in `load_toml()`: exactly one of `file` \\
  #      and `text` must be given."
  #   ))
  # }
  if (is.null(text)) {
    text <- readBin(file, "raw", n = file.size(file))
  }
  if (is.character(text)) {
    text <- charToRaw(paste(text, collapse = "\n"))
  }
  # TODO: error on error, get error position
  tt <- token_table(text = text, ranges = ranges, options = options)

  # trailing whitespace for each token
  # first we add the leading whitespace to the document token
  # this way printing $code and $tws will print the whole document
  tt$tws <- rep("", nrow(tt))
  if ((lead <- tt$start_byte[1]) > 0) {
    tt$tws[1] <- rawToChar(text[1:lead])
  }

  # then the whitespace of the terminal nodes
  term <- which(!is.na(tt$code))
  from <- tt$end_byte[term] + 1L
  to <- c(tt$start_byte[term][-1], tt$end_byte[1])
  for (i in seq_along(term)) {
    if (from[i] <= to[i]) {
      tt$tws[term[i]] <- rawToChar(text[from[i]:to[i]])
    }
  }

  attr(tt, "text") <- text
  attr(tt, "file") <- if (!is.null(file)) normalizePath(file)
  class(tt) <- c("tstoml", class(tt))
  tt
}

#' @export

`[.tstoml` <- function(x, i, j, drop = FALSE) {
  class(x) <- setdiff(class(x), "tstoml")
  requireNamespace("pillar", quietly = TRUE)
  NextMethod("[")
}
