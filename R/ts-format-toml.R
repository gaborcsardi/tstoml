format_toml <- function(
  file = NULL,
  text = NULL,
  options = NULL
) {
  # if (!missing(options)) {
  #   check_named_arg(options)
  # }
  # options <- as_tstoml_options(options)

  # parse file/text
  # TODO: error on error, get error position
  toml <- token_table(file = file, text = text, options = options)
  format_element(toml, 1L, options = options)
}

#' Format the selected TOML elements
#'
#' @details
#' If `toml` does not have a selection, then all of it is formatted.
#' If `toml` has an empty selection, then nothing happens.
#'
#' @inheritParams token_table
#' @param toml tstoml object.
#' @return The updated tstoml object.
#'
#' @export

format_selected <- function(
  toml,
  options = NULL
) {
  if (!missing(options)) {
    check_named_arg(options)
  }
  # options <- as_tstoml_options(options)
  select <- get_selected_nodes(toml)
  fmt <- lapply(
    select,
    format_element,
    toml = toml,
    options = options
  )
  for (i in seq_along(select)) {
    sel1 <- select[i]
    prevline <- rev(which(toml$end_row == toml$start_row[sel1] - 1))[1]
    ind0 <- sub("^.*\n", "", toml$tws[prevline])
    if (!is.na(prevline)) {
      fmt[[i]] <- paste0(c("", rep(ind0, length(fmt[[i]]) - 1L)), fmt[[i]])
    }
  }

  subtrees <- lapply(select, get_subtree, toml = toml, with_root = FALSE)
  deleted <- unique(unlist(subtrees))

  # need to keep the trailing ws of the last element
  lasts <- map_int(subtrees, max_or_na)
  tws <- toml$tws[lasts]
  toml$code[deleted] <- NA_character_
  toml$tws[deleted] <- NA_character_
  toml$code[select] <- paste0(
    map_chr(fmt, paste, collapse = "\n"),
    ifelse(is.na(tws), "", tws)
  )
  toml$tws[select] <- NA_character_

  parts <- c(rbind(toml$code, toml$tws))
  text <- unlist(lapply(na_omit(parts), charToRaw))

  # TODO: update coordinates without reparsing
  new <- ts_parse_toml(text = text)
  attr(new, "file") <- attr(toml, "file")

  new
}

get_subtree <- function(tree, id, with_root = FALSE) {
  sel <- c(if (with_root) id, tree$children[[id]])
  while (TRUE) {
    sel2 <- unique(c(sel, unlist(tree$children[sel])))
    if (length(sel2) == length(sel)) {
      return(sel)
    }
    sel <- sel2
  }
}

format_element <- function(toml, id, options) {
  type <- toml$type[id]
  switch(
    type,
    table = {
      format_table(toml, id, options)
    },
    document = {
      format_document(toml, id, options)
    },
    table_array_element = {
      format_table_array_element(toml, id, options)
    },
    inline_table = {
      format_inline_table(toml, id, options)
    },
    array = {
      format_array(toml, id, options)
    },
    pair = {
      format_pair(toml, id, options)
    },
    integer = {
      format_integer(toml, id, options)
    },
    float = {
      format_float(toml, id, options)
    },
    boolean = {
      format_boolean(toml, id, options)
    },
    offset_date_time = {
      format_offset_date_time(toml, id, options)
    },
    local_date_time = {
      format_local_date_time(toml, id, options)
    },
    local_date = {
      format_local_date(toml, id, options)
    },
    local_time = {
      format_local_time(toml, id, options)
    },
    string = {
      format_string(toml, id, options)
    },
    comment = {
      format_comment(toml, id, options)
    },
    stop(ts_cnd("Internal tstoml error, unknown TOML node type: {type}."))
  )
}

format_table <- function(toml, id, options) {
  hdr_chld <- get_subtree(toml, toml$children[[id]][2L], with_root = TRUE)
  hdr <- paste(na_omit(toml$code[hdr_chld]), collapse = "")
  chld <- toml$children[[id]][-(1:3)]
  c(
    "",
    paste0("[", hdr, "]"),
    unlist(lapply(chld, format_element, toml = toml, options = options))
  )
}

format_document <- function(toml, id, options) {
  chld <- toml$children[[id]]
  lns <- unlist(lapply(chld, format_element, toml = toml, options = options))
  if (length(lns) > 0 && lns[1] == "") {
    lns <- lns[-1]
  }
  lns
}

format_table_array_element <- function(toml, id, options) {
  hdr_chld <- get_subtree(toml, toml$children[[id]][2L], with_root = TRUE)
  hdr <- paste(na_omit(toml$code[hdr_chld]), collapse = "")
  chld <- toml$children[[id]][-(1:3)]
  c(
    "",
    paste0("[[", hdr, "]]"),
    unlist(lapply(chld, format_element, toml = toml, options = options))
  )
}

format_inline_table <- function(toml, id, options) {
  chld <- toml$children[[id]]
  chld <- chld[!toml$type[chld] %in% c("{", "}", ",")]
  paste0(
    "{ ",
    paste(
      map_chr(chld, format_pair, toml = toml, options = options),
      collapse = ", "
    ),
    " }"
  )
}

format_array <- function(toml, id, options) {
  chld <- toml$children[[id]]
  chld <- chld[!toml$type[chld] %in% c("[", "]", ",")]
  paste0(
    "[ ",
    paste(
      map_chr(chld, format_element, toml = toml, options = options),
      collapse = ", "
    ),
    " ]"
  )
}

format_pair <- function(toml, id, options) {
  key_chld <- get_subtree(toml, toml$children[[id]][1L], with_root = TRUE)
  key <- paste(na_omit(toml$code[key_chld]), collapse = "")
  paste0(
    key,
    " = ",
    format_element(toml, toml$children[[id]][3L], options = options)
  )
}

format_integer <- function(toml, id, options) {
  toml$code[id]
}

format_float <- function(toml, id, options) {
  toml$code[id]
}

format_boolean <- function(toml, id, options) {
  toml$code[id]
}

format_offset_date_time <- function(toml, id, options) {
  toml$code[id]
}

format_local_date_time <- function(toml, id, options) {
  toml$code[id]
}

format_local_date <- function(toml, id, options) {
  toml$code[id]
}

format_local_time <- function(toml, id, options) {
  toml$code[id]
}

format_string <- function(toml, id, options) {
  chld <- get_subtree(toml, id, with_root = TRUE)
  paste(na_omit(toml$code[chld]), collapse = "")
}

format_comment <- function(toml, id, options) {
  toml$code[id]
}
