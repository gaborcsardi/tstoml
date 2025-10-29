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
  top <- toml$children[[1]]
  top <- top[toml$type[top] != "comment"]
  list(
    list(
      selector = sel_default(),
      nodes = if (length(top) > 0) top else 1L
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
#'
#' @export

select_query <- function(toml, query) {
  text <- attr(toml, "text")
  mch <- query_toml(text = text, query = query)$matched_captures
  ids <- if (nrow(mch) == 0) {
    integer()
  } else {
    toml0 <- toml[
      toml$start_byte %in% mch$start_byte & toml$end_byte %in% mch$end_byte,
    ]
    mkeys <- paste0(mch$type, ":", mch$start_byte, ":", mch$end_byte)
    jkeys <- paste0(toml0$type, ":", toml0$start_byte, ":", toml0$end_byte)
    toml0$id[match(mkeys, jkeys)]
  }
  toml |> select(sel_ids(ids))
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
  # if 'document' is selected, that means there is no selection
  if (identical(current[[1]]$nodes, 1L)) {
    attr(toml, "selection") <- NULL
  } else {
    attr(toml, "selection") <- current
  }
  toml
}

select1 <- function(toml, idx, slt) {
  sel <- if (inherits(slt, "tstoml_selector_ids")) {
    return(slt$ids)
  } else {
    stop("Invalid TOML selector")
  }

  sel
}
