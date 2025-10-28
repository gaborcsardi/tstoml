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

  tab <- token_table(
    file = file,
    text = text,
    ranges = ranges,
    options = options
  )
  unserialize_element(tab, 1L)
}

unserialize_element <- function(token_table, id) {
  switch(
    token_table$type[id],
    document = {
      unserialize_document(token_table, id)
    },
    pair = {
      unserialize_pair(token_table, id)
    },
    integer = {
      unserialize_integer(token_table, id)
    },
    float = {
      unserialize_float(token_table, id)
    },
    boolean = {
      unserialize_boolean(token_table, id)
    },
    offset_date_time = {
      unserialize_offset_date_time(token_table, id)
    },
    local_date_time = {
      unserialize_local_date_time(token_table, id)
    },
    local_date = {
      unserialize_local_date(token_table, id)
    },
    local_time = {
      unserialize_local_time(token_table, id)
    },
    string = {
      unserialize_string(token_table, id)
    },
    array = {
      unserialize_array(token_table, id)
    },
    inline_table = {
      unserialize_inline_table(token_table, id)
    },
    table = {
      unserialize_table(token_table, id)
    },
    table_array_element = {
      unserialize_table_array_element(token_table, id)
    },
    stop("Unsupported token type: ", token_table$type[id])
  )
}

new_table <- function(name) {
  list(
    values = structure(list(), names = character()),
    name = name
  )
}

set_table_element <- function(table, elt, inline = FALSE) {
  for (i in seq_along(elt$name[-1])) {
    idx <- elt$name[1:i]
    if (is.null(table$values[[idx]])) {
      table$values[[idx]] <- list()
    }
  }
  if (is.null(table$values[[elt$name]])) {
    table$values[[elt$name]] <- elt$value
  }
  table
}

new_array <- function(name) {
  list(
    values = list(),
    name = name
  )
}

set_array_element <- function(array, elt) {
  array$values[[length(array$values) + 1L]] <- elt$value
  array
}

# the document is a table without a name
unserialize_document <- function(token_table, id) {
  stopifnot(token_table$type[id] == "document")
  children <- token_table$children[[id]]
  children <- children[token_table$type[children] != "comment"]
  result <- new_table(NA_character_)
  for (child in children) {
    elem <- unserialize_element(token_table, child)
    result <- set_table_element(result, elem)
  }
  as.list(result$values)
}

unserialize_pair <- function(token_table, id) {
  stopifnot(token_table$type[id] == "pair")
  children <- token_table$children[[id]]
  # first must be a key, second =, third the value
  key <- unserialize_key(token_table, children[1])
  value <- unserialize_element(token_table, children[3])
  list(
    name = key,
    value = value
  )
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
  unserialize_string(token_table, id, type = "quoted_key")
}

unserialize_dotted_key <- function(token_table, id) {
  stopifnot(token_table$type[id] == "dotted_key")
  children <- token_table$children[[id]]
  c(
    unserialize_key(token_table, children[1]),
    unserialize_key(token_table, children[3])
  )
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
  switch(
    token_table$type[chdn[1]],
    '"' = {
      unserialize_basic_string(token_table, id, type)
    },
    '"""' = {
      unserialize_multiline_basic_string(token_table, id)
    },
    "'" = {
      unserialize_literal_string(token_table, id, type)
    },
    "'''" = {
      unserialize_multiline_literal_string(token_table, id)
    },
    stop("Unsupported string delimiter: ", token_table$type[chdn[1]])
  )
}

# - Embedded zero is not supported in R, so \u0000 will error.
# - All other escapes supported by TOML are also supported by R, hence
#   we use `eval(parse())`.
# - The parser will error for the escapes that are not supported by TOML,
#   even if they are supported by R.

unserialize_basic_string <- function(token_table, id, type = "string") {
  stopifnot(token_table$type[id] == type)
  # also has " delimiters
  str <- token_table$code[id]
  eval(parse(text = str, keep.source = FALSE))
}

unserialize_multiline_basic_string <- function(token_table, id) {
  stopifnot(token_table$type[id] == "string")
  str <- token_table$code[id]
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

unserialize_literal_string <- function(token_table, id, type = "string") {
  stopifnot(token_table$type[id] == type)
  str <- token_table$code[id]
  # trim delimiters first
  str <- substr(str, 2L, nchar(str) - 1L)
  str
}

unserialize_multiline_literal_string <- function(token_table, id) {
  stopifnot(token_table$type[id] == "string")
  str <- token_table$code[id]
  # trim delimiters first
  str <- substr(str, 4L, nchar(str) - 3L)
  # remove leading newline if present
  if (startsWith(str, "\n")) {
    str <- substr(str, 2L, nchar(str))
  }
  str
}

unserialize_array <- function(token_table, id) {
  stopifnot(token_table$type[id] == "array")
  children <- token_table$children[[id]]
  # filter out commas
  children <- children[
    !token_table$type[children] %in% c("[", ",", "]", "comment")
  ]
  result <- vector("list", length(children))
  for (i in seq_along(children)) {
    result[[i]] <- unserialize_element(token_table, children[i])
  }
  result
}

unserialize_inline_table <- function(token_table, id) {
  stopifnot(token_table$type[id] == "inline_table")
  children <- token_table$children[[id]]
  children <- children[
    !token_table$type[children] %in% c("{", ",", "}", "comment")
  ]
  result <- new_table(NA_character_)
  for (child in children) {
    elem <- unserialize_element(token_table, child)
    result <- set_table_element(result, elem)
  }
  as.list(result$values)
}

unserialize_table <- function(token_table, id) {
  stopifnot(token_table$type[id] == "table")
  children <- token_table$children[[id]]
  name <- unserialize_key(token_table, children[2])
  children <- children[
    !token_table$type[children] %in% c("[", "]", "comment")
  ][-1]
  result <- new_table(name)
  for (i in children) {
    elem <- unserialize_element(token_table, i)
    result <- set_table_element(result, elem)
  }
  result
}

unserialize_table_array_element <- function(token_table, id) {
  stopifnot(token_table$type[id] == "table_array_element")
  children <- token_table$children[[id]]
  name <- unserialize_key(token_table, children[2])
  children <- children[
    !token_table$type[children] %in% c("[[", "]]", "comment")
  ][-1]
  result <- new_array(name)
  for (child in children) {
    elem <- unserialize_element(token_table, child)
    result <- set_array_element(result, elem)
  }
  result
}
