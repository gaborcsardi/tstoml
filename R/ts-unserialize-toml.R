#' Unserialize TOML to R objects
#'
#' @inheritParams token_table
#' @export

unserialize_toml <- function(
  file = NULL,
  text = NULL,
  ranges = NULL,
  options = NULL
) {
  # if (!missing(options)) {
  #   check_named_arg(options)
  # }
  # options <- as_tstoml_options(options)

  tab <- ts_tree_new(
    language = ts_language_toml(),
    file = file,
    text = text,
    ranges = ranges,
    options = options
  )
  unserialize_element(tab, 1L)
}

unserialize_element <- function(tree, id) {
  type <- tree$type[id]
  parent <- tree$parent[id]
  if (
    !is.na(parent) &&
      tree$type[parent] == "table_array_element" &&
      type %in% c("bare_key", "quoted_key", "dotted_key")
  ) {
    # this is an AOT _element_, unserialize like a table
    type <- "table"
  }

  elt <- switch(
    type,
    table = ,
    document = ,
    inline_table = ,
    bare_key = ,
    quoted_key = {
      unserialize_table(tree, id)
    },
    array = ,
    table_array_element = {
      unserialize_array(tree, id)
    },
    pair = {
      unserialize_pair(tree, id)
    },
    integer = {
      unserialize_integer(tree, id)
    },
    float = {
      unserialize_float(tree, id)
    },
    boolean = {
      unserialize_boolean(tree, id)
    },
    offset_date_time = {
      unserialize_offset_date_time(tree, id)
    },
    local_date_time = {
      unserialize_local_date_time(tree, id)
    },
    local_date = {
      unserialize_local_date(tree, id)
    },
    local_time = {
      unserialize_local_time(tree, id)
    },
    string = {
      unserialize_string(tree, id)
    },
    basic_string = {
      unserialize_basic_string(tree, id)
    },
    multiline_basic_string = {
      unserialize_multiline_basic_string(tree, id)
    },
    literal_string = {
      unserialize_literal_string(tree, id)
    },
    multiline_literal_string = {
      unserialize_multiline_literal_string(tree, id)
    },
    stop("Unsupported token type: ", tree$type[id])
  )
  elt
}

unserialize_pair <- function(token_table, id) {
  stopifnot(token_table$type[id] == "pair")
  unserialize_element(token_table, token_table$dom_children[[id]])
}

unserialize_key <- function(token_table, id) {
  switch(
    token_table$type[id],
    bare_key = {
      unserialize_bare_key(token_table, id)
    },
    quoted_key = {
      unserialize_quoted_key(token_table, id)
    },
    dotted_key = {
      unserialize_dotted_key(token_table, id)
    },
    stop("Unsupported key type in pair: ", token_table$type[id])
  )
}

unserialize_bare_key <- function(token_table, id) {
  stopifnot(token_table$type[id] == "bare_key")
  token_table$code[id]
}

unserialize_quoted_key <- function(token_table, id) {
  stopifnot(token_table$type[id] == "quoted_key")
  unserialize_element(token_table, token_table$children[[id]][1])
}

unserialize_dotted_key <- function(token_table, id) {
  stopifnot(token_table$type[id] == "dotted_key")
  children <- token_table$children[[id]]
  c(
    unserialize_key(token_table, children[1]),
    unserialize_key(token_table, children[3])
  )
}

unserialize_key_with_ids <- function(token_table, id) {
  switch(
    token_table$type[id],
    bare_key = {
      unserialize_bare_key_with_ids(token_table, id)
    },
    quoted_key = {
      unserialize_quoted_key_with_ids(token_table, id)
    },
    dotted_key = {
      unserialize_dotted_key_with_ids(token_table, id)
    },
    stop("Unsupported key type in pair: ", token_table$type[id])
  )
}

unserialize_bare_key_with_ids <- function(token_table, id) {
  stopifnot(token_table$type[id] == "bare_key")
  list(key = token_table$code[id], ids = id)
}

unserialize_quoted_key_with_ids <- function(token_table, id) {
  stopifnot(token_table$type[id] == "quoted_key")
  list(
    key = unserialize_element(token_table, token_table$children[[id]][1]),
    ids = id
  )
}

unserialize_dotted_key_with_ids <- function(token_table, id) {
  stopifnot(token_table$type[id] == "dotted_key")
  children <- token_table$children[[id]]
  ki1 <- unserialize_key_with_ids(token_table, children[1])
  ki2 <- unserialize_key_with_ids(token_table, children[3])
  list(key = c(ki1$key, ki2$key), ids = c(ki1$ids, ki2$ids))
}


# TODO: support 64 bit integers
unserialize_integer <- function(token_table, id) {
  stopifnot(token_table$type[id] == "integer")
  code <- token_table$code[id]
  base <- if (startsWith(code, "0x")) {
    16L
  } else if (startsWith(code, "0o")) {
    code <- substr(code, 3L, nchar(code))
    8L
  } else if (startsWith(code, "0b")) {
    code <- substr(code, 3L, nchar(code))
    2L
  } else {
    10L
  }
  code <- gsub("_", "", code, fixed = TRUE)
  strtoi(code, base = base)
}

unserialize_float <- function(token_table, id) {
  stopifnot(token_table$type[id] == "float")
  code <- token_table$code[id]
  code <- gsub("_", "", code, fixed = TRUE)
  as.numeric(code)
}

unserialize_boolean <- function(token_table, id) {
  stopifnot(token_table$type[id] == "boolean")
  if (token_table$code[id] == "true") {
    TRUE
  } else {
    FALSE
  }
}

unserialize_offset_date_time <- function(token_table, id) {
  stopifnot(token_table$type[id] == "offset_date_time")
  code <- token_table$code[id]
  parse_iso_8601(code)
}

unserialize_local_date_time <- function(token_table, id) {
  stopifnot(token_table$type[id] == "local_date_time")
  code <- token_table$code[id]
  # parse it as a local time
  t <- parse_iso_8601(code, "")
  as.POSIXlt(.POSIXct(t, tz = ""))
}

unserialize_local_date <- function(token_table, id) {
  stopifnot(token_table$type[id] == "local_date")
  code <- token_table$code[id]
  as.Date(code, tryFormats = "%Y-%m-%d")
}

unserialize_local_time <- function(token_table, id) {
  stopifnot(token_table$type[id] == "local_time")
  code <- token_table$code[id]
  hms <- strsplit(code, ":", fixed = TRUE)[[1]]
  structure(
    as.difftime(
      strtoi(hms[1]) * 3600 + strtoi(hms[2]) * 60 + as.numeric(hms[3]),
      units = "secs"
    ),
    class = c("hms", "difftime")
  )
}

# TODO: embedded NULL not supported

unserialize_string <- function(token_table, id, type = "string") {
  stopifnot(token_table$type[id] == type)
  chdn <- token_table$children[[id]]
  unserialize_element(token_table, chdn[1])
}

# - Embedded zero is not supported in R, so \u0000 will error.
# - All other escapes supported by TOML are also supported by R, hence
#   we use `eval(parse())`.
# - The parser will error for the escapes that are not supported by TOML,
#   even if they are supported by R.

unserialize_basic_string <- function(token_table, id) {
  stopifnot(token_table$type[id] == "basic_string")
  # also has " delimiters
  chdn <- token_table$children[[id]]
  str <- paste(token_table$code[chdn], collapse = "")
  eval(parse(text = str, keep.source = FALSE))
}

unserialize_multiline_basic_string <- function(token_table, id) {
  stopifnot(token_table$type[id] == "multiline_basic_string")
  chdn <- token_table$children[[id]]
  str <- paste(token_table$code[chdn], collapse = "")
  # trim delimiters first
  str <- substr(str, 4L, nchar(str) - 3L)
  # remove leading newline if present
  if (startsWith(str, "\n")) {
    str <- substr(str, 2L, nchar(str))
  }
  # replace \ + \n + whitespace with nothing
  str <- gsub("\\\\\n\\s*", "", str, perl = TRUE)
  # if we escape the single quotes, then we can use R's parser
  str <- gsub("'", "\\'", str, fixed = TRUE)
  eval(parse(text = paste0("'", str, "'"), keep.source = FALSE))
}

unserialize_literal_string <- function(token_table, id) {
  stopifnot(token_table$type[id] == "literal_string")
  chdn <- token_table$children[[id]]
  str <- paste(token_table$code[chdn], collapse = "")
  # trim delimiters first
  str <- substr(str, 2L, nchar(str) - 1L)
  str
}

unserialize_multiline_literal_string <- function(token_table, id) {
  stopifnot(token_table$type[id] == "multiline_literal_string")
  chdn <- token_table$children[[id]]
  str <- paste(token_table$code[chdn], collapse = "")
  # trim delimiters first
  str <- substr(str, 4L, nchar(str) - 3L)
  # remove leading newline if present
  if (startsWith(str, "\n")) {
    str <- substr(str, 2L, nchar(str))
  }
  str
}

unserialize_array <- function(token_table, id) {
  children <- token_table$dom_children[[id]]
  result <- vector("list", length(children))
  for (i in seq_along(children)) {
    result[[i]] <- unserialize_element(token_table, children[i])
  }
  result
}

unserialize_table <- function(token_table, id) {
  children <- token_table$dom_children[[id]]
  res <- named_list(length(children))
  names(res) <- token_table$dom_name[children]
  for (i in seq_along(children)) {
    res[[i]] <- unserialize_element(token_table, children[i])
  }
  res
}
