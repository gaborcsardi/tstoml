#' Parse a TOML file or string into a tstoml object
#'
#' @inheritParams token_table
#' @return A tstoml object.
#'
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

  # add positions for arrays of tables, so we can use selections based
  # on their positions.
  # TODO: we could do this in chk_document() already?
  dict <- new.env(parent = emptyenv())
  array_position <- rev_array_position <- integer(nrow(tt))
  aots <- which(tt$type == "table_array_element")
  for (aot in aots) {
    # need to convert dotted keys to string keys
    key <- unserialize_key(tt, tt$children[[aot]][2L])
    key <- paste0(seq_along(key), ":", key, collapse = ".")
    array_position[aot] <- (dict[[key]] %||% 0L) + 1L
    assign(key, array_position[aot], envir = dict)
  }
  tt$array_position <- array_position
  dict <- new.env(parent = emptyenv())
  for (aot in rev(aots)) {
    key <- unserialize_key(tt, tt$children[[aot]][2L])
    key <- paste0(seq_along(key), ":", key, collapse = ".")
    rev_array_position[aot] <- (dict[[key]] %||% 0L) - 1L
    assign(key, rev_array_position[aot], envir = dict)
  }
  tt$rev_array_position <- rev_array_position

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
