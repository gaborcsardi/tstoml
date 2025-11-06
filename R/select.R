# A section is a list of records. Each record has a selector
# and a list of selected nodes.
#
# 1. there is an explicit selection
# 2. otherwise the top element is selected (or elements if many)
# 3. otherwise the document node is selected

get_selection <- function(toml, default = TRUE) {
  sel <- attr(toml, "selection")
  if (!is.null(sel)) {
    sel
  } else if (default) {
    get_default_selection(toml)
  } else {
    NULL
  }
}

get_selected_nodes <- function(toml, default = TRUE) {
  sel <- get_selection(toml, default = default)
  if (is.null(sel)) {
    return(integer())
  } else {
    sel[[length(sel)]]$nodes
  }
}

get_default_selection <- function(toml) {
  list(
    list(
      selector = sel_default(),
      nodes = 1L
    )
  )
}

sel_default <- function() {
  structure(
    list(),
    class = c("tstoml_selector_default", "tstoml_selector", "list")
  )
}

#' Select elements in a tstoml object
#'
#' @param x,toml tstoml object.
#' @param i,... Selectors, see below.
#'
#' @export

select <- function(toml, ...) {
  slts <- list(...)
  if (length(slts) == 1 && is.null(slts[[1]])) {
    attr(toml, "selection") <- NULL
    toml
  } else {
    select_(toml, current = NULL, slts)
  }
}

#' @rdname select
#' @export

`[[.tstoml` <- function(x, i, ...) {
  if (missing(i)) {
    i <- list()
  }
  unserialize_selected(select(x, i, ...))
}

sel_ids <- function(ids) {
  structure(
    list(ids = ids),
    class = c("tstoml_selector_ids", "tstoml_selector", "list")
  )
}

#' Select the nodes matching a tree-sitter query in a tstoml object
#'
#' @param toml tstoml object.
#' @param query String, a tree-sitter query.
#' @param captures Optional character vector, the names of the captures to
#'   select. By default all captured nodes are selected.
#'
#' @export

select_query <- function(toml, query, captures = NULL) {
  text <- attr(toml, "text")
  mch <- query_toml(text = text, query = query)

  if (!is.null(captures)) {
    bad <- !captures %in% mch$captures$name
    if (any(bad)) {
      stop(cnd(paste0(
        "Invalid capture names in `select_query()`: ",
        paste(captures[bad], collapse = ", ")
      )))
    }
    mc <- mch$matched_captures[
      mch$matched_captures$name %in% captures,
    ]
  } else {
    mc <- mch$matched_captures
  }

  ids <- if (nrow(mc) == 0) {
    integer()
  } else {
    toml0 <- toml[
      toml$start_byte %in% mc$start_byte & toml$end_byte %in% mc$end_byte,
    ]
    mkeys <- paste0(mc$type, ":", mc$start_byte, ":", mc$end_byte)
    jkeys <- paste0(toml0$type, ":", toml0$start_byte, ":", toml0$end_byte)
    toml0$id[match(mkeys, jkeys)]
  }
  ids <- minimize_selection(toml, ids)
  toml |> select(sel_ids(ids))
}

# remove nodes that are in the subtree of other selected nodes
# start from the last nodes and go up

minimize_selection <- function(toml, ids) {
  ids <- sort(unique(ids))
  sel <- logical(nrow(toml))
  sel[ids] <- TRUE
  for (id in rev(ids)) {
    parent <- toml$parent[id]
    while (!is.na(parent)) {
      if (sel[parent]) {
        sel[id] <- FALSE
        break
      }
      parent <- toml$parent[parent]
    }
  }
  which(sel)
}

#' @rdname select
#' @export

select_refine <- function(toml, ...) {
  current <- get_selection(toml)
  select_(toml, current = current, list(...))
}

select_ <- function(toml, current, slts) {
  slts <- unlist(
    lapply(slts, function(x) {
      if (inherits(x, "tstoml_selector") || !is.list(x)) list(x) else x
    }),
    recursive = FALSE
  )
  current <- current %||% get_default_selection(toml)
  cnodes <- current[[length(current)]]$nodes

  for (slt in slts) {
    nxt <- integer()
    for (cur in cnodes) {
      nxt <- unique(c(nxt, select1(toml, cur, slt)))
    }
    current[[length(current) + 1L]] <- list(
      selector = slt,
      nodes = sort(nxt)
    )
    cnodes <- current[[length(current)]]$nodes
  }
  attr(toml, "selection") <- current
  toml
}

select1 <- function(toml, idx, slt) {
  if (inherits(slt, "tstoml_selector_ids")) {
    slt$ids
  } else if (identical(slt, TRUE)) {
    select1_true(toml, idx)
  } else if (is.character(slt)) {
    select1_key(toml, idx, slt)
  } else if (is.numeric(slt)) {
    select1_numeric(toml, idx, slt)
  } else {
    stop("Invalid TOML selector")
  }
}

# select all child elements
select1_true <- function(toml, idx) {
  type <- toml$type[idx]
  # This is AOT _element_, so we need to take its parent AOT and treat is
  # like a table
  if (
    !is.na(toml$parent[idx]) &&
      toml$type[toml$parent[idx]] == "table_array_element" &&
      toml$type[idx] %in% c("bare_key", "quoted_key", "dotted_key")
  ) {
    idx <- toml$parent[idx]
    type <- "table"
  }
  if (type %in% c("document", "table")) {
    children <- toml$children[[idx]]
    unlist(lapply(children, function(child) {
      ctype <- toml$type[child]
      if (ctype == "table" || ctype == "table_array_element") {
        keyid <- toml$children[[child]][2]
        if (toml$type[keyid] == "dotted_key") {
          get_dotted_key_component(toml, keyid, 1L)
        } else {
          child
        }
      } else if (ctype == "pair") {
        keyid <- toml$children[[child]][1]
        if (toml$type[keyid] == "dotted_key") {
          get_dotted_key_component(toml, keyid, 1L)
        } else {
          toml$children[[child]][3]
        }
      }
    }))
  } else if (type %in% c("bare_key", "quoted_key")) {
    # This is a selected subtable. Check the next part of the dotted key
    dot <- toml$parent[idx]
    # find the root of the dotted keys first
    while (toml$type[toml$parent[dot]] == "dotted_key") {
      dot <- toml$parent[dot]
    }
    dotchildren <- get_dotted_key_components(toml, dot)
    nextkeyidx <- which(dotchildren == idx) + 1L
    # if this is the last part of the dotted key then select the value
    # or the whole table. otherwise select the next part of the dotted key
    if (nextkeyidx == length(dotchildren)) {
      parent <- toml$parent[dot]
      if (toml$type[parent] == "table") {
        parent
      } else {
        toml$children[[parent]][3]
      }
    } else {
      dotchildren[nextkeyidx]
    }
  } else if (type == "inline_table") {
    # inline table, select keys inside
    children <- toml$children[[idx]]
    children <- children[toml$type[children] == "pair"]
    unlist(lapply(children, function(child) {
      keyid <- toml$children[[child]][1]
      # if this is a pair with a dotted key then a subtable is selected
      # we represent this by selecting the first key in the dotted key
      if (toml$type[keyid] == "dotted_key") {
        get_dotted_key_component(toml, keyid, 1L)
      } else {
        toml$children[[child]][3]
      }
    }))
  } else if (type == "array") {
    children <- toml$children[[idx]]
    children[!toml$type[children] %in% c("[", "]", ",", "comment")]
  } else if (type == "table_array_element") {
    # select this element of the array, we denote that by selecting its
    # key element
    toml$children[[idx]][2]
  } else {
    # string, integer, float, boolean, datetime
    integer()
  }
}

select1_key <- function(toml, idx, slt) {
  type <- toml$type[idx]
  # This is AOT _element_, so we need to take its parent AOT and treat is
  # like a table
  if (
    !is.na(toml$parent[idx]) &&
      toml$type[toml$parent[idx]] == "table_array_element" &&
      toml$type[idx] %in% c("bare_key", "quoted_key", "dotted_key")
  ) {
    idx <- toml$parent[idx]
    type <- "table"
  }

  if (type %in% c("document", "table")) {
    children <- toml$children[[idx]]
    unlist(lapply(children, function(child) {
      ctype <- toml$type[child]
      if (ctype == "table" || ctype == "table_array_element") {
        keyid <- toml$children[[child]][2]
        key <- unserialize_key(toml, keyid)
        key1 <- key[1]
        if (key1 %in% slt) {
          # if this is a table with a dotted key then a subtable is selected
          # we represent this by selecting the first key in the dotted key
          if (toml$type[keyid] == "dotted_key") {
            get_dotted_key_component(toml, keyid, 1L)
          } else {
            child
          }
        }
      } else if (ctype == "pair") {
        keyid <- toml$children[[child]][1]
        key <- unserialize_key(toml, keyid)
        key1 <- key[1]
        if (key1 %in% slt) {
          # if this is a pair with a dotted key then a subtable is selected
          # we represent this by selecting the first key in the dotted key
          if (toml$type[keyid] == "dotted_key") {
            get_dotted_key_component(toml, keyid, 1L)
          } else {
            toml$children[[child]][3]
          }
        }
      }
    }))
  } else if (type %in% c("bare_key", "quoted_key")) {
    # This is a selected subtable. Check the next part of the dotted key
    dot <- toml$parent[idx]
    # find the root of the dotted keys first
    while (toml$type[toml$parent[dot]] == "dotted_key") {
      dot <- toml$parent[dot]
    }
    dotchildren <- get_dotted_key_components(toml, dot)
    nextkeyidx <- which(dotchildren == idx) + 1L
    nextkeyid <- dotchildren[nextkeyidx]
    nextkey <- unserialize_key(toml, nextkeyid)
    if (nextkey %in% slt) {
      # if this is the last part of the dotted key then select the value
      # or the whole table. otherwise select the next part of the dotted key
      if (nextkeyidx == length(dotchildren)) {
        parent <- toml$parent[dot]
        if (toml$type[parent] == "table") {
          parent
        } else {
          toml$children[[parent]][3]
        }
      } else {
        nextkeyid
      }
    }
  } else if (type == "inline_table") {
    # inline table, select keys inside
    children <- toml$children[[idx]]
    children <- children[toml$type[children] == "pair"]
    unlist(lapply(children, function(child) {
      keyid <- toml$children[[child]][1]
      key <- unserialize_key(toml, keyid)
      key1 <- key[1]
      if (key1 %in% slt) {
        # if this is a pair with a dotted key then a subtable is selected
        # we represent this by selecting the first key in the dotted key
        if (toml$type[keyid] == "dotted_key") {
          get_dotted_key_component(toml, keyid, 1L)
        } else {
          toml$children[[child]][3]
        }
      }
    }))
  } else {
    # table_array_element, string, integer, float, boolean, datetime, array
    integer()
  }
}

get_dotted_key_components <- function(toml, keyid) {
  type <- toml$type[keyid]
  if (type == "dotted_key") {
    unlist(c(
      get_dotted_key_components(toml, toml$children[[keyid]][1]),
      get_dotted_key_components(toml, toml$children[[keyid]][3])
    ))
  } else {
    keyid
  }
}

get_dotted_key_component <- function(toml, keyid, idx) {
  comps <- get_dotted_key_components(toml, keyid)
  comps[idx]
}

select1_numeric <- function(toml, idx, slt) {
  if (any(slt == 0)) {
    stop(cnd("Zero indices are not allowed in JSON selectors."))
  }
  type <- toml$type[idx]
  # This is AOT _element_, so we need to take its parent AOT and treat is
  # like a table
  if (
    !is.na(toml$parent[idx]) &&
      toml$type[toml$parent[idx]] == "table_array_element" &&
      toml$type[idx] %in% c("bare_key", "quoted_key", "dotted_key")
  ) {
    idx <- toml$parent[idx]
    type <- "table"
  }
  if (type %in% c("array", "document", "table", "inline_table")) {
    chdn <- toml$children[[idx]]
    if (type == "table") {
      chdn <- chdn[-(1:3)] # remove the table header
    }
    chdn <- chdn[!toml$type[chdn] %in% c("[", "]", "{", "}", ",", "comment")]
    res <- integer(length(slt))
    pos <- slt >= 0
    if (any(pos)) {
      res[pos] <- chdn[slt[pos]]
    }
    if (any(!pos)) {
      res[!pos] <- rev(rev(chdn)[abs(slt[!pos])])
    }
    pairs <- toml$type[res] == "pair"
    res[pairs] <- map_int(res[pairs], function(pair) {
      toml$children[[pair]][3]
    })
    res
    aots <- toml$type[res] == "table_array_element"
    res[aots] <- map_int(res[aots], function(aot) {
      toml$children[[aot]][2]
    })
    res
  } else if (type %in% c("bare_key", "quoted_key")) {
    # This is a selected subtable. It always has a single element!
    if (!1 %in% slt && !-1 %in% slt) {
      integer()
    } else {
      # Check the next part of the dotted key
      dot <- toml$parent[idx]
      # find the root of the dotted keys first
      while (toml$type[toml$parent[dot]] == "dotted_key") {
        dot <- toml$parent[dot]
      }
      dotchildren <- get_dotted_key_components(toml, dot)
      nextkeyidx <- which(dotchildren == idx) + 1L
      nextkeyid <- dotchildren[nextkeyidx]
      # if this is the last part of the dotted key then select the value
      # or the whole table. otherwise select the next part of the dotted key
      if (nextkeyidx == length(dotchildren)) {
        parent <- toml$parent[dot]
        if (toml$type[parent] == "table") {
          parent
        } else {
          toml$children[[parent]][3]
        }
      } else {
        nextkeyid
      }
    }
  } else if (
    toml$array_position[idx] %in% slt || toml$rev_array_position[idx] %in% slt
  ) {
    # select this element of the array, we denote that by selecting its
    # key element
    toml$children[[idx]][2]
  } else {
    # string, integer, float, boolean, datetime
    integer()
  }
  # TODO:
  # - table_array_element
  #
}
