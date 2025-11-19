insert_into_selected <- function(toml, new, key = NULL, at = Inf) {
  select <- get_selected_nodes(toml)

  if (length(select) == 0) {
    return(toml)
  }

  insertions <- lapply(select, function(sel1) {
    dom_type <- toml$dom_type[sel1]
    switch(
      dom_type,
      document = {
        insert_into_document(toml, sel1, new, key = key)
      },
      subtable = {
        insert_into_subtable(toml, sel1, new, key = key)
      },
      inline_table = {
        insert_into_inline_table(toml, sel1, new, key = key, at = at)
      },
      table = {
        insert_into_table(toml, sel1, new, key = key, at = at)
      },
      array_of_tables = {
        insert_into_aot(toml, sel1, new, key = key, at = at)
      },
      table_array_element = {
        insert_into_aot_element(toml, sel1, new, key = key, at = at)
      },
      array = {
        insert_into_array(toml, sel1, new, key = key, at = at)
      },
      stop(cnd("Cannot insert into a `{dom_type}` TOML element."))
    )
  })

  insertions <- insertions[order(map_int(insertions, "[[", "after"))]

  for (ins in insertions) {
    if (!isFALSE(ins$leading_comma)) {
      aft <- last_descendant(toml, ins$leading_comma)
      toml$tws[aft] <- paste0(",", toml$tws[aft])
    }

    aft <- last_descendant(toml, ins$after)
    firstchld <- toml$children[[ins$select]][1]
    # mark first child for reformatting the whole array
    before_tws <- isTRUE(ins$before_trailing_ws)
    toml$tws[firstchld] <- paste0(reformat_mark, toml$tws[firstchld])
    toml$tws[aft] <- paste0(
      if (!before_tws) toml$tws[aft],
      ins$code,
      if (ins$trailing_comma) ",",
      if (before_tws) toml$tws[aft],
      if (ins$trailing_newline) "\n"
    )
  }

  parts <- c(rbind(toml$code, toml$tws))
  text <- unlist(lapply(na_omit(parts), charToRaw))

  # TODO: update coordinates without reparsing
  new <- load_toml(text = text)
  attr(new, "file") <- attr(toml, "file")

  new
}

last_descendant <- function(toml, node) {
  while (node != 1 && is.na(toml$code[node])) {
    node <- utils::tail(toml$children[[node]], 1)
  }
  node
}

# reformat_mark <- "\f"
reformat_mark <- ""

# ------------------------------------------------------------------------------

insert_into_document <- function(toml, sel1, new, key = NULL) {
  newtype <- get_stl_type(new)
  newtypename <- stl_type_names[[newtype]]
  if (is.null(key)) {
    stop(cnd(
      "The `key` argument is required when inserting a {newtypename} \\
       into the document."
    ))
  }
  if (length(key) != 1) {
    stop(cnd("The `key` argument must be a single string for now."))
  }
  chdn <- toml$dom_children[[1]]
  keys <- toml$dom_name[chdn]
  if (key %in% keys) {
    stop(cnd("Key `{key}` already exists in the document."))
  }

  switch(
    newtype,
    "pair" = {
      insert_into_document_pair(toml, sel1, new, key = key)
    },
    "table" = {
      insert_into_document_table(toml, sel1, new, key = key)
    },
    "array_of_tables" = {
      insert_into_document_aot(toml, sel1, new, key = key)
    },
    stop(cnd(
      "Cannot insert {newtypename} ({newtype)} into document. \\
       This is an internal error in tstoml"
    ))
  )
}

insert_into_document_pair <- function(toml, sel1, new, key) {
  # need to put it before the first table or AOT
  chdn <- toml$dom_children[[1]]
  wtable <- which(toml$type[chdn] %in% c("table", "table_array_element"))[1]
  # if no table or AOT, append to the end
  after <- if (is.na(wtable)) nrow(toml) else wtable - 1L
  code <- paste0(
    if (nrow(toml) > 1) {
      "\n"
    },
    key,
    " = ",
    paste0(serialize_toml_value(new), collapse = "\n")
  )

  list(
    select = sel1,
    after = after,
    code = code,
    leading_comma = FALSE,
    trailing_comma = FALSE,
    trailing_newline = TRUE
  )
}

insert_into_document_table <- function(toml, sel1, new, key) {
  code <- paste0(
    if (nrow(toml) > 1) {
      "\n"
    },
    paste0(serialize_toml(structure(list(new), names = key)), collapse = "\n")
  )
  list(
    select = sel1,
    after = nrow(toml),
    code = code,
    leading_comma = FALSE,
    trailing_comma = FALSE,
    trailing_newline = TRUE
  )
}

insert_into_document_aot <- function(toml, sel1, new, key) {
  code <- paste0(
    if (nrow(toml) > 1) {
      "\n"
    },
    paste0(serialize_toml(structure(list(new), names = key)), collapse = "\n")
  )
  list(
    select = sel1,
    after = nrow(toml),
    code = code,
    leading_comma = FALSE,
    trailing_comma = FALSE,
    trailing_newline = TRUE
  )
}

# ------------------------------------------------------------------------------

insert_into_subtable <- function(toml, sel1, new, key = key) {
  TODO
}

insert_into_inline_table <- function(toml, sel1, new, key = key, at = at) {
  chdn <- toml$children[[sel1]]
  isxtr <- toml$type[chdn] != "pair"
  idx <- seq_along(chdn)[!isxtr]
  nchdn <- length(idx)

  if (is.character(at)) {
    rchdn <- chdn[toml$type[chdn] == "pair"]
    keys <- map_chr(rchdn, function(id) {
      gchdn <- toml$children[[id]]
      gchdn <- gchdn[!is.na(toml$field_name[gchdn])]
      keyid <- gchdn[toml$field_name[gchdn] == "key"]
      unserialize_string(toml, keyid)
    })
    at <- match(at, keys)
    if (is.na(at)) {
      at <- Inf
    }
  }

  after_comma <- after <- if (at < 1 || nchdn == 0) {
    1
  } else if (at >= nchdn) {
    idx[nchdn]
  } else {
    idx[at]
  }

  if (
    toml$type[chdn[after + 1L]] == "," &&
      toml$type[chdn[after + 2L]] == "comment" &&
      toml$end_row[chdn[after + 1L]] == toml$start_row[chdn[after + 2L]]
  ) {
    # skip comma + comment on the same line!
    after <- after + 2L
  } else if (
    toml$type[chdn[after + 1L]] == "comment" &&
      toml$end_row[chdn[after]] == toml$start_row[chdn[after + 1L]]
  ) {
    # skip comment on the same line
    after <- after + 1L
  } else if (toml$type[chdn[after + 1L]] == ",") {
    # skip comma w/o comment on the same line
    # keep non-line comment as non-line comment
    after <- after + 1L
  } else {
    # skip comments and potentially a comma
    while (toml$type[chdn[after + 1L]] == "comment") {
      after <- after + 1L
    }
    if (toml$type[chdn[after + 1L]] == ",") {
      after <- after + 1L
    }
  }

  code <- paste0(key, "=", serialize_toml_value(new))

  add_leading_comma <- at >= nchdn && nchdn > 0
  add_trailing_comma <- (at < nchdn && nchdn > 0)

  list(
    select = sel1,
    after = chdn[after],
    code = paste0(code, collapse = "\n"),
    # need a leading comma if inserting at the end into non-empty array
    leading_comma = if (add_leading_comma) chdn[after_comma] else FALSE,
    # need a trailing comma everywhere except at the end or in an empty array
    trailing_comma = add_trailing_comma,
    trailing_newline = toml$type[chdn[after + 1L]] == "comment"
  )
}

# ------------------------------------------------------------------------------

insert_into_table <- function(toml, sel1, new, key = key, at = at) {
  newtype <- get_stl_type(new)
  newtypename <- stl_type_names[[newtype]]
  if (is.null(key)) {
    stop(cnd(
      "The `key` argument is required when inserting a {newtypename} \\
       into the document."
    ))
  }
  if (length(key) != 1) {
    stop(cnd("The `key` argument must be a single string for now."))
  }
  chdn <- toml$dom_children[[sel1]]
  keys <- toml$dom_name[chdn]
  if (key %in% keys) {
    stop(cnd("Key `{key}` already exists in the document."))
  }

  switch(
    newtype,
    "pair" = {
      insert_into_table_pair(toml, sel1, new, key = key)
    },
    "table" = {
      insert_into_table_table(toml, sel1, new, key = key)
    },
    "array_of_tables" = {
      insert_into_table_aot(toml, sel1, new, key = key)
    },
    stop(cnd(
      "Cannot insert {newtypename} ({newtype)} into document. \\
       This is an internal error in tstoml"
    ))
  )
}

insert_into_table_pair <- function(toml, sel1, new, key) {
  after <- last_descendant(toml, sel1)
  code <- paste0(
    "\n",
    key,
    " = ",
    paste0(serialize_toml_value(new), collapse = "\n")
  )
  list(
    select = sel1,
    after = after,
    code = code,
    leading_comma = FALSE,
    trailing_comma = FALSE,
    # there must be a trailing newline after the table already
    trailing_newline = FALSE,
    before_trailing_ws = TRUE
  )
}

insert_into_table_table <- function(toml, sel1, new, key) {
  after <- last_descendant(toml, sel1)
  keyid <- toml$children[[sel1]][2]
  newkey <- ts_toml_key(c(unserialize_key(toml, keyid), key))
  code <- paste0(
    "\n\n",
    paste0(
      serialize_toml(structure(list(new), names = newkey)),
      collapse = "\n"
    )
  )
  list(
    select = sel1,
    after = after,
    code = code,
    leading_comma = FALSE,
    trailing_comma = FALSE,
    trailing_newline = FALSE,
    before_trailing_ws = TRUE
  )
}

insert_into_table_aot <- function(toml, sel1, new, key) {
  after <- last_descendant(toml, sel1)
  keyid <- toml$children[[sel1]][2]
  newkey <- ts_toml_key(c(unserialize_key(toml, keyid), key))
  code <- paste0(
    "\n\n",
    paste0(
      serialize_toml(structure(list(new), names = newkey)),
      collapse = "\n"
    )
  )
  list(
    select = sel1,
    after = after,
    code = code,
    leading_comma = FALSE,
    trailing_comma = FALSE,
    trailing_newline = FALSE,
    before_trailing_ws = TRUE
  )
}

# ------------------------------------------------------------------------------

insert_into_aot <- function(toml, sel1, new, key = key, at = at) {
  TODO
}

# ------------------------------------------------------------------------------

insert_into_aot_element <- function(toml, sel1, new, key = key, at = at) {
  TODO
}

# ------------------------------------------------------------------------------

insert_into_array <- function(toml, sel1, new, key = key, at = at) {
  # this is complicated by comments inside the array
  # we need to build an index to map non-comment children to actual children
  # we might as well treat the [ ] and comma nodes the same way
  chdn <- toml$children[[sel1]]
  isxtr <- toml$type[chdn] %in% c("comment", "[", "]", ",")
  idx <- seq_along(chdn)[!isxtr]
  nchdn <- length(idx)

  after_comma <- after <- if (at < 1 || nchdn == 0) {
    1
  } else if (at >= nchdn) {
    idx[nchdn]
  } else {
    idx[at]
  }

  if (
    toml$type[chdn[after + 1L]] == "," &&
      toml$type[chdn[after + 2L]] == "comment" &&
      toml$end_row[chdn[after + 1L]] == toml$start_row[chdn[after + 2L]]
  ) {
    # skip comma + comment on the same line!
    after <- after + 2L
  } else if (
    toml$type[chdn[after + 1L]] == "comment" &&
      toml$end_row[chdn[after]] == toml$start_row[chdn[after + 1L]]
  ) {
    # skip comment on the same line
    after <- after + 1L
  } else if (toml$type[chdn[after + 1L]] == ",") {
    # skip comma w/o comment on the same line
    # keep non-line comment as non-line comment
    after <- after + 1L
  } else {
    # skip comments and potentially a comma
    while (toml$type[chdn[after + 1L]] == "comment") {
      after <- after + 1L
    }
    if (toml$type[chdn[after + 1L]] == ",") {
      after <- after + 1L
    }
  }

  # handle appending when there is a trailig comma
  chdnx <- chdn[toml$type[chdn] != "comment"]
  has_trailing_comma <- toml$type[rev(chdnx)][2] == ","
  add_leading_comma <- !has_trailing_comma && at >= nchdn && nchdn > 0
  add_trailing_comma <- (at < nchdn && nchdn > 0) ||
    (at >= nchdn && has_trailing_comma)

  list(
    select = sel1,
    after = chdn[after],
    code = serialize_toml_value(new),
    # need a leading comma if inserting at the end into non-empty array
    leading_comma = if (add_leading_comma) chdn[after_comma] else FALSE,
    # need a trailing comma everywhere except at the end or in an empty array
    trailing_comma = add_trailing_comma,
    # if the next is a comment, it must be on a new line, keep it there
    trailing_newline = toml$type[chdn[after + 1L]] == "comment"
  )
}
