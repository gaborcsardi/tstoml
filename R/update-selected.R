#' Replace selected TOML values with new content
#'
#' Replace all selected elements with a new element. If `toml` has no
#' selection then the whole document is replaced. If `toml` has an empty
#' selection, then nothing happens.
#'
#' @param toml A tstoml object
#' @param new A R object to be converted to TOML using [serialize_toml_value()]
#'  and used as the new value.
#' @param options A named list of `tstoml` options, see
#'   [tstoml_options()]. Passed to [serialize_toml_value()].
#' @export

update_selected <- function(toml, new, options = NULL) {
  selection <- get_selection(toml)
  ptr <- length(selection)
  select <- selection[[ptr]]$nodes

  types <- toml$type[select]
  if (any(!types %in% value_types)) {
    stop(cnd(
      "Can only update values ({collapse(value_types)})."
    ))
  }

  fmt <- replicate(
    length(select),
    serialize_toml_value(new, options = options),
    simplify = FALSE
  )

  # keep original indentation at the start row
  for (i in seq_along(select)) {
    sel1 <- select[i]
    prevline <- rev(which(toml$end_row == toml$start_row[sel1] - 1))[1]
    ind0 <- sub("^.*\n", "", toml$tws[prevline])
    if (!is.na(prevline)) {
      fmt[[i]] <- paste0(c("", rep(ind0, length(fmt[[i]]) - 1L)), fmt[[i]])
    }
  }

  subtrees <- lapply(select, get_dom_subtree, toml = toml, with_root = TRUE)
  subtrees <- lapply(subtrees, function(st) {
    unlist(lapply(st, get_subtree, toml = toml, with_root = TRUE))
  })
  deleted <- unique(unlist(subtrees))

  # need to keep the trailing ws of the last element
  lasts <- map_int(subtrees, max_or_na)
  tws <- toml$tws[lasts]
  toml$code[deleted] <- NA_character_
  toml$tws[deleted] <- NA_character_

  # keep select nodes to inject the new elements
  toml$code[select] <- paste0(
    map_chr(fmt, paste, collapse = "\n"),
    ifelse(is.na(tws), "", tws)
  )
  toml$tws[select] <- NA_character_

  parts <- c(rbind(toml$code, toml$tws))
  text <- unlist(lapply(na_omit(parts), charToRaw))

  # TODO: update coordinates without reparsing
  new <- load_toml(text = text)
  attr(new, "file") <- attr(toml, "file")

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
