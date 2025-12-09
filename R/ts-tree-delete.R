#' Delete selected elements from a tstoml object
#'
#' The formatting of the rest of TOML document is kept as is. Comments
#' appearing inside the deleted elements are also deleted. Other comments
#' are left as is.
#'
#' @details
#' If `toml` has no selection then the the whole document is deleted.
#' If `toml` has an empty selection, then nothing is delted.
#'
#' @param toml tstoml object.
#' @return Modified tstoml object.
#'
#' @export
#' @examples
#' toml <- load_toml(text = toml_example_text())
#' toml
#'
#' toml |> select("owner", "name") |> delete_selected()
#' toml |> select("owner") |> delete_selected()

delete_selected <- function(toml) {
  select <- get_selected_nodes(toml)

  if (length(select) == 0) {
    attr(toml, "selection") <- NULL
    return(toml)
  }

  # if deleting from an array, then we need to look at the array and
  # remove some commas, probably
  pares <- toml$parent[select]
  ptypes <- toml$type[pares]
  trimmed_arrays <- unique(pares[ptypes == "array"])
  trimmed_pairs <- pares[ptypes == "pair"]
  select <- c(select, trimmed_pairs)
  trimmed_objects <- unique(toml$parent[trimmed_pairs])
  trimmed_objects <- trimmed_objects[
    toml$type[trimmed_objects] == "inline_table"
  ]

  # get the full subtree of nodes to delete
  subtrees <- lapply(select, get_dom_subtree, toml = toml, with_root = TRUE)
  subtrees <- lapply(subtrees, function(st) {
    unlist(lapply(st, get_subtree, toml = toml, with_root = TRUE))
  })
  deleted <- unique(unlist(subtrees))

  # if deleting an AOT element, remove the whole element
  del_pares <- toml$parent[deleted]
  aot_elements <- (toml$type[deleted] %in% key_types) &
    toml$type[del_pares] == "table_array_element"
  deleted <- unique(c(deleted, unlist(toml$children[del_pares[aot_elements]])))

  trim_commas <- function(id, open, close) {
    # remove deleted children and see what is left
    allchld <- toml$children[[id]]
    chld <- setdiff(allchld, deleted)
    nc <- length(chld)
    # if nothing left, then nothing to do
    if (nc == 2) {
      return()
    }
    ctypes <- toml$type[chld]
    todel <- rep(FALSE, length(chld))
    # this is hard to write in a vectorized form, it is easier iteratively
    # leading commas
    for (i in seq_along(todel)[-1]) {
      if (ctypes[i] == ',') {
        todel[i] <- TRUE
      } else {
        break
      }
    }
    # trailing commas
    for (i in rev(seq_along(todel))[-1]) {
      if (ctypes[i] == ',') {
        todel[i] <- TRUE
      } else {
        break
      }
    }
    # duplicate commas
    todel[ctypes[-nc] == ',' & ctypes[-1] == ','] <- TRUE
    chdel <- chld[which(todel)]
    deleted <<- c(deleted, chdel)

    # if the last element is deleted, take the trailing whitespace of
    # its last token and add it to the last token of the last kept element
    chdeld <- intersect(allchld, deleted)
    chkept <- setdiff(allchld, chdeld)
    last_deld <- chdeld[length(chdeld)]
    last_kept <- chkept[length(chkept) - 1L]
    if (last_deld > last_kept) {
      while (is.na(toml$code[last_deld])) {
        last_deld <- utils::tail(toml$children[[last_deld]], 1)
      }
      while (is.na(toml$code[last_kept])) {
        last_kept <- utils::tail(toml$children[[last_kept]], 1)
      }
      toml$tws[last_kept] <<- toml$tws[last_deld]
    }
  }

  # trim commas from arrays
  trimmed_arrays <- setdiff(trimmed_arrays, deleted)
  for (arr in trimmed_arrays) {
    trim_commas(arr, "[", "]")
  }

  # trim pairs and commas from objects
  trimmed_objects <- setdiff(trimmed_objects, deleted)
  for (obj in trimmed_objects) {
    trim_commas(obj, "{", "}")
  }

  # NA happens if the whole document is deleted, the parent of 1 is NA
  toml2 <- toml[-na_omit(deleted), ]

  # update text
  parts <- c(rbind(toml2$code, toml2$tws))
  text <- as.raw(unlist(lapply(na_omit(parts), charToRaw)))

  # TODO: update coordinates without reparsing
  new <- load_toml(text = text)
  attr(new, "file") <- attr(toml, "file")

  new
}

key_types <- c("bare_key", "quoted_key", "dotted_key")
