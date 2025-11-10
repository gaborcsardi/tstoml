#' Show the syntax tree structure of a TOML file or string
#'
#' @inheritParams token_table
#'
#' @export
#' @examples
#' sexpr_toml(
#'   text = "[owner]\nname = \"Tom Preston-Werner\"\nemail = \"tom@github.com\""
#' )

sexpr_toml <- function(
  file = NULL,
  text = NULL,
  ranges = NULL
) {
  if (is.null(text) + is.null(file) != 1) {
    stop(cnd(
      "Invalid arguments in `sexpr_toml()`: exactly one of `file` \\
       and `text` must be given."
    ))
  }
  if (is.null(text)) {
    text <- readBin(file, "raw", n = file.size(file))
  }
  if (is.character(text)) {
    text <- charToRaw(paste(text, collapse = "\n"))
  }
  call_with_cleanup(c_s_expr, text, 0L, ranges)
}

#' Get the token table of a TOML file or string
#'
#' @param file Path of a TOML file. Use either `file` or `text`.
#' @param text TOML string. Use either `file` or `text`.
#' @param ranges Can be used to parse part(s) of the input. It must be a
#'   data frame with integer columns `start_row`, `start_col`, `end_row`,
#'   `end_col`, `start_byte`, `end_byte`, in this order.
#' @param options List of options, see [tstoml_options()]. This argument
#'   must be named and cannot be abbreviated.
#' @param fail_on_parse_error Logical, whether to error if there are
#'   parse errors in the toml document. Default is `TRUE`.
#'
#' @return A data frame with one row per token, and columns:
#' * `id`: integer, the id of the token.
#' * `parent`: integer, the id of the parent token. The root token has
#'   parent `NA`
#' * `field_name`: character, the field name of the token in its parent.
#' * `type`: character, the type of the token.
#' * `code`: character, the actual code of the token.
#' * `start_byte`, `end_byte`: integer, the byte positions of the token
#'   in the input.
#' * `start_row`, `start_column`, `end_row`, `end_column`: integer, the
#'   position of the token in the input.
#' * `is_missing`: logical, whether the token is a missing token added by
#'   the parser to recover from errors.
#' * `has_error`: logical, whether the token has a parse error.
#' * `children`: list of integer vectors, the ids of the children tokens.
#'
#' @export
#' @examples
#' token_table(text = toml_example_text())

token_table <- function(
  file = NULL,
  text = NULL,
  ranges = NULL,
  fail_on_parse_error = TRUE,
  options = NULL
) {
  # if (!missing(options)) {
  #   check_named_arg(options)
  # }
  # options <- as_tstoml_options(options)
  if (is.null(text) + is.null(file) != 1) {
    stop(cnd(
      "Invalid arguments in `token_table()`: exactly one of `file` \\
       and `text` must be given."
    ))
  }
  if (is.null(text)) {
    text <- readBin(file, "raw", n = file.size(file))
  }
  if (is.character(text)) {
    text <- charToRaw(paste(text, collapse = "\n"))
  }
  tab <- call_with_cleanup(c_token_table, text, 0L, ranges)
  lvls <- seq_len(nrow(tab))
  tab$children <- I(unname(split(lvls, factor(tab$parent, levels = lvls))))
  attr(tab, "file") <- file

  tab <- add_dom(tab)

  # # this is a workaround for TS adding code to a non-terminal array/object node
  # tab$code[tab$type %in% c("array", "object")] <- NA_character_

  # if (fail_on_parse_error && (tab$has_error[1] || any(tab$is_missing))) {
  #   stop(tstoml_parse_error_cnd(table = tab, text = text))
  # }

  # # TODO make this a proper error, mark the position of the comment(s)
  # if (!options[["allow_comments"]]) {
  #   comments <- which(tab$type == "comment")
  #   if (length(comments) > 0) {
  #     stop(cnd(
  #       "The toml document contains comments, and this is not allowed. \\
  #        To allow comments, set the `allow_comments` option to `TRUE`."
  #     ))
  #   }
  # }

  # top <- tab$children[[1]]
  # top <- top[tab$type[top] != "comment"]
  # if (!options[["allow_empty_content"]] && length(top) == 0) {
  #   stop(cnd(
  #     "The toml document is empty, and this is not allowed. \\
  #      To allow this, set the `allow_empty_content` option to `TRUE`."
  #   ))
  # }

  # # TODO make this a proper error, mark the position of the trailing comma(s)
  # if (!options[["allow_trailing_comma"]]) {
  #   commas <- which(tab$type == ",")
  #   trailing <- map_lgl(commas, function(c) {
  #     siblings <- tab$children[[tab$parent[c]]]
  #     c == siblings[length(siblings) - 1L]
  #   })
  #   if (any(trailing)) {
  #     stop(cnd(
  #       "The toml document contains trailing commas, and this is not allowed. \\
  #        To allow trailing commas, set the `allow_trailing_comma` option to \\
  #        `TRUE`."
  #     ))
  #   }
  # }

  tab
}

#' Print the document tree of a TOML file or string
#'
#' @inheritParams token_table
#' @export

dom_toml <- function(
  file = NULL,
  text = NULL,
  ranges = NULL,
  fail_on_parse_error = TRUE,
  options = NULL
) {
  tokens <- token_table(
    file,
    ranges = ranges,
    text = text,
    fail_on_parse_error = fail_on_parse_error,
    options = options
  )

  is_dom_node <- c(1L, which(!is.na(tokens$dom_parent)))
  dom <- tokens[is_dom_node, ]

  lengths <- new.env(parent = emptyenv())
  label <- map_chr(seq_len(nrow(dom)), function(i) {
    type <- dom$type[i]
    if (type == "document") {
      "<document>"
    } else if (
      type %in%
        c("bare_key", "quoted_key", "dotted_key") &&
        tokens$type[dom$parent[i]] == "table_array_element"
    ) {
      ec <- encode_key(unserialize_key(tokens, dom$id[i]))
      # remove current subarrays, we'll need to create new ones for the
      # new array element
      nms <- names(lengths)
      subs <- nms[startsWith(nms, paste0(ec, "."))]
      for (sub in subs) {
        rm(list = nms[startsWith(nms, sub)], envir = lengths)
      }
      l <- lengths[[ec]] <- (lengths[[ec]] %||% 0L) + 1L
      paste0("[", l, "]")
    } else if (type == "table") {
      last(unserialize_key(tokens, dom$children[[i]][2L]))
    } else if (type == "pair") {
      last(unserialize_key(tokens, dom$children[[i]][1L]))
    } else if (type == "table_array_element") {
      paste0(last(unserialize_key(tokens, dom$children[[i]][2L])), "[]")
    } else if (type %in% c("bare_key", "quoted_key")) {
      dom$code[i]
    } else {
      paste0("<", dom$type[i], ">")
    }
  })

  treetab <- data_frame(
    id = as.character(dom$id),
    children = lapply(dom$dom_children, as.character),
    label = label
  )

  tree <- cli::tree(treetab)

  tree
}

# ------------------------------------------------------------------------------

encode_key <- function(key) {
  paste0(".", paste0(nchar(key, type = "bytes"), ":", key, collapse = "."))
}

add_dom <- function(tab) {
  tab$dom_parent <- rep(NA_integer_, nrow(tab))
  dict <- new.env(parent = emptyenv())
  current_table <- 1L
  current_prefix <- character()

  check_sub_keys <- function(key, prefix = NULL) {
    ec <- if (is.null(prefix)) "" else encode_key(prefix)
    for (idx in seq_along(key$key[-1])) {
      ec <- paste0(ec, encode_key(key$key[idx]))
      rec <- dict[[ec]]
      if (is.null(rec)) {
        dict[[ec]] <- rec <- list(id = key$ids[[idx]], type = "subtable")
        tab$dom_parent[key$ids[[idx]]] <<- current_table
      } else if (rec$type == "pair") {
        stop(cnd(
          "Cannot define subtable under pair: \\
          {paste(c(prefix, key$key[1:idx]), collapse = '.')}."
        ))
      }
      current_table <<- rec$id
      current_prefix <<- key$key[1:idx]
    }
  }

  add_dom_pair <- function(id) {
    current_table_save <- current_table
    current_prefix_save <- current_prefix
    # make sure subtables exist
    key <- unserialize_key_with_ids(tab, tab$children[[id]][1])
    check_sub_keys(key, prefix = current_prefix_save)

    # check for duplicate keys
    ec <- encode_key(c(current_prefix_save, key$key))
    rec <- dict[[ec]]
    if (!is.null(rec)) {
      stop(cnd(
        "Duplicate key definition: {paste(key$key, collapse = '.')}."
      ))
    } else {
      dict[[ec]] <- list(id = id, type = "pair")
    }

    # add pair to current table
    tab$dom_parent[id] <<- current_table
    tab$dom_parent[tab$children[[id]][3]] <<- id
    current_table <<- current_table_save
    current_prefix <<- current_prefix_save
  }

  add_dom_table <- function(id) {
    # make sure subtables exist, create if not
    current_table <<- 1L
    current_prefix <<- character()
    key <- unserialize_key_with_ids(tab, tab$children[[id]][2])
    check_sub_keys(key)

    # set my parent
    tab$dom_parent[i] <<- current_table

    # create new table of upgrade a subtable to a table
    ec <- encode_key(key$key)
    rec <- dict[[ec]]
    if (is.null(rec) || rec$type == "subtable") {
      dict[[ec]] <- list(id = id, type = "table")
    } else if (rec$type == "table") {
      stop(cnd(
        "Duplicate table definition: {paste(key$key, collapse = '.')}."
      ))
    } else {
      stop(cnd(
        "Cannot redefine array of tables as table: \\
        {paste(key$key, collapse = '.')}."
      ))
    }
    # this is the current table now
    current_table <<- id
    current_prefix <<- key$key
  }

  add_dom_table_array_element <- function(id) {
    # make sure subtables exist, create if not
    current_table <<- 1L
    current_prefix <<- character()
    key <- unserialize_key_with_ids(tab, tab$children[[id]][2])
    check_sub_keys(key)

    # create new array of tables if it does not exist
    element_id <- tab$children[[id]][2]
    ec <- encode_key(key$key)
    rec <- dict[[ec]]
    if (is.null(rec)) {
      dict[[ec]] <- rec <- list(id = element_id, type = "array_of_tables")
      tab$dom_parent[id] <<- current_table
      tab$dom_parent[element_id] <<- id
    } else if (rec$type == "array_of_tables") {
      nms <- ls(dict, all.names = TRUE)
      subs <- nms[startsWith(nms, paste0(ec, "."))]
      rm(list = subs, envir = dict)
      tab$dom_parent[element_id] <<- tab$dom_parent[rec$id]
      rec$id <- element_id
      dict[[ec]] <- rec
    } else {
      stop(cnd(
        "Cannot redefine table as array of tables: \\
        {paste(key$key, collapse = '.')}."
      ))
    }

    current_table <<- element_id
    current_prefix <<- key$key
  }

  tables <- c(1L, which(tab$type %in% c("table", "table_array_element")))
  tabchld <- unlist(tab$children[tables])
  pairs <- tabchld[tab$type[tabchld] == "pair"]
  todo <- sort(c(tables, pairs))

  for (i in todo) {
    switch(
      tab$type[i],
      pair = {
        add_dom_pair(i)
      },
      table = {
        add_dom_table(i)
      },
      table_array_element = {
        add_dom_table_array_element(i)
      }
    )
  }

  check_inline_table <- function(id) {
    # We can use a local dictionary for each inline table
    dict <- new.env(parent = emptyenv())
    children <- tab$children[[id]]
    pairs <- children[tab$type[children] == "pair"]

    check_keys <- function(key) {
      ec <- ""
      for (idx in seq_along(key$key[-1])) {
        ec <- paste0(ec, encode_key(key$key[idx]))
        rec <- dict[[ec]]
        if (is.null(rec)) {
          dict[[ec]] <- rec <- list(id = key$ids[[idx]], type = "subtable")
          tab$dom_parent[key$ids[[idx]]] <<- parent
        } else if (rec$type == "pair") {
          stop(cnd(
            "Cannot define subtable under pair in inline table: \\
            {paste(key$key[1:idx], collapse = '.')}."
          ))
        }
        parent <<- rec$id
      }
    }

    for (p in pairs) {
      parent <- id
      key <- unserialize_key_with_ids(tab, tab$children[[p]][1])
      check_keys(key)
      ec <- encode_key(key$key)
      rec <- dict[[ec]]
      if (!is.null(rec)) {
        stop(cnd(
          "Duplicate key definition in inline table: \\
          {paste(key$key, collapse = '.')}."
        ))
      } else {
        rec <- dict[[ec]] <- list(id = p, type = "pair")
      }
      tab$dom_parent[p] <<- parent
      tab$dom_parent[tab$children[[p]][3]] <<- p
    }
  }

  for (i in which(tab$type == "inline_table")) {
    check_inline_table(i)
  }

  lvls <- seq_len(nrow(tab))
  tab$dom_children <- I(unname(split(
    lvls,
    factor(tab$dom_parent, levels = lvls)
  )))
  tab
}

# ------------------------------------------------------------------------------

#' Show the annotated syntax tree of a TOML file or string
#' @inheritParams token_table
#' @export
#' @examples
#' syntax_tree_toml(text = toml_example_text())

syntax_tree_toml <- function(
  file = NULL,
  text = NULL,
  ranges = NULL,
  fail_on_parse_error = TRUE,
  options = NULL
) {
  # if (!missing(options)) {
  #   check_named_arg(options)
  # }
  # options <- as_tstoml_options(options)
  tokens <- token_table(
    file,
    ranges = ranges,
    text = text,
    fail_on_parse_error = fail_on_parse_error,
    options = options
  )

  type <- tokens$type
  fn <- attr(tokens, "file")
  if (cli::ansi_has_hyperlink_support() && !is.null(fn)) {
    type <- cli::style_hyperlink(
      type,
      sprintf(
        "file://%s:%d:%d",
        normalizePath(fn, mustWork = NA),
        tokens$start_row + 1L,
        tokens$start_column + 1
      )
    )
  }

  linum <- tokens$start_row + 1
  linum <- ifelse(duplicated(linum), "", as.character(linum))
  linum <- format(linum, justify = "right")
  # this is the spacer we need to put in for multi-line tokens
  nlspc <- paste0("\n\t", strrep(" ", nchar(linum[1])), "|")
  code <- ifelse(
    is.na(tokens$code),
    "",
    paste0(strrep(" ", tokens$start_column), tokens$code)
  )

  # we put in a \t, and later use it to align the lines vertically
  treetab <- data_frame(
    id = as.character(tokens$id),
    children = lapply(tokens$children, as.character),
    label = paste0(
      type,
      " (",
      tokens$id,
      ")",
      "\t",
      linum,
      "|",
      gsub("\n", nlspc, code, fixed = TRUE)
    )
  )
  tree <- cli::tree(treetab)

  # align lines vertically. the size of the alignment is measured
  # without the ANSI sequences, but then the substitution uses the
  # full ANSI string
  tabpos <- regexpr("\t", cli::ansi_strip(tree), fixed = TRUE)
  maxtab <- max(tabpos)
  tabpos2 <- regexpr("\t", tree, fixed = TRUE)
  regmatches(tree, tabpos2) <- strrep(" ", maxtab - tabpos + 4)

  tree
}

#' Run tree-sitter queries on a TOML file or string
#'
#' See https://tree-sitter.github.io/tree-sitter/ on writing tree-sitter
#' queries.
#'
#' @param query Character string, the tree-sitter query to run.
#' @inheritParams token_table
#' @return A list with entries `patterns` and `matched_captures`.
#'   `patterns` contains information about all patterns in the queries and
#'   it is a data frame with columns: `id`, `name`, `pattern`, `match_count`.
#'   `matched_captures` contains information about all matches, and it has
#'   columns `id`, `pattern`, `match`, `start_byte`, `end_byte`, `start_row`,
#'   `start_column`, `end_row`, `end_column`, `name`, `code`. The `pattern`
#'   column of `matched_captured` refers to the `id` column of `patterns`.
#'
#' @export

query_toml <- function(
  file = NULL,
  text = NULL,
  query,
  ranges = NULL
) {
  if (is.null(text) + is.null(file) != 1) {
    stop(cnd(
      "Invalid arguments in `query_toml()`: exactly one of `file` \\
       and `text` must be given."
    ))
  }

  qlen <- nchar(query, type = "bytes") + 1L # + \n
  qbeg <- c(1L, cumsum(qlen))
  qnms <- names(query) %||% rep(NA_character_, length(query))
  query1 <- paste0(query, "\n", collapse = "")

  if (!is.null(text)) {
    if (is.character(text)) {
      text <- charToRaw(paste(text, collapse = "\n"))
    }
    res <- call_with_cleanup(c_code_query, text, query1, 0L, ranges)
  } else {
    res <- call_with_cleanup(c_code_query_path, file, query1, 0L, ranges)
  }

  qorig <- as.integer(cut(res[[1]][[3]], breaks = qbeg, include.lowest = TRUE))

  list(
    patterns = data_frame(
      id = seq_along(res[[1]][[1]]),
      name = qnms[qorig],
      pattern = res[[1]][[1]],
      match_count = res[[1]][[2]]
    ),
    captures = data_frame(
      id = seq_along(res[[2]]),
      name = res[[2]]
    ),
    matched_captures = data_frame(
      id = map_int(res[[3]], "[[", 3L),
      pattern = map_int(res[[3]], "[[", 1L),
      match = map_int(res[[3]], "[[", 2L),
      type = map_chr(res[[3]], "[[", 12L),
      start_byte = map_int(res[[3]], "[[", 6L),
      end_byte = map_int(res[[3]], "[[", 7L),
      start_row = map_int(res[[3]], "[[", 8L),
      start_column = map_int(res[[3]], "[[", 9L),
      end_row = map_int(res[[3]], "[[", 10L),
      end_column = map_int(res[[3]], "[[", 11L),
      name = map_chr(res[[3]], "[[", 4L),
      code = map_chr(res[[3]], "[[", 5L)
    )
  )
}
