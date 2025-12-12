#' Replace selected TOML values with new content
#'
#' Replace all selected elements with a new element. If `toml` has no
#' selection then the whole document is replaced. If `toml` has an empty
#' selection, then nothing happens.
#'
#' @param tree A tstoml object
#' @param new A R object to be converted to TOML using [ts_serialize_toml_value()]
#'  and used as the new value.
#' @param options A named list of `tstoml` options, see
#'   [tstoml_options()]. Passed to [ts_serialize_toml_value()].
#' @param ... Reserved for future use.
#' @export
#' @keywords internal

ts_tree_update.ts_tree_toml <- function(tree, new, options = NULL, ...) {
  selection <- ts_tree_selection(tree)
  ptr <- length(selection)
  select <- selection[[ptr]]$nodes

  types <- tree$type[select]
  if (any(!types %in% value_types)) {
    stop(ts_cnd(
      "Can only update values ({ts_collapse(value_types)})."
    ))
  }

  fmt <- replicate(
    length(select),
    ts_serialize_toml_value(new, options = options),
    simplify = FALSE
  )

  # keep original indentation at the start row
  for (i in seq_along(select)) {
    sel1 <- select[i]
    prevline <- rev(which(tree$end_row == tree$start_row[sel1] - 1))[1]
    ind0 <- sub("^.*\n", "", tree$tws[prevline])
    if (!is.na(prevline)) {
      fmt[[i]] <- paste0(c("", rep(ind0, length(fmt[[i]]) - 1L)), fmt[[i]])
    }
  }

  subtrees <- lapply(select, get_dom_subtree, tree = tree, with_root = TRUE)
  subtrees <- lapply(subtrees, function(st) {
    unlist(lapply(st, get_subtree, tree = tree, with_root = TRUE))
  })
  deleted <- unique(unlist(subtrees))

  # need to keep the trailing ws of the last element
  lasts <- map_int(subtrees, max_or_na)
  tws <- tree$tws[lasts]
  tree$code[deleted] <- NA_character_
  tree$tws[deleted] <- NA_character_

  # keep select nodes to inject the new elements
  tree$code[select] <- paste0(
    map_chr(fmt, paste, collapse = "\n"),
    ifelse(is.na(tws), "", tws)
  )
  tree$tws[select] <- NA_character_

  parts <- c(rbind(tree$code, tree$tws))
  text <- unlist(lapply(na_omit(parts), charToRaw))

  # TODO: update coordinates without reparsing
  new <- ts_parse_toml(text = text)
  attr(new, "file") <- attr(tree, "file")

  new
}

value_types <- c(
  "string",
  "integer",
  "float",
  "boolean",
  "offset_date_time",
  "local_date_time",
  "local_date",
  "local_time",
  "array",
  "inline_table"
)
